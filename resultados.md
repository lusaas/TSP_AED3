# Resultados das execuções do TSP

Data das execuções: 30/09/2026.

O algoritmo exato foi limitado a 60 segundos por instância. O valor ótimo de referência foi extraído do nome de cada arquivo. O gap percentual foi calculado por:

$$
\operatorname{gap}(\%) = \frac{C_{solução} - C_{\text{ótimo}}}{C_{\text{ótimo}}} \times 100
$$

## Algoritmo exato — execuções concluídas

| Instância | Cidades | Ótimo do nome | Tempo (s) | Custo obtido | Gap para o ótimo |
|---|---:|---:|---:|---:|---:|
| `tsp1_253.txt` | 11 | 253 | 0,565949 | 254 | 0,3953% |
| `tsp2_1248.txt` | 6 | 1248 | 0,000032 | 1248 | 0,0000% |
| `tsp3_1194.txt` | 15 | 1194 | 0,046648 | 1194 | 0,0000% |

> **Observação:** o programa exato retornou custo 254 para `tsp1_253.txt`, enquanto o ótimo informado no nome é 253. O valor registrado é o resultado efetivamente produzido, sem alteração do código.

## Instâncias sem resultado exato

- `tsp4_7013.txt`: excedeu o limite de 60 segundos.
- `tsp5_27603.txt`: excedeu o limite de 60 segundos.

Para essas instâncias, devem ser considerados somente o tempo, o custo e o gap do algoritmo aproximativo apresentados a seguir.

## Algoritmo aproximativo — vizinho mais próximo

| Instância | Cidades | Ótimo do nome | Tempo (s) | Custo obtido | Diferença absoluta | Gap para o ótimo |
|---|---:|---:|---:|---:|---:|---:|
| `tsp1_253.txt` | 11 | 253 | 0,000011 | 299 | 46 | 18,1818% |
| `tsp2_1248.txt` | 6 | 1248 | 0,000013 | 1272 | 24 | 1,9231% |
| `tsp3_1194.txt` | 15 | 1194 | 0,000011 | 1260 | 66 | 5,5276% |
| `tsp4_7013.txt` | 44 | 7013 | 0,000017 | 10587 | 3574 | 50,9625% |
| `tsp5_27603.txt` | 29 | 27603 | 0,000015 | 36399 | 8796 | 31,8661% |

Os tempos são os valores internos impressos pelos programas. Os fontes são compilados em um diretório temporário, removido automaticamente ao final; nenhum arquivo de código-fonte é alterado.
