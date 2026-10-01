#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

PROJECT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
OUTPUT_FILE=${1:-"$PROJECT_DIR/resultados.md"}
TIME_LIMIT=60

INSTANCES=(
    "tsp1_253.txt"
    "tsp2_1248.txt"
    "tsp3_1194.txt"
    "tsp4_7013.txt"
    "tsp5_27603.txt"
)

OPTIMUMS=(253 1248 1194 7013 27603)

for command_name in g++ timeout awk grep date mktemp; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "Erro: comando obrigatório não encontrado: $command_name" >&2
        exit 1
    fi
done

for required_file in tsp_exato.cpp tsp_aprox.cpp "${INSTANCES[@]}"; do
    if [[ ! -f "$PROJECT_DIR/$required_file" ]]; then
        echo "Erro: arquivo não encontrado: $PROJECT_DIR/$required_file" >&2
        exit 1
    fi
done

TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/tsp_aed3.XXXXXX")
trap 'rm -rf -- "$TEMP_DIR"' EXIT

echo "Compilando os programas em $TEMP_DIR..." >&2
g++ -O2 -std=c++17 "$PROJECT_DIR/tsp_exato.cpp" -o "$TEMP_DIR/tsp_exato"
g++ -O2 -std=c++17 "$PROJECT_DIR/tsp_aprox.cpp" -o "$TEMP_DIR/tsp_aprox"

declare -a CITIES
declare -a APPROX_TIMES
declare -a APPROX_COSTS
declare -a EXACT_TIMES
declare -a EXACT_COSTS
declare -a EXACT_STATUS

calculate_gap() {
    awk -v cost="$1" -v optimum="$2" 'BEGIN { printf "%.4f", 100 * (cost - optimum) / optimum }'
}

for index in "${!INSTANCES[@]}"; do
    instance=${INSTANCES[$index]}
    CITIES[$index]=$(awk 'NF { rows++ } END { print rows + 0 }' "$PROJECT_DIR/$instance")

    echo "Executando aproximativo: $instance" >&2
    approx_output=$(cd "$PROJECT_DIR" && "$TEMP_DIR/tsp_aprox" "$instance")
    APPROX_TIMES[$index]=$(awk -F': ' '/Tempo de execucao:/ { sub(/ s$/, "", $2); print $2; exit }' <<<"$approx_output")
    APPROX_COSTS[$index]=$(awk -F': ' '/Custo total aproximado:/ { print $2; exit }' <<<"$approx_output")

    if [[ -z "${APPROX_TIMES[$index]}" || -z "${APPROX_COSTS[$index]}" ]]; then
        echo "Erro: não foi possível interpretar o resultado aproximativo de $instance" >&2
        exit 1
    fi

    echo "Executando exato (limite de ${TIME_LIMIT}s): $instance" >&2
    set +e
    exact_output=$(cd "$PROJECT_DIR" && timeout --signal=TERM --kill-after=2s "${TIME_LIMIT}s" "$TEMP_DIR/tsp_exato" "$instance" 2>&1)
    exit_code=$?
    set -e

    if [[ $exit_code -eq 124 || $exit_code -eq 137 ]] || grep -q 'Limite de tempo' <<<"$exact_output"; then
        EXACT_STATUS[$index]="timeout"
        echo "Limite excedido: $instance" >&2
    elif [[ $exit_code -ne 0 ]]; then
        EXACT_STATUS[$index]="erro"
        echo "Aviso: o exato falhou para $instance (código $exit_code)." >&2
    else
        EXACT_TIMES[$index]=$(awk -F': ' '/Tempo de execucao:/ { sub(/ s$/, "", $2); print $2; exit }' <<<"$exact_output")
        EXACT_COSTS[$index]=$(awk -F': ' '/Custo minimo encontrado:/ { print $2; exit }' <<<"$exact_output")

        if [[ -n "${EXACT_TIMES[$index]}" && -n "${EXACT_COSTS[$index]}" ]]; then
            EXACT_STATUS[$index]="concluido"
        else
            EXACT_STATUS[$index]="sem_solucao"
        fi
    fi
done

mkdir -p -- "$(dirname -- "$OUTPUT_FILE")"

{
    printf '# Resultados das execuções do TSP\n\n'
    printf 'Data das execuções: %s.\n\n' "$(date +%d/%m/%Y)"
    printf 'O algoritmo exato foi limitado a %d segundos por instância. O valor ótimo de referência foi extraído do nome de cada arquivo. O gap percentual foi calculado por:\n\n' "$TIME_LIMIT"
    printf '$$\n\\operatorname{gap}(\\%%) = \\frac{C_{solução} - C_{\\text{ótimo}}}{C_{\\text{ótimo}}} \\times 100\n$$\n\n'
    printf '## Algoritmo exato — execuções concluídas\n\n'
    printf '| Instância | Cidades | Ótimo do nome | Tempo (s) | Custo obtido | Gap para o ótimo |\n'
    printf '|---|---:|---:|---:|---:|---:|\n'

    for index in "${!INSTANCES[@]}"; do
        if [[ ${EXACT_STATUS[$index]} == "concluido" ]]; then
            gap=$(calculate_gap "${EXACT_COSTS[$index]}" "${OPTIMUMS[$index]}")
            printf '| `%s` | %s | %s | %s | %s | %s%% |\n' \
                "${INSTANCES[$index]}" "${CITIES[$index]}" "${OPTIMUMS[$index]}" \
                "${EXACT_TIMES[$index]/./,}" "${EXACT_COSTS[$index]}" "${gap/./,}"
        fi
    done

    for index in "${!INSTANCES[@]}"; do
        if [[ ${EXACT_STATUS[$index]} == "concluido" && ${EXACT_COSTS[$index]} -ne ${OPTIMUMS[$index]} ]]; then
            printf '\n> **Observação:** o programa exato retornou custo %s para `%s`, enquanto o ótimo informado no nome é %s. O valor registrado é o resultado efetivamente produzido, sem alteração do código.\n' \
                "${EXACT_COSTS[$index]}" "${INSTANCES[$index]}" "${OPTIMUMS[$index]}"
        fi
    done

    printf '\n## Instâncias sem resultado exato\n\n'
    for index in "${!INSTANCES[@]}"; do
        case ${EXACT_STATUS[$index]} in
            timeout)
                printf -- '- `%s`: excedeu o limite de %d segundos.\n' "${INSTANCES[$index]}" "$TIME_LIMIT"
                ;;
            erro)
                printf -- '- `%s`: a execução terminou com erro.\n' "${INSTANCES[$index]}"
                ;;
            sem_solucao)
                printf -- '- `%s`: terminou sem produzir uma rota completa.\n' "${INSTANCES[$index]}"
                ;;
        esac
    done

    printf '\nPara essas instâncias, devem ser considerados somente o tempo, o custo e o gap do algoritmo aproximativo apresentados a seguir.\n\n'
    printf '## Algoritmo aproximativo — vizinho mais próximo\n\n'
    printf '| Instância | Cidades | Ótimo do nome | Tempo (s) | Custo obtido | Diferença absoluta | Gap para o ótimo |\n'
    printf '|---|---:|---:|---:|---:|---:|---:|\n'

    for index in "${!INSTANCES[@]}"; do
        difference=$((APPROX_COSTS[$index] - OPTIMUMS[$index]))
        gap=$(calculate_gap "${APPROX_COSTS[$index]}" "${OPTIMUMS[$index]}")
        printf '| `%s` | %s | %s | %s | %s | %s | %s%% |\n' \
            "${INSTANCES[$index]}" "${CITIES[$index]}" "${OPTIMUMS[$index]}" \
            "${APPROX_TIMES[$index]/./,}" "${APPROX_COSTS[$index]}" "$difference" "${gap/./,}"
    done

    printf '\nOs tempos são os valores internos impressos pelos programas. Os fontes são compilados em um diretório temporário, removido automaticamente ao final; nenhum arquivo de código-fonte é alterado.\n'
} >"$OUTPUT_FILE"

echo "Relatório salvo em: $OUTPUT_FILE" >&2
