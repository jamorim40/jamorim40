--Fun��o PIVOT e UNPIVOT
SELECT	NumeroPedido,
		MONTH(DataPedido) AS M�S,
		SUM(Frete) AS TOTAL_FRETE
FROM TB_PEDIDO
WHERE YEAR(DataPedido) = 1998
GROUP BY NumeroPedido, MONTH(DataPedido), YEAR(DataPedido)
ORDER BY 1,2,3

--Usando o PIVOT

SELECT	NumeroPedido, 
		ISNULL([1],0) AS 'M�S 1',
		ISNULL([2],0) AS 'M�S 2',
		ISNULL([3],0) AS 'M�S 3',
		ISNULL([4],0) AS 'M�S 4',
		ISNULL([5],0) AS 'M�S 5',
		ISNULL([6],0) AS 'M�S 6',
		ISNULL([7],0) AS 'M�S 7',
		ISNULL([8],0) AS 'M�S 8',
		ISNULL([9],0) AS 'M�S 9',
		ISNULL([10],0) AS 'M�S 10',
		ISNULL([11],0) AS 'M�S 11',
		ISNULL([12],0) AS 'M�S 12'

FROM (SELECT	NumeroPedido,
				MONTH(DataPedido) AS M�S,
				SUM(Frete) AS TOTAL_FRETE
		FROM TB_PEDIDO
		WHERE YEAR(DataPedido) = 1998
		GROUP BY NumeroPedido, MONTH(DataPedido)) C1
PIVOT(SUM(C1.TOTAL_FRETE) FOR C1.M�S IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS PVT
ORDER BY 1
GO

/*
						=====EXPLICA��O=====
### **Objetivo da Query**
Essa consulta usa a fun��o **PIVOT** para transformar os dados da tabela `TB_PEDIDO`, que originalmente est�o organizados em linhas, em colunas din�micas. O objetivo � exibir o valor total de frete pago (`SUM(Frete)`) por n�mero de pedido (`NumeroPedido`), distribu�do por m�s no ano de **1998**.

---

### **Explica��o por Partes**

#### **1. Subconsulta Inicial (`C1`)**
A subconsulta (`C1`) � respons�vel por obter os dados necess�rios antes da aplica��o do `PIVOT`:

```sql
SELECT NumeroPedido,
       MONTH(DataPedido) AS M�S,
       SUM(Frete) AS TOTAL_FRETE
FROM TB_PEDIDO
WHERE YEAR(DataPedido) = 1998
GROUP BY NumeroPedido, MONTH(DataPedido)
```

- **`NumeroPedido`** ? Identifica cada pedido.
- **`MONTH(DataPedido)`** ? Extrai o n�mero do m�s da data do pedido (`1` para janeiro, `2` para fevereiro etc.).
- **`SUM(Frete)`** ? Calcula o total de frete pago para cada pedido, agrupando os valores por `NumeroPedido` e m�s.
- **`WHERE YEAR(DataPedido) = 1998`** ? Filtra apenas os pedidos do ano **1998**.
- **`GROUP BY NumeroPedido, MONTH(DataPedido)`** ? Garante que os valores de `Frete` sejam somados corretamente para cada pedido e m�s.

?? **Resultado esperado da subconsulta:**  
Uma tabela contendo o `NumeroPedido`, o n�mero do m�s (`M�S`) e o total de frete pago (`TOTAL_FRETE`).

| NumeroPedido | M�S | TOTAL_FRETE |
|-------------|----|------------|
| 10100       | 1  | 25.00      |
| 10100       | 3  | 30.50      |
| 10101       | 2  | 20.00      |
| 10102       | 3  | 50.00      |

---

#### **2. Aplica��o do `PIVOT`**
Agora, essa tabela intermedi�ria (`C1`) � transformada usando a fun��o `PIVOT`:

```sql
PIVOT(
    SUM(C1.TOTAL_FRETE) 
    FOR C1.M�S IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) AS PVT
```

- **`SUM(C1.TOTAL_FRETE)`** ? Soma os valores do frete para cada combina��o de pedido e m�s.
- **`FOR C1.M�S IN ([1],[2],...[12])`** ? Define que os valores �nicos de `M�S` devem se tornar colunas (janeiro a dezembro).

?? **Resultado esperado ap�s o `PIVOT`**  
A tabela se transforma, agrupando os valores de frete em colunas de meses:

| NumeroPedido | M�S 1 | M�S 2 | M�S 3 | ... | M�S 12 |
|-------------|------|------|------|-----|------|
| 10100       | 25.00 | 0.00  | 30.50 | ... | 0.00  |
| 10101       | 0.00  | 20.00 | 0.00  | ... | 0.00  |
| 10102       | 0.00  | 0.00  | 50.00 | ... | 0.00  |

---

#### **3. Tratamento de Valores `NULL`**
Depois do `PIVOT`, se um pedido n�o tiver valores para um determinado m�s, o SQL Server retornar� `NULL` nessas colunas. Para evitar isso, usamos `ISNULL` para substituir `NULL` por `0`:

```sql
ISNULL([1],0) AS 'M�S 1',
ISNULL([2],0) AS 'M�S 2',
...
ISNULL([12],0) AS 'M�S 12'
```

Agora, se um pedido n�o tiver frete em determinado m�s, aparecer� `0` em vez de `NULL`.

---

#### **4. Ordena��o Final**
```sql
ORDER BY 1
```
- Ordena os resultados pela primeira coluna (`NumeroPedido`).

---

### **Resumo da Query**
1. **Seleciona os pedidos do ano de 1998.**
2. **Agrupa os pedidos por n�mero e m�s, somando o frete.**
3. **Aplica a fun��o `PIVOT` para transformar os meses em colunas.**
4. **Substitui valores `NULL` por `0` para evitar campos vazios.**
5. **Ordena os pedidos pelo n�mero.**

Esse m�todo facilita an�lises de valores mensais e permite uma visualiza��o mais estruturada dos dados.
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
		ISNULL([1],0) AS 'M�S 1',
		ISNULL([2],0) AS 'M�S 2',
		ISNULL([3],0) AS 'M�S 3',
		ISNULL([4],0) AS 'M�S 4',
		ISNULL([5],0) AS 'M�S 5',
		ISNULL([6],0) AS 'M�S 6',
		ISNULL([7],0) AS 'M�S 7',
		ISNULL([8],0) AS 'M�S 8',
		ISNULL([9],0) AS 'M�S 9',
		ISNULL([10],0) AS 'M�S 10',
		ISNULL([11],0) AS 'M�S 11',
		ISNULL([12],0) AS 'M�S 12'

FROM (SELECT	NumeroPedido,
				MONTH(DataPedido) AS M�S,
				SUM(Frete) AS TOTAL_FRETE
		FROM TB_PEDIDO
		WHERE YEAR(DataPedido) = 1998
		GROUP BY NumeroPedido, MONTH(DataPedido)) C1
PIVOT(SUM(C1.TOTAL_FRETE) FOR C1.M�S IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS PVT
ORDER BY 1

--UNPIVOT

SELECT	NumeroPedido, MES, TOTAL_VENDAS
FROM ( SELECT	NumeroPedido,
				MES1,MES2,MES3,MES4,MES5,MES6,MES7,MES8,MES9,MES10,MES11,MES12
		FROM TB_UNPIVOT) P
		UNPIVOT (TOTAL_VENDAS FOR MES IN (MES1,MES2,MES3,MES4,MES5,MES6,MES7,MES8,MES9,MES10,MES11,MES12)) AS UP

/*
							=====EXPLICA��O=====

Aqui est� a explica��o detalhada da consulta SQL que utiliza a fun��o `UNPIVOT`.  

---

### **Objetivo da Consulta**
A consulta transforma dados que est�o em um formato de colunas (dados normalizados) em um formato de linhas (dados desnormalizados). Ou seja, ela converte as colunas **MES1 a MES12** em uma �nica coluna chamada **MES**, com os valores correspondentes de vendas sendo armazenados na coluna **TOTAL_VENDAS**.

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
   - Aqui, selecionamos a tabela `TB_UNPIVOT`, que cont�m as vendas mensais distribu�das em 12 colunas (uma para cada m�s, de **MES1 a MES12**).
   - A tabela possui, pelo menos, as colunas:
     - `NumeroPedido` ? N�mero do pedido.
     - `MES1` a `MES12` ? Total de vendas de cada m�s.

2. **Aplica��o do `UNPIVOT`**
   ```sql
   UNPIVOT (TOTAL_VENDAS FOR MES IN (MES1, MES2, MES3, MES4, MES5, MES6, 
                                     MES7, MES8, MES9, MES10, MES11, MES12)) AS UP
   ```
   - O `UNPIVOT` transforma as colunas **MES1 a MES12** em valores de linha na nova coluna chamada **MES**.
   - A cada itera��o, o valor de cada coluna mensal � armazenado na coluna **TOTAL_VENDAS**.
   - O nome da coluna contendo os nomes originais das colunas (MES1, MES2, etc.) ser� **MES**.

3. **Sa�da Final**
   ```sql
   SELECT NumeroPedido, MES, TOTAL_VENDAS
   ```
   - Selecionamos os dados transformados:
     - `NumeroPedido`: Identifica��o do pedido.
     - `MES`: Indica o m�s original da venda (exemplo: MES1, MES2, etc.).
     - `TOTAL_VENDAS`: Valor total de vendas correspondente ao m�s.

---

### **Exemplo de Entrada e Sa�da**
#### **Entrada (TB_UNPIVOT)**
| NumeroPedido | MES1 | MES2 | MES3 | MES4 | MES5 | MES6 |
|-------------|------|------|------|------|------|------|
| 1001        | 500  | 600  | 300  | 800  | 900  | 700  |
| 1002        | 450  | 550  | 250  | 750  | 850  | 650  |

#### **Sa�da Ap�s o `UNPIVOT`**
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

### **Conclus�o**
- O `UNPIVOT` ajuda a transformar colunas em linhas, tornando os dados mais f�ceis de manipular e analisar.
- Essa consulta � �til para relat�rios e an�lises, pois permite trabalhar com dados de meses como uma �nica coluna em vez de 12 colunas separadas.
- A nova coluna **MES** mant�m a refer�ncia ao m�s original de cada valor de vendas.

*/