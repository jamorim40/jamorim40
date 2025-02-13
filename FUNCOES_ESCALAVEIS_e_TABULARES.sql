--FUN��ES
/*SINTAXE FUNCOES ESCALARES:
	CREATE FUNCION <nome_funcao>
	([@nome_parametro [AS] <tipo_paramentro [,...])
	RETURNS <tipo_retorno> [WITH[ENCRYPTION][,SCHEMABINDING]]
		AS
	BEGIN
		<corpo_da_funcao>
		RETURN <expressao_escalar>
	END

FUNCOES ESCALARES
nome_funcao: Representa o nome da fun��o definida pelo usu�rio.
@nome_paramentro: Representa um par�mnetro. Podem ser declarados um ou mais par�mentros tendo seu limite em 2100 par�mnetros declarados.
				  Se n�o houver um valor default para o par�mentro, o valor de cada um deve ser forneceido pelo usu�rio ao executar a fun��o. Par�metros com nomes
				  iguais podem ser usados em diferentes fun��es.
tipo_paramentro: � o tipode dados do par�mentro.
tipo_retorno: � o valor de retorno da fun��o. Os tipos timestamp, cursor e table n�o s�o aceitos como retorno.
ENCRYPTION: Define que o texto original da instru��o CREATE FUNCTION ser� codificada.
SCHEMABINDING: Associa a fun��o aos objeto associado ao schema fizer refer�ncia � fun��o, ela sofrer� altera��es 
			   corpo_da_funcao: Representa uma s�rie de instru��oes que define o valor da fun��o. � importante ressaltar que essas instru��es n�o podem conter 
			   comandos do grupo DML, em que h� modifica��o de uma tabela.
expressao_escalar: Define o valor escalar retornado pela fin��o.
*/

--CRIAR SUN��O QUE RETORNA O FATURAMENTO POR N�MERO PEDIDO


CREATE FUNCTION FaturamentoDetalhadoPedido (@numero_pedido AS INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @Faturamento FLOAT;

	SELECT @Faturamento =  SUM(Quantidade * Preco) FROM TB_DETALHE_PEDIDO
	WHERE NumeroPedido = @numero_pedido

	RETURN @Faturamento;
END
GO

/* EXPLICA��O
Aqui est� o detalhamento do script para sua futura consulta:

---

### **Descri��o da Fun��o `FaturamentoDetalhadoPedido`**
Essa fun��o tem o objetivo de calcular o faturamento total de um pedido espec�fico com base nos produtos contidos nele.  

---

### **Detalhamento do C�digo**
1. **Cria��o da Fun��o**  
   ```sql
   CREATE FUNCTION FaturamentoDetalhadoPedido (@numero_pedido AS INT)
   ```
   - O nome da fun��o � `FaturamentoDetalhadoPedido`.
   - A fun��o recebe um par�metro de entrada chamado `@numero_pedido`, que � um n�mero inteiro (`INT`). Esse par�metro representa o n�mero do pedido para o qual o faturamento ser� calculado.
   - O tipo de retorno da fun��o � `FLOAT`, ou seja, um valor num�rico com casas decimais.

2. **Declara��o da vari�vel para armazenar o faturamento**  
   ```sql
   DECLARE @Faturamento FLOAT;
   ```
   - A vari�vel `@Faturamento` � criada para armazenar o valor do faturamento total do pedido.

3. **C�lculo do faturamento**  
   ```sql
   SELECT @Faturamento = SUM(Quantidade * Preco) 
   FROM TB_DETALHE_PEDIDO
   WHERE NumeroPedido = @numero_pedido;
   ```
   - O faturamento � calculado multiplicando a **quantidade** pelo **pre�o** de cada item do pedido e somando os valores (`SUM(Quantidade * Preco)`).
   - A busca ocorre na tabela `TB_DETALHE_PEDIDO`, que cont�m os detalhes de cada item vendido dentro de um pedido.
   - Apenas os registros onde `NumeroPedido` for igual ao n�mero do pedido passado como par�metro (`@numero_pedido`) s�o considerados.

4. **Retorno do valor calculado**  
   ```sql
   RETURN @Faturamento;
   ```
   - A fun��o retorna o faturamento total do pedido.

---

### **Como Utilizar a Fun��o**
Ap�s a cria��o da fun��o, voc� pode utiliz�-la em consultas SQL como qualquer outra fun��o escalar.

#### **Exemplo de Uso**
```sql
SELECT dbo.FaturamentoDetalhadoPedido(1001) AS FaturamentoTotal;
```
Esse comando retorna o faturamento total do pedido n�mero `1001`.

---

### **Observa��es Importantes**
1. **Depend�ncias**  
   - A fun��o depende da tabela `TB_DETALHE_PEDIDO` e dos campos `NumeroPedido`, `Quantidade` e `Preco`.
   - Se algum desses campos estiver ausente ou for renomeado, a fun��o precisar� ser ajustada.

2. **Poss�veis Problemas**
   - Se o pedido n�o existir na tabela, a fun��o pode retornar `NULL`. Para evitar isso, pode-se utilizar `ISNULL` ou `COALESCE`, garantindo que o valor retornado seja `0` caso n�o haja registros:
     ```sql
     RETURN ISNULL(@Faturamento, 0);
     ```
   
3. **Performance**
   - A fun��o ser� executada toda vez que for chamada, podendo impactar consultas que a utilizem em grande escala.
   - �ndices sobre `NumeroPedido` podem ajudar na performance.
====================================================================================================================================================================================================

SINTAXE FUNCOES TABULARES:
CREATE FUNCTION <nome_funcao>
([@nome_paramentro [AS] <tipo_paramentro [,...])
RETURNS [@variavel_tabular] TABLE [<estrutura>] [WITH[ENCRYPTION] [,SCHEMABINDING]]
[AS]
BEGIN
	<corpo_da_funcao>
	RETURN
END

FUNCAO TABULARES
@variavel_tabular: Reresenta uma variavel TABLE que armazena linhas que deveriam ser retornadas como valor da fu��o

--CRIAR UMA FUNCAO TABULAR
*/


CREATE FUNCTION ListaPedidosCliente(@CLiente_Id AS VARCHAR(15))
RETURNS TABLE
AS

	RETURN SELECT * FROM TB_PEDIDO WHERE ClienteId = @CLiente_Id;
GO
/*
Aqui est� o detalhamento do script SQL que voc� forneceu:

### **Descri��o do Script**
Este script define uma **fun��o com valor de tabela (Table-Valued Function - TVF)** chamada `ListaPedidosCliente` no **SQL Server**. Essa fun��o retorna todos os pedidos de um cliente espec�fico com base no seu ID.

---

### **Detalhamento por partes**

#### **1. Cria��o da Fun��o**
```sql
CREATE FUNCTION ListaPedidosCliente(@CLiente_Id AS VARCHAR(15))
```
- `CREATE FUNCTION`: Declara uma nova fun��o no banco de dados.
- `ListaPedidosCliente`: Nome da fun��o.
- `@CLiente_Id AS VARCHAR(15)`: Define um par�metro chamado `@CLiente_Id`, que recebe um identificador de cliente do tipo `VARCHAR(15)`. Isso significa que a fun��o aceitar� um valor alfanum�rico de at� 15 caracteres.

---

#### **2. Retorno da Fun��o**
```sql
RETURNS TABLE
```
- Indica que a fun��o retorna uma **tabela** (Table-Valued Function - TVF).

---

#### **3. Defini��o da Consulta SQL**
```sql
AS
RETURN SELECT * FROM TB_PEDIDO WHERE ClienteId = @CLiente_Id;
```
- `RETURN`: Especifica a consulta que ser� executada quando a fun��o for chamada.
- `SELECT * FROM TB_PEDIDO`: Retorna todos os registros da tabela `TB_PEDIDO`.
- `WHERE ClienteId = @CLiente_Id`: Filtra os registros para retornar apenas os pedidos do cliente cujo ID foi passado como par�metro.

---

### **Como Utilizar a Fun��o**
Ap�s criar a fun��o, voc� pode cham�-la dentro de uma consulta SQL da seguinte forma:

```sql
SELECT * FROM ListaPedidosCliente('12345')
```
Isso retornar� todos os pedidos do cliente cujo ID seja `'12345'`.

Outra forma de us�-la dentro de um `JOIN`:

```sql
SELECT P.*
FROM ListaPedidosCliente('12345') P
JOIN TB_CLIENTE C ON P.ClienteId = C.ClienteId;
```
Isso pode ser �til para relacionar os pedidos com outras tabelas.

---

### **Observa��es**
1. **Fun��o Inline**: Esse tipo de fun��o (`RETURNS TABLE`) � chamado de **inline table-valued function**. Ele funciona como uma **view parametrizada**, permitindo consultas mais eficientes.
2. **Vantagens**:
   - Pode ser usada em `SELECT`, `JOIN` e `APPLY`.
   - Melhor desempenho que fun��es escalares (`RETURNS @table TABLE`).
3. **Limita��o**:
   - A fun��o retorna sempre uma consulta fixa, sem possibilidade de l�gica mais complexa dentro dela (diferente das **Multi-Statement Table-Valued Functions**).



*/

--Usando as duas fun��es:

SELECT	DISTINCT
		c1.ClienteId,
		c1.TOTAL_PEDIDOS,
		c2.TOTAL_FATURAMENTO
FROM
	(SELECT ClienteId,
		(SELECT COUNT(*) 
		FROM dbo.ListaPedidosCliente(ClienteId)) AS TOTAL_PEDIDOS
	FROM TB_PEDIDO) AS C1

JOIN

	(SELECT ClienteId,
			SUM(dbo.FaturamentoDetalhadoPedido(NumeroPedido)) AS TOTAL_FATURAMENTO
	FROM TB_PEDIDO
	GROUP BY ClienteId) AS C2
ON C1.ClienteId = c2.ClienteId
GO

/*
Aqui est� um detalhamento do seu script SQL, explicando cada parte para facilitar sua consulta futura:  

---

### **Objetivo do Script**  
O script retorna uma lista distinta de clientes (`ClienteId`), trazendo o n�mero total de pedidos (`TOTAL_PEDIDOS`) e o faturamento total (`TOTAL_FATURAMENTO`) de cada cliente.  

---

### **Explica��o do C�digo**  

1. **Subconsulta `C1` (Total de Pedidos por Cliente)**  
   ```sql
   (SELECT ClienteId,
       (SELECT COUNT(*) 
        FROM dbo.ListaPedidosCliente(ClienteId)) AS TOTAL_PEDIDOS
   FROM TB_PEDIDO) AS C1
   ```
   - Esta subconsulta percorre a tabela `TB_PEDIDO`, obtendo a lista de `ClienteId`.
   - Para cada cliente, � chamada a fun��o `dbo.ListaPedidosCliente(ClienteId)`, que aparentemente retorna uma lista de pedidos desse cliente.
   - O `COUNT(*)` conta quantos pedidos esse cliente possui e atribui o valor � coluna `TOTAL_PEDIDOS`.

2. **Subconsulta `C2` (Faturamento Total por Cliente)**  
   ```sql
   (SELECT ClienteId,
           SUM(dbo.FaturamentoDetalhadoPedido(NumeroPedido)) AS TOTAL_FATURAMENTO
    FROM TB_PEDIDO
    GROUP BY ClienteId) AS C2
   ```
   - Esta subconsulta agrupa os pedidos por cliente (`GROUP BY ClienteId`).
   - Para cada pedido (`NumeroPedido`), � chamada a fun��o `dbo.FaturamentoDetalhadoPedido(NumeroPedido)`, que parece calcular o faturamento detalhado do pedido.
   - A soma (`SUM(...)`) � feita para obter o faturamento total do cliente.

3. **Jun��o das Subconsultas `C1` e `C2`**  
   ```sql
   FROM C1
   JOIN C2 ON C1.ClienteId = C2.ClienteId
   ```
   - As duas subconsultas s�o unidas pelo `ClienteId`, garantindo que as informa��es sejam agregadas corretamente.

4. **Filtragem de Registros Duplicados**  
   ```sql
   SELECT DISTINCT
   ```
   - O uso de `DISTINCT` garante que cada cliente apare�a apenas uma vez no resultado final.

---

### **Resumo do Resultado**  
A consulta retorna uma lista de clientes com as seguintes informa��es:  
- `ClienteId` ? Identificador do cliente.  
- `TOTAL_PEDIDOS` ? Quantidade total de pedidos do cliente.  
- `TOTAL_FATURAMENTO` ? Soma do faturamento de todos os pedidos do cliente.  

*/

--Alterando uma fun��o

ALTER FUNCTION ListaPedidosCliente(@NUMERO_PEDIDO AS INT)
RETURNS TABLE
AS

	RETURN SELECT * FROM TB_PEDIDO WHERE NumeroPedido = @NUMERO_PEDIDO;
GO

--Exluir fun��o

DROP FUNCTION ListaPedidosCliente
GO
