--FUNÇÕES
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
nome_funcao: Representa o nome da função definida pelo usuário.
@nome_paramentro: Representa um parâmnetro. Podem ser declarados um ou mais parâmentros tendo seu limite em 2100 parâmnetros declarados.
				  Se não houver um valor default para o parâmentro, o valor de cada um deve ser forneceido pelo usuário ao executar a função. Parâmetros com nomes
				  iguais podem ser usados em diferentes funções.
tipo_paramentro: É o tipode dados do parâmentro.
tipo_retorno: É o valor de retorno da função. Os tipos timestamp, cursor e table não são aceitos como retorno.
ENCRYPTION: Define que o texto original da instrução CREATE FUNCTION será codificada.
SCHEMABINDING: Associa a função aos objeto associado ao schema fizer referência á função, ela sofrerá alterações 
			   corpo_da_funcao: Representa uma série de instruçãoes que define o valor da função. É importante ressaltar que essas instruções não podem conter 
			   comandos do grupo DML, em que há modificação de uma tabela.
expressao_escalar: Define o valor escalar retornado pela finção.
*/

--CRIAR SUNÇÃO QUE RETORNA O FATURAMENTO POR NÚMERO PEDIDO


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

/* EXPLICAÇÃO
Aqui está o detalhamento do script para sua futura consulta:

---

### **Descrição da Função `FaturamentoDetalhadoPedido`**
Essa função tem o objetivo de calcular o faturamento total de um pedido específico com base nos produtos contidos nele.  

---

### **Detalhamento do Código**
1. **Criação da Função**  
   ```sql
   CREATE FUNCTION FaturamentoDetalhadoPedido (@numero_pedido AS INT)
   ```
   - O nome da função é `FaturamentoDetalhadoPedido`.
   - A função recebe um parâmetro de entrada chamado `@numero_pedido`, que é um número inteiro (`INT`). Esse parâmetro representa o número do pedido para o qual o faturamento será calculado.
   - O tipo de retorno da função é `FLOAT`, ou seja, um valor numérico com casas decimais.

2. **Declaração da variável para armazenar o faturamento**  
   ```sql
   DECLARE @Faturamento FLOAT;
   ```
   - A variável `@Faturamento` é criada para armazenar o valor do faturamento total do pedido.

3. **Cálculo do faturamento**  
   ```sql
   SELECT @Faturamento = SUM(Quantidade * Preco) 
   FROM TB_DETALHE_PEDIDO
   WHERE NumeroPedido = @numero_pedido;
   ```
   - O faturamento é calculado multiplicando a **quantidade** pelo **preço** de cada item do pedido e somando os valores (`SUM(Quantidade * Preco)`).
   - A busca ocorre na tabela `TB_DETALHE_PEDIDO`, que contém os detalhes de cada item vendido dentro de um pedido.
   - Apenas os registros onde `NumeroPedido` for igual ao número do pedido passado como parâmetro (`@numero_pedido`) são considerados.

4. **Retorno do valor calculado**  
   ```sql
   RETURN @Faturamento;
   ```
   - A função retorna o faturamento total do pedido.

---

### **Como Utilizar a Função**
Após a criação da função, você pode utilizá-la em consultas SQL como qualquer outra função escalar.

#### **Exemplo de Uso**
```sql
SELECT dbo.FaturamentoDetalhadoPedido(1001) AS FaturamentoTotal;
```
Esse comando retorna o faturamento total do pedido número `1001`.

---

### **Observações Importantes**
1. **Dependências**  
   - A função depende da tabela `TB_DETALHE_PEDIDO` e dos campos `NumeroPedido`, `Quantidade` e `Preco`.
   - Se algum desses campos estiver ausente ou for renomeado, a função precisará ser ajustada.

2. **Possíveis Problemas**
   - Se o pedido não existir na tabela, a função pode retornar `NULL`. Para evitar isso, pode-se utilizar `ISNULL` ou `COALESCE`, garantindo que o valor retornado seja `0` caso não haja registros:
     ```sql
     RETURN ISNULL(@Faturamento, 0);
     ```
   
3. **Performance**
   - A função será executada toda vez que for chamada, podendo impactar consultas que a utilizem em grande escala.
   - Índices sobre `NumeroPedido` podem ajudar na performance.
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
@variavel_tabular: Reresenta uma variavel TABLE que armazena linhas que deveriam ser retornadas como valor da fução

--CRIAR UMA FUNCAO TABULAR
*/


CREATE FUNCTION ListaPedidosCliente(@CLiente_Id AS VARCHAR(15))
RETURNS TABLE
AS

	RETURN SELECT * FROM TB_PEDIDO WHERE ClienteId = @CLiente_Id;
GO
/*
Aqui está o detalhamento do script SQL que você forneceu:

### **Descrição do Script**
Este script define uma **função com valor de tabela (Table-Valued Function - TVF)** chamada `ListaPedidosCliente` no **SQL Server**. Essa função retorna todos os pedidos de um cliente específico com base no seu ID.

---

### **Detalhamento por partes**

#### **1. Criação da Função**
```sql
CREATE FUNCTION ListaPedidosCliente(@CLiente_Id AS VARCHAR(15))
```
- `CREATE FUNCTION`: Declara uma nova função no banco de dados.
- `ListaPedidosCliente`: Nome da função.
- `@CLiente_Id AS VARCHAR(15)`: Define um parâmetro chamado `@CLiente_Id`, que recebe um identificador de cliente do tipo `VARCHAR(15)`. Isso significa que a função aceitará um valor alfanumérico de até 15 caracteres.

---

#### **2. Retorno da Função**
```sql
RETURNS TABLE
```
- Indica que a função retorna uma **tabela** (Table-Valued Function - TVF).

---

#### **3. Definição da Consulta SQL**
```sql
AS
RETURN SELECT * FROM TB_PEDIDO WHERE ClienteId = @CLiente_Id;
```
- `RETURN`: Especifica a consulta que será executada quando a função for chamada.
- `SELECT * FROM TB_PEDIDO`: Retorna todos os registros da tabela `TB_PEDIDO`.
- `WHERE ClienteId = @CLiente_Id`: Filtra os registros para retornar apenas os pedidos do cliente cujo ID foi passado como parâmetro.

---

### **Como Utilizar a Função**
Após criar a função, você pode chamá-la dentro de uma consulta SQL da seguinte forma:

```sql
SELECT * FROM ListaPedidosCliente('12345')
```
Isso retornará todos os pedidos do cliente cujo ID seja `'12345'`.

Outra forma de usá-la dentro de um `JOIN`:

```sql
SELECT P.*
FROM ListaPedidosCliente('12345') P
JOIN TB_CLIENTE C ON P.ClienteId = C.ClienteId;
```
Isso pode ser útil para relacionar os pedidos com outras tabelas.

---

### **Observações**
1. **Função Inline**: Esse tipo de função (`RETURNS TABLE`) é chamado de **inline table-valued function**. Ele funciona como uma **view parametrizada**, permitindo consultas mais eficientes.
2. **Vantagens**:
   - Pode ser usada em `SELECT`, `JOIN` e `APPLY`.
   - Melhor desempenho que funções escalares (`RETURNS @table TABLE`).
3. **Limitação**:
   - A função retorna sempre uma consulta fixa, sem possibilidade de lógica mais complexa dentro dela (diferente das **Multi-Statement Table-Valued Functions**).



*/

--Usando as duas funções:

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
Aqui está um detalhamento do seu script SQL, explicando cada parte para facilitar sua consulta futura:  

---

### **Objetivo do Script**  
O script retorna uma lista distinta de clientes (`ClienteId`), trazendo o número total de pedidos (`TOTAL_PEDIDOS`) e o faturamento total (`TOTAL_FATURAMENTO`) de cada cliente.  

---

### **Explicação do Código**  

1. **Subconsulta `C1` (Total de Pedidos por Cliente)**  
   ```sql
   (SELECT ClienteId,
       (SELECT COUNT(*) 
        FROM dbo.ListaPedidosCliente(ClienteId)) AS TOTAL_PEDIDOS
   FROM TB_PEDIDO) AS C1
   ```
   - Esta subconsulta percorre a tabela `TB_PEDIDO`, obtendo a lista de `ClienteId`.
   - Para cada cliente, é chamada a função `dbo.ListaPedidosCliente(ClienteId)`, que aparentemente retorna uma lista de pedidos desse cliente.
   - O `COUNT(*)` conta quantos pedidos esse cliente possui e atribui o valor à coluna `TOTAL_PEDIDOS`.

2. **Subconsulta `C2` (Faturamento Total por Cliente)**  
   ```sql
   (SELECT ClienteId,
           SUM(dbo.FaturamentoDetalhadoPedido(NumeroPedido)) AS TOTAL_FATURAMENTO
    FROM TB_PEDIDO
    GROUP BY ClienteId) AS C2
   ```
   - Esta subconsulta agrupa os pedidos por cliente (`GROUP BY ClienteId`).
   - Para cada pedido (`NumeroPedido`), é chamada a função `dbo.FaturamentoDetalhadoPedido(NumeroPedido)`, que parece calcular o faturamento detalhado do pedido.
   - A soma (`SUM(...)`) é feita para obter o faturamento total do cliente.

3. **Junção das Subconsultas `C1` e `C2`**  
   ```sql
   FROM C1
   JOIN C2 ON C1.ClienteId = C2.ClienteId
   ```
   - As duas subconsultas são unidas pelo `ClienteId`, garantindo que as informações sejam agregadas corretamente.

4. **Filtragem de Registros Duplicados**  
   ```sql
   SELECT DISTINCT
   ```
   - O uso de `DISTINCT` garante que cada cliente apareça apenas uma vez no resultado final.

---

### **Resumo do Resultado**  
A consulta retorna uma lista de clientes com as seguintes informações:  
- `ClienteId` ? Identificador do cliente.  
- `TOTAL_PEDIDOS` ? Quantidade total de pedidos do cliente.  
- `TOTAL_FATURAMENTO` ? Soma do faturamento de todos os pedidos do cliente.  

*/

--Alterando uma função

ALTER FUNCTION ListaPedidosCliente(@NUMERO_PEDIDO AS INT)
RETURNS TABLE
AS

	RETURN SELECT * FROM TB_PEDIDO WHERE NumeroPedido = @NUMERO_PEDIDO;
GO

--Exluir função

DROP FUNCTION ListaPedidosCliente
GO
