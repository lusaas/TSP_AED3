# Resultados das execuções do TSP

Data das execuções: 30/09/2026.

O algoritmo exato foi limitado a 60 segundos por instância. O valor ótimo de referência foi extraído do nome de cada arquivo. O gap percentual foi calculado por:

$$
\operatorname{gap}(\%) = \frac{C_{solução} - C_{ótimo}}{C_{ótimo}} \times 100
$$

## Algoritmo exato — execuções concluídas

| Instância | Cidades | Ótimo do nome | Tempo (s) | Custo obtido | Gap para o ótimo |
|---|---:|---:|---:|---:|---:|
| `tsp1_253.txt` | 11 | 253 | 0,177633 | 254 | 0,3953% |
| `tsp2_1248.txt` | 6 | 1248 | 0,000009 | 1248 | 0,0000% |
| `tsp3_1194.txt` | 15 | 1194 | 0,019884 | 1194 | 0,0000% |

As execuções exatas de `tsp4_7013.txt` (44 cidades) e `tsp5_27603.txt` (29 cidades) excederam o limite de 60 segundos e foram encerradas. Conforme solicitado, para essas instâncias são relatados abaixo somente os resultados do algoritmo aproximativo.

> **Observação:** embora tenha terminado normalmente, o programa exato retornou custo 254 para `tsp1_253.txt`, uma unidade acima do ótimo 253 informado no nome do arquivo. O valor da tabela é o resultado efetivamente produzido pelo programa, sem qualquer alteração no código.

## Algoritmo aproximativo — vizinho mais próximo

| Instância | Cidades | Ótimo do nome | Tempo (s) | Custo obtido | Diferença absoluta | Gap para o ótimo |
|---|---:|---:|---:|---:|---:|---:|
| `tsp1_253.txt` | 11 | 253 | 0,000007 | 299 | 46 | 18,1818% |
| `tsp2_1248.txt` | 6 | 1248 | 0,000005 | 1272 | 24 | 1,9231% |
| `tsp3_1194.txt` | 15 | 1194 | 0,000005 | 1260 | 66 | 5,5276% |
| `tsp4_7013.txt` | 44 | 7013 | 0,000009 | 10587 | 3574 | 50,9625% |
| `tsp5_27603.txt` | 29 | 27603 | 0,000006 | 36399 | 8796 | 31,8661% |

Os tempos apresentados são os tempos internos impressos pelos próprios programas. Como os executáveis fornecidos eram binários do Windows, os mesmos fontes foram compilados em executáveis temporários no Linux apenas para realizar as medições; nenhum arquivo de código-fonte foi alterado durante este trabalho.
