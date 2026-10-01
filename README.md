# TSP — Algoritmos Exato e Aproximativo

Este projeto compara duas abordagens para o Problema do Caixeiro Viajante (TSP):

- **Algoritmo exato:** Branch and Bound;
- **Algoritmo aproximativo:** heurística do Vizinho Mais Próximo.

Cada programa lê uma matriz de custos a partir de um arquivo `.txt`. O projeto também inclui um script que compila os dois programas, executa todos os experimentos, limita o algoritmo exato a 60 segundos por instância e gera um relatório Markdown com tempos, custos e gaps.

## Arquivos necessários

Os dois fontes, o script e as cinco instâncias devem permanecer no mesmo diretório. O relatório não precisa existir antes da execução, pois será criado ou substituído pelo script.

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
| `resultados.md` | Saída gerada pelas execuções; não é um arquivo de entrada obrigatório. |

Os arquivos `tsp_exato.exe` e `tsp_aprox.exe` fornecidos no diretório são executáveis do Windows. Eles não são necessários para compilar ou executar o projeto no Linux.

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

### Fedora

```bash
sudo dnf install gcc-c++ coreutils gawk grep
```

### Arch Linux e derivados

```bash
sudo pacman -S base-devel coreutils gawk grep
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

### 2. Garanta a permissão de execução do script

Esse comando normalmente só precisa ser executado uma vez:

```bash
chmod +x executar_experimentos.sh
```

### 3. Execute os experimentos

```bash
./executar_experimentos.sh
```

O script realiza automaticamente as seguintes etapas:

1. Confere se os fontes e as cinco instâncias estão presentes;
2. verifica se as ferramentas necessárias estão instaladas;
3. compila os dois programas com `g++ -O2 -std=c++17`;
4. executa os algoritmos aproximativo e exato para cada instância;
5. encerra cada execução exata que ultrapassar 60 segundos;
6. extrai os tempos e custos produzidos pelos programas;
7. calcula o gap em relação ao ótimo indicado no nome do arquivo;
8. grava o relatório em `resultados.md`.

Os binários são criados em um diretório temporário e removidos automaticamente ao final. Os arquivos-fonte não são modificados.

### Escolher outro nome para o relatório

Passe o caminho desejado como primeiro argumento:

```bash
./executar_experimentos.sh meus_resultados.md
```

O experimento completo demora aproximadamente dois minutos, pois as duas maiores instâncias normalmente atingem o limite de 60 segundos no algoritmo exato.

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

Para impor externamente o limite de 60 segundos ao processo exato completo:

```bash
timeout --signal=TERM --kill-after=2s 60s ./tsp_exato
```

Esse comando limita o processo inteiro, não cada instância individualmente. Para aplicar 60 segundos separadamente a cada arquivo, use o script `executar_experimentos.sh` ou execute cada instância de forma isolada.

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

Ao passar vários arquivos ao exato no mesmo comando, o limite interno de 60 segundos é reiniciado para cada instância. Se também for usado um único `timeout` externo, esse limite externo valerá para o processo completo.

## Formato das instâncias

Cada arquivo de entrada deve conter uma matriz quadrada de custos, com valores inteiros separados por espaços ou tabulações. A posição da linha `i` e coluna `j` representa o custo para ir da cidade `i` até a cidade `j`.

Exemplo com três cidades:

```text
0 10 20
10 0 15
20 15 0
```

O nome usado neste projeto segue o padrão `tspN_OTIMO.txt`. O script utiliza o valor depois do sublinhado como referência para o gap por meio da lista de ótimos configurada no próprio script.

## Cálculo da qualidade da solução

O relatório utiliza a seguinte fórmula:

$$
\operatorname{gap}(\%) = \frac{C_{solução} - C_{\text{ótimo}}}{C_{\text{ótimo}}} \times 100
$$

Um gap de `0%` indica que o custo obtido coincide com o ótimo de referência. Quanto maior o gap, mais distante a solução está do valor ótimo.

## Observações

- O algoritmo exato pode consumir muito tempo e memória devido à explosão combinatória;
- as instâncias maiores podem não produzir uma solução exata dentro de 60 segundos;
- nesses casos, o relatório apresenta o resultado aproximativo e seu gap em relação ao valor ótimo fornecido;
- os tempos podem variar conforme o processador, o sistema operacional, a carga da máquina e as opções de compilação;
