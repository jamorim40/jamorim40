--Função PIVOT e UNPIVOT
SELECT	NumeroPedido,
		MONTH(DataPedido) AS MÊS,
		SUM(Frete) AS TOTAL_FRETE
FROM TB_PEDIDO
WHERE YEAR(DataPedido) = 1998
GROUP BY NumeroPedido, MONTH(DataPedido), YEAR(DataPedido)
ORDER BY 1,2,3

--Usando o PIVOT

SELECT	NumeroPedido, 
		ISNULL([1],0) AS 'MÊS 1',
		ISNULL([2],0) AS 'MÊS 2',
		ISNULL([3],0) AS 'MÊS 3',
		ISNULL([4],0) AS 'MÊS 4',
		ISNULL([5],0) AS 'MÊS 5',
		ISNULL([6],0) AS 'MÊS 6',
		ISNULL([7],0) AS 'MÊS 7',
		ISNULL([8],0) AS 'MÊS 8',
		ISNULL([9],0) AS 'MÊS 9',
		ISNULL([10],0) AS 'MÊS 10',
		ISNULL([11],0) AS 'MÊS 11',
		ISNULL([12],0) AS 'MÊS 12'

FROM (SELECT	NumeroPedido,
				MONTH(DataPedido) AS MÊS,
				SUM(Frete) AS TOTAL_FRETE
		FROM TB_PEDIDO
		WHERE YEAR(DataPedido) = 1998
		GROUP BY NumeroPedido, MONTH(DataPedido)) C1
PIVOT(SUM(C1.TOTAL_FRETE) FOR C1.MÊS IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS PVT
ORDER BY 1
GO

/*
						=====EXPLICAÇÃO=====
### **Objetivo da Query**
Essa consulta usa a função **PIVOT** para transformar os dados da tabela `TB_PEDIDO`, que originalmente estão organizados em linhas, em colunas dinâmicas. O objetivo é exibir o valor total de frete pago (`SUM(Frete)`) por número de pedido (`NumeroPedido`), distribuído por mês no ano de **1998**.

---

### **Explicação por Partes**

#### **1. Subconsulta Inicial (`C1`)**
A subconsulta (`C1`) é responsável por obter os dados necessários antes da aplicação do `PIVOT`:

```sql
SELECT NumeroPedido,
       MONTH(DataPedido) AS MÊS,
       SUM(Frete) AS TOTAL_FRETE
FROM TB_PEDIDO
WHERE YEAR(DataPedido) = 1998
GROUP BY NumeroPedido, MONTH(DataPedido)
```

- **`NumeroPedido`** ? Identifica cada pedido.
- **`MONTH(DataPedido)`** ? Extrai o número do mês da data do pedido (`1` para janeiro, `2` para fevereiro etc.).
- **`SUM(Frete)`** ? Calcula o total de frete pago para cada pedido, agrupando os valores por `NumeroPedido` e mês.
- **`WHERE YEAR(DataPedido) = 1998`** ? Filtra apenas os pedidos do ano **1998**.
- **`GROUP BY NumeroPedido, MONTH(DataPedido)`** ? Garante que os valores de `Frete` sejam somados corretamente para cada pedido e mês.

?? **Resultado esperado da subconsulta:**  
Uma tabela contendo o `NumeroPedido`, o número do mês (`MÊS`) e o total de frete pago (`TOTAL_FRETE`).

| NumeroPedido | MÊS | TOTAL_FRETE |
|-------------|----|------------|
| 10100       | 1  | 25.00      |
| 10100       | 3  | 30.50      |
| 10101       | 2  | 20.00      |
| 10102       | 3  | 50.00      |

---

#### **2. Aplicação do `PIVOT`**
Agora, essa tabela intermediária (`C1`) é transformada usando a função `PIVOT`:

```sql
PIVOT(
    SUM(C1.TOTAL_FRETE) 
    FOR C1.MÊS IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS PVT
```

- **`SUM(C1.TOTAL_FRETE)`** ? Soma os valores do frete para cada combinação de pedido e mês.
- **`FOR C1.MÊS IN ([1],[2],...[12])`** ? Define que os valores únicos de `MÊS` devem se tornar colunas (janeiro a dezembro).

?? **Resultado esperado após o `PIVOT`**  
A tabela se transforma, agrupando os valores de frete em colunas de meses:

| NumeroPedido | MÊS 1 | MÊS 2 | MÊS 3 | ... | MÊS 12 |
|-------------|------|------|------|-----|------|
| 10100       | 25.00 | 0.00  | 30.50 | ... | 0.00  |
| 10101       | 0.00  | 20.00 | 0.00  | ... | 0.00  |
| 10102       | 0.00  | 0.00  | 50.00 | ... | 0.00  |

---

#### **3. Tratamento de Valores `NULL`**
Depois do `PIVOT`, se um pedido não tiver valores para um determinado mês, o SQL Server retornará `NULL` nessas colunas. Para evitar isso, usamos `ISNULL` para substituir `NULL` por `0`:

```sql
ISNULL([1],0) AS 'MÊS 1',
ISNULL([2],0) AS 'MÊS 2',
...
ISNULL([12],0) AS 'MÊS 12'
```

Agora, se um pedido não tiver frete em determinado mês, aparecerá `0` em vez de `NULL`.

---

#### **4. Ordenação Final**
```sql
ORDER BY 1
```
- Ordena os resultados pela primeira coluna (`NumeroPedido`).

---

### **Resumo da Query**
1. **Seleciona os pedidos do ano de 1998.**
2. **Agrupa os pedidos por número e mês, somando o frete.**
3. **Aplica a função `PIVOT` para transformar os meses em colunas.**
4. **Substitui valores `NULL` por `0` para evitar campos vazios.**
5. **Ordena os pedidos pelo número.**

Esse método facilita análises de valores mensais e permite uma visualização mais estruturada dos dados.
*/

--UNPIVOT

CREATE TABLE TB_UNPIVOT
(
	NumeroPedido INT NULL,
	MES1 INT NULL,
	MES2 INT NULL,
	MES3 INT NULL,
	MES4 INT NULL,
	MES5 INT NULL,
	MES6 INT NULL,
	MES7 INT NULL,
	MES8 INT NULL,
	MES9 INT NULL,
	MES10 INT NULL,
	MES11 INT NULL,
	MES12 INT NULL
)
GO

INSERT INTO TB_UNPIVOT
SELECT NumeroPedido, 
		ISNULL([1],0) AS 'MÊS 1',
		ISNULL([2],0) AS 'MÊS 2',
		ISNULL([3],0) AS 'MÊS 3',
		ISNULL([4],0) AS 'MÊS 4',
		ISNULL([5],0) AS 'MÊS 5',
		ISNULL([6],0) AS 'MÊS 6',
		ISNULL([7],0) AS 'MÊS 7',
		ISNULL([8],0) AS 'MÊS 8',
		ISNULL([9],0) AS 'MÊS 9',
		ISNULL([10],0) AS 'MÊS 10',
		ISNULL([11],0) AS 'MÊS 11',
		ISNULL([12],0) AS 'MÊS 12'

FROM (SELECT	NumeroPedido,
				MONTH(DataPedido) AS MÊS,
				SUM(Frete) AS TOTAL_FRETE
		FROM TB_PEDIDO
		WHERE YEAR(DataPedido) = 1998
		GROUP BY NumeroPedido, MONTH(DataPedido)) C1
PIVOT(SUM(C1.TOTAL_FRETE) FOR C1.MÊS IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS PVT
ORDER BY 1

--UNPIVOT

SELECT	NumeroPedido, MES, TOTAL_VENDAS
FROM ( SELECT	NumeroPedido,
				MES1,MES2,MES3,MES4,MES5,MES6,MES7,MES8,MES9,MES10,MES11,MES12
		FROM TB_UNPIVOT) P
		UNPIVOT (TOTAL_VENDAS FOR MES IN (MES1,MES2,MES3,MES4,MES5,MES6,MES7,MES8,MES9,MES10,MES11,MES12)) AS UP

/*
							=====EXPLICAÇÃO=====

Aqui está a explicação detalhada da consulta SQL que utiliza a função `UNPIVOT`.  

---

### **Objetivo da Consulta**
A consulta transforma dados que estão em um formato de colunas (dados normalizados) em um formato de linhas (dados desnormalizados). Ou seja, ela converte as colunas **MES1 a MES12** em uma única coluna chamada **MES**, com os valores correspondentes de vendas sendo armazenados na coluna **TOTAL_VENDAS**.

---

### **Quebra da Consulta em Etapas**
1. **Consulta Interna (`FROM TB_UNPIVOT`)**
   ```sql
   FROM ( SELECT NumeroPedido,
                 MES1, MES2, MES3, MES4, MES5, MES6, 
                 MES7, MES8, MES9, MES10, MES11, MES12
          FROM TB_UNPIVOT
   ) P
   ```
   - Aqui, selecionamos a tabela `TB_UNPIVOT`, que contém as vendas mensais distribuídas em 12 colunas (uma para cada mês, de **MES1 a MES12**).
   - A tabela possui, pelo menos, as colunas:
     - `NumeroPedido` ? Número do pedido.
     - `MES1` a `MES12` ? Total de vendas de cada mês.

2. **Aplicação do `UNPIVOT`**
   ```sql
   UNPIVOT (TOTAL_VENDAS FOR MES IN (MES1, MES2, MES3, MES4, MES5, MES6, 
                                     MES7, MES8, MES9, MES10, MES11, MES12)) AS UP
   ```
   - O `UNPIVOT` transforma as colunas **MES1 a MES12** em valores de linha na nova coluna chamada **MES**.
   - A cada iteração, o valor de cada coluna mensal é armazenado na coluna **TOTAL_VENDAS**.
   - O nome da coluna contendo os nomes originais das colunas (MES1, MES2, etc.) será **MES**.

3. **Saída Final**
   ```sql
   SELECT NumeroPedido, MES, TOTAL_VENDAS
   ```
   - Selecionamos os dados transformados:
     - `NumeroPedido`: Identificação do pedido.
     - `MES`: Indica o mês original da venda (exemplo: MES1, MES2, etc.).
     - `TOTAL_VENDAS`: Valor total de vendas correspondente ao mês.

---

### **Exemplo de Entrada e Saída**
#### **Entrada (TB_UNPIVOT)**
| NumeroPedido | MES1 | MES2 | MES3 | MES4 | MES5 | MES6 |
|-------------|------|------|------|------|------|------|
| 1001        | 500  | 600  | 300  | 800  | 900  | 700  |
| 1002        | 450  | 550  | 250  | 750  | 850  | 650  |

#### **Saída Após o `UNPIVOT`**
| NumeroPedido | MES  | TOTAL_VENDAS |
|-------------|------|--------------|
| 1001        | MES1 | 500          |
| 1001        | MES2 | 600          |
| 1001        | MES3 | 300          |
| 1001        | MES4 | 800          |
| 1001        | MES5 | 900          |
| 1001        | MES6 | 700          |
| 1002        | MES1 | 450          |
| 1002        | MES2 | 550          |
| 1002        | MES3 | 250          |
| 1002        | MES4 | 750          |
| 1002        | MES5 | 850          |
| 1002        | MES6 | 650          |

---

### **Conclusão**
- O `UNPIVOT` ajuda a transformar colunas em linhas, tornando os dados mais fáceis de manipular e analisar.
- Essa consulta é útil para relatórios e análises, pois permite trabalhar com dados de meses como uma única coluna em vez de 12 colunas separadas.
- A nova coluna **MES** mantém a referência ao mês original de cada valor de vendas.

*/