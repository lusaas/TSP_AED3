# TSP — Algoritmos Exato e Aproximativo

Este projeto compara duas abordagens para o Problema do Caixeiro Viajante (TSP):

- **Algoritmo exato:** Branch and Bound;
- **Algoritmo aproximativo:** heurística do Vizinho Mais Próximo.


## Arquivos necessários

| Arquivo | Descrição |
|---|---|
| `tsp_exato.cpp` | Implementação exata por Branch and Bound. |
| `tsp_aprox.cpp` | Implementação aproximativa pelo Vizinho Mais Próximo. |
| `executar_experimentos.sh` | Compila e executa automaticamente todos os experimentos. |
| `tsp1_253.txt` | Instância com ótimo de referência 253. |
| `tsp2_1248.txt` | Instância com ótimo de referência 1248. |
| `tsp3_1194.txt` | Instância com ótimo de referência 1194. |
| `tsp4_7013.txt` | Instância com ótimo de referência 7013. |
| `tsp5_27603.txt` | Instância com ótimo de referência 27603. |

## Dependências

O procedimento automatizado foi preparado para Linux e requer:

- Bash;
- compilador `g++` com suporte a C++17;
- GNU Coreutils, principalmente o comando `timeout`;
- `awk`, `grep`, `date` e `mktemp`.

### Ubuntu, Debian e derivados

```bash
sudo apt update
sudo apt install build-essential coreutils gawk grep
```

Para conferir as ferramentas principais:

```bash
g++ --version
bash --version
timeout --version
awk --version
```

## Execução automatizada

Esta é a forma recomendada de executar os experimentos completos.

### 1. Acesse o diretório do projeto

```bash
cd /home/user/<diretorio-do-projeto>
```

### 2. Execute os experimentos

```bash
./executar_experimentos.sh
```

## Compilação manual

Para criar executáveis Linux diretamente no diretório do projeto:

```bash
g++ -O2 -std=c++17 tsp_exato.cpp -o tsp_exato
g++ -O2 -std=c++17 tsp_aprox.cpp -o tsp_aprox
```

## Execução manual

### Executar todas as instâncias

Sem argumentos, cada programa usa automaticamente os cinco arquivos de instância:

```bash
./tsp_aprox
./tsp_exato
```

### Executar uma instância específica

```bash
./tsp_aprox tsp1_253.txt
timeout --signal=TERM --kill-after=2s 60s ./tsp_exato tsp1_253.txt
```

### Executar várias instâncias escolhidas

```bash
./tsp_aprox tsp1_253.txt tsp2_1248.txt
./tsp_exato tsp1_253.txt tsp2_1248.txt
```