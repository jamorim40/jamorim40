--Stored Procedure
/*
Sintaxe:
CREATE PROCEDURE [EDURE] [nome_schema.] nome_precedure
[({@parametro1} tipo1 [VARYING] [= defalut1] [OUTPUT])] {,...}
[FOR REPLICATION]
AS batch| EXTERNAL NAME metodo

nome_schema: � o nome do esquema ao qual est� atribuido o proprit�rio da store procedure que vai ser criada.
nome_procedure: � o nome da procedure que est� sendo criada
tipo1: � o tipo de dados do par�mentro.
VARYNG: Aplc�vel somente par�mentros cursor. Define o conjunto de resultados suportado como um par�mentro de sa�da.
default1: � o valor padr�o (constante ou null) para par�mentros. A procedure poder� ser executada sem que especifiquemos um valor para o par�mentro, caso um valor padr�o seja definido
OUTPUT: Indica que o par�mentro � de retorno. Ele poder� ser retornado tanto para o sistema quanto para a procedure de chamada.
WITH RECOMPILE: N�o pode ser utilizado com FOR REPLICATION e determina que o Database ENgine n�o armazene em cache um plano para a procedure, a qual ser� compilada em tempo de execu��o.
WITH ENCRYPTION: Faz como o texto original so comando CREATE PEORCEDURE seja convertido em um formato que n�o seja diretamente vis�vel no SQL Sever.
EXECUTE AS: Define o contexto de seguran�a no qual a stoore procedure ser� executada (CALLER, SELF e OWNER)
*/

--Criando Procedure com alinhamento 

CREATE PROCEDURE PROC_A
AS
BEGIN
	PRINT 'PROC_A' + CAST(@@NESTLEVEL AS VARCHAR(2));
	EXEC PROC_B;
	PRINT 'VOLTEI PARA PROC_A';
END
GO

CREATE PROCEDURE PROC_B
AS
BEGIN
	PRINT 'PROC_B' + CAST(@@NESTLEVEL AS VARCHAR(2));
	EXEC PROC_C;
	PRINT 'VOLTEI PARA PROC_B';
END
GO

CREATE PROCEDURE PROC_C
AS
BEGIN
	PRINT'PROC_C' + CAST(@@NESTLEVEL AS VARCHAR(2));
END

EXEC PROC_A

--Criando Procedure por entidade (BuscarEnderecoPorEntidade)

CREATE PROCEDURE BuscarEnderecoPorEntidade @ENTIDADE AS VARCHAR(30)
AS
BEGIN
	IF @ENTIDADE = 'CLIENTE'
		SELECT Logradouro, Cidade, CEP, Pais FROM TB_ENDERECO WHERE ClienteId IS NOT NULL
	ELSE IF @ENTIDADE = 'FUNCIONARIO'
		SELECT Logradouro, Cidade, CEP, Pais FROM TB_ENDERECO WHERE FuncionarioId IS NOT NULL
	ELSE IF @ENTIDADE = 'FORNECEDOR'
		SELECT Logradouro, Cidade, CEP, Pais FROM TB_ENDERECO WHERE FornecedorId IS NOT NULL
	ELSE
		SELECT 'OP��O INV�LIDA SELECIONE ALGUMA DESSA OP��ES: CLIENTE, FUNCIONARIO OU FORNECEDOR'
END

EXEC BuscarEnderecoPorEntidade @ENTIDADE = 'FUNCONA'
GO

--Criando Procedure por OUTPUT

CREATE PROCEDURE CaLculaIdade @IDADE AS INT OUTPUT, @DATA_NASCIMENTO AS DATETIME2
AS
BEGIN
	SET @IDADE = DATEDIFF(YEAR, @DATA_nASCIMENTO, GETDATE())
END

DECLARE @IDADE_OUT AS INT = 0;
PRINT 'IDADE ANTES: ' + CAST(@IDADE_OUT AS VARCHAR(2))
EXEC CaLculaIdade @IDADE_OUT OUTPUT, @DATA_NASCIMENTO = '1988-06-06';
PRINT 'IDADE DEPOIS: ' + CAST(@IDADE_OUT AS VARCHAR(2))
--=======================================================================================================================

		--	exercicio--
--CRIAR PROCEDURE QUE TRAGA O TOTAL VENDIDO EM CADA UM MESES FILTRANDO POR UM DETERMINADO ANO

CREATE PROCEDURE STP_PesquisaTotalVendido
	@ANO  INT
AS
	
BEGIN

SELECT	MONTH(P.DataPedido) AS MES,
		YEAR(P.DataPedido) AS ANO,
		SUM(D.Preco) AS TOTAL_VENDIDO
FROM TB_PEDIDO P
JOIN TB_DETALHE_PEDIDO D
		ON P.NumeroPedido = D.NumeroPedido
WHERE YEAR(P.DataPedido) = @ANO
GROUP BY	MONTH(P.DataPedido),
			YEAR(P.DataPedido)
ORDER BY 1

END

GO

/*
	**Resumo do Funcionamento**  
1. A procedure recebe um ano como par�metro.  
2. Busca os pedidos daquele ano e junta com os detalhes dos pedidos.  
3. Agrupa os dados por m�s e soma os valores de venda.  
4. Ordena os resultados cronologicamente.  
*/
--=======================================================================================================================
--CRIAR PROCEDUREQUE TRAGA ITENS DE UM PEDIDO E DETALHES DO PEDIDO POR PER�ODO DE DATA E CLIENTE E/OU FUNCIONARIO

SELECT  TOP 5* FROM TB_PEDIDO
SELECT	TOP 5* FROM TB_DETALHE_PEDIDO
SELECT	TOP 5* FROM TB_CLIENTE
SELECT	TOP 5* FROM TB_FUNCIONARIO



CREATE PROCEDURE STP_FiltroPedido_PorData 
		@DATA_INICIAL DATETIME2,
		@DATA_FINAL DATETIME2,
		@CLIENTE VARCHAR(50) = '%',
		@FUNCIONARIO VARCHAR(50) = '%'
AS
BEGIN


	SELECT	P.NumeroPedido			AS NUMERO_PEDIDO,
			D.ProdutoId				AS PRODUTO_ID,
			D.Preco					AS PRECO,
			D.Quantidade			AS QTD,
			P.DataPedido			AS DATA_PEDIDO,
			C.NomeCompleto			AS NOME_CLIENTE,
			F.NomeCompleto			AS NOME_FUNCIONARIO
	FROM	TB_PEDIDO P
	JOIN	TB_DETALHE_PEDIDO D
		ON P.NumeroPedido = D.NumeroPedido
	JOIN	TB_CLIENTE C
		ON P.ClienteId = C.ClienteId
	JOIN	TB_FUNCIONARIO F
		ON	P.FuncionarioId = F.FuncionarioId
	WHERE	P.DataPedido BETWEEN @DATA_INICIAL AND @DATA_FINAL
		AND
		C.NomeCompleto LIKE @CLIENTE AND F.NomeCompleto LIKE @FUNCIONARIO

END

EXEC STP_FiltroPedido_PorData '1997-01-01', '1997-12-31','Eastern Connection','%'

/*
	**Resumo do Funcionamento**
1. A procedure recebe como entrada um intervalo de datas, al�m de filtros opcionais para cliente e funcion�rio.  
2. Busca os pedidos dentro do per�odo especificado.  
3. Junta os pedidos com os produtos comprados, clientes e funcion�rios respons�veis.  
4. Aplica os filtros de cliente e funcion�rio, permitindo buscas flex�veis com `LIKE`.
*/
--=======================================================================================================================

--Chamada par�mentro posicional

EXEC dbo.STP_FiltroPedido_PorData '1996-01-01', '1996-12-31','%','%'

--Chamada par�mentro nominal
EXEC dbo.STP_FiltroPedido_PorData @DATA_INICIAL='1996-01-01', @DATA_FINAL ='1996-12-31', @CLIENTE ='%',@FUNCIONARIO ='%'


/*
As duas chamadas executam a mesma stored procedure (`STP_FiltroPedido_PorData`), mas existem diferen�as na forma como os par�metros s�o passados:  

	**1� Chamada:**  

EXEC dbo.STP_FiltroPedido_PorData '1996-01-01', '1996-12-31','%','%'

- Os par�metros s�o passados **por posi��o**.  
- O SQL Server associa cada valor � posi��o correspondente na assinatura da procedure.  
- A ordem dos valores precisa corresponder exatamente � ordem dos par�metros na defini��o da procedure.  


	 **2� Chamada:**  

EXEC dbo.STP_FiltroPedido_PorData @DATA_INICIAL='1996-01-01', @DATA_FINAL ='1996-12-31', @CLIENTE ='%',@FUNCIONARIO ='%'

- Os par�metros s�o passados **por nome**.  
- A ordem n�o importa, pois cada par�metro � explicitamente identificado.  
- Isso melhora a legibilidade e reduz erros caso a ordem dos par�metros da procedure seja alterada no futuro.  

	**Principais diferen�as:**  
| Caracter�stica				| Chamada por Posi��o	| Chamada por Nome	|
|-------------------------------|-----------------------|-------------------|
| Ordem dos par�metros			| Importante			| Irrelevante		|
| Legibilidade					| Menor					| Maior				|
| Facilidade de manuten��o		| Menor					| Maior				|
| Requer nomes dos par�metros?	| N�o					| Sim				|

No geral, a chamada **por nome** � recomendada para maior clareza e flexibilidade, especialmente quando h� muitos par�metros.
*/

--=======================================================================================================================
/*
Por meio do comnado RETURN,	� possivel fazer com que a procedure retorne um
valor, que deve ser um n�mero inteiro, no seu pr�prio nome.
O retorno de valor com RETURN � utilizado normalmente para sinalizar algum tipo
de ero na execu��o ou para indicar que a procedure n�o conseguiu executar o que 
foi solicitado
*/

CREATE PROCEDURE STP_UltimaDataPedido
	@CLIENTE_ID VARCHAR(10)
AS
BEGIN
	
	IF NOT EXISTS(SELECT * FROM TB_PEDIDO WHERE ClienteId = @CLIENTE_ID)
		RETURN -1;

	SELECT	MAX(DataPedido) AS ULTIMA_DATA_PEDIDO
	FROM TB_PEDIDO
	WHERE ClienteId = @CLIENTE_ID
	
END


DECLARE @RESULTADO INT;
EXEC @RESULTADO = STP_UltimaDataPedido 'HILAA';
IF @RESULTADO <0 PRINT 'N�O EXISTE PEDIDO COM O NOME INFORMADO'


/*
### Resumo da Procedure `STP_UltimaDataPedido`  
	**O que a procedure faz?**  
- Recebe um **ID de cliente** (`@CLIENTE_ID`).
- Verifica se existem pedidos para esse cliente na tabela `TB_PEDIDO`:
  - Se **n�o existirem**, a procedure retorna `-1`.
  - Se **existirem**, retorna a **data do �ltimo pedido** desse cliente (`MAX(DataPedido)`).

	**Motivo de uso**  
- �til para **consultar rapidamente** a �ltima compra de um cliente.
- Evita consultas repetitivas no c�digo da aplica��o.
- Retorna um c�digo de erro (`-1`) caso o cliente **n�o tenha pedidos**, permitindo tratamento adequado.

 **Observa��o:** O c�digo de chamada tem um problema: procedures n�o podem retornar valores diretamente para vari�veis. Se precisar capturar o valor em uma vari�vel, 
use um `OUTPUT` ou um `SELECT INTO`. 
*/