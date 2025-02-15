--Stored Procedure
/*
Sintaxe:
CREATE PROCEDURE [EDURE] [nome_schema.] nome_precedure
[({@parametro1} tipo1 [VARYING] [= defalut1] [OUTPUT])] {,...}
[FOR REPLICATION]
AS batch| EXTERNAL NAME metodo

nome_schema: É o nome do esquema ao qual está atribuido o propritário da store procedure que vai ser criada.
nome_procedure: É o nome da procedure que está sendo criada
tipo1: É o tipo de dados do parâmentro.
VARYNG: Aplcável somente parâmentros cursor. Define o conjunto de resultados suportado como um parâmentro de saída.
default1: É o valor padrão (constante ou null) para parâmentros. A procedure poderá ser executada sem que especifiquemos um valor para o parâmentro, caso um valor padrão seja definido
OUTPUT: Indica que o parâmentro é de retorno. Ele poderá ser retornado tanto para o sistema quanto para a procedure de chamada.
WITH RECOMPILE: Não pode ser utilizado com FOR REPLICATION e determina que o Database ENgine não armazene em cache um plano para a procedure, a qual será compilada em tempo de execução.
WITH ENCRYPTION: Faz como o texto original so comando CREATE PEORCEDURE seja convertido em um formato que não seja diretamente visível no SQL Sever.
EXECUTE AS: Define o contexto de segurança no qual a stoore procedure será executada (CALLER, SELF e OWNER)
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
		SELECT 'OPÇÃO INVÁLIDA SELECIONE ALGUMA DESSA OPÇÕES: CLIENTE, FUNCIONARIO OU FORNECEDOR'
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
1. A procedure recebe um ano como parâmetro.  
2. Busca os pedidos daquele ano e junta com os detalhes dos pedidos.  
3. Agrupa os dados por mês e soma os valores de venda.  
4. Ordena os resultados cronologicamente.  
*/
--=======================================================================================================================
--CRIAR PROCEDUREQUE TRAGA ITENS DE UM PEDIDO E DETALHES DO PEDIDO POR PERÍODO DE DATA E CLIENTE E/OU FUNCIONARIO

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
1. A procedure recebe como entrada um intervalo de datas, além de filtros opcionais para cliente e funcionário.  
2. Busca os pedidos dentro do período especificado.  
3. Junta os pedidos com os produtos comprados, clientes e funcionários responsáveis.  
4. Aplica os filtros de cliente e funcionário, permitindo buscas flexíveis com `LIKE`.
*/
--=======================================================================================================================

--Chamada parâmentro posicional

EXEC dbo.STP_FiltroPedido_PorData '1996-01-01', '1996-12-31','%','%'

--Chamada parâmentro nominal
EXEC dbo.STP_FiltroPedido_PorData @DATA_INICIAL='1996-01-01', @DATA_FINAL ='1996-12-31', @CLIENTE ='%',@FUNCIONARIO ='%'


/*
As duas chamadas executam a mesma stored procedure (`STP_FiltroPedido_PorData`), mas existem diferenças na forma como os parâmetros são passados:  

	**1ª Chamada:**  

EXEC dbo.STP_FiltroPedido_PorData '1996-01-01', '1996-12-31','%','%'

- Os parâmetros são passados **por posição**.  
- O SQL Server associa cada valor à posição correspondente na assinatura da procedure.  
- A ordem dos valores precisa corresponder exatamente à ordem dos parâmetros na definição da procedure.  


	 **2ª Chamada:**  

EXEC dbo.STP_FiltroPedido_PorData @DATA_INICIAL='1996-01-01', @DATA_FINAL ='1996-12-31', @CLIENTE ='%',@FUNCIONARIO ='%'

- Os parâmetros são passados **por nome**.  
- A ordem não importa, pois cada parâmetro é explicitamente identificado.  
- Isso melhora a legibilidade e reduz erros caso a ordem dos parâmetros da procedure seja alterada no futuro.  

	**Principais diferenças:**  
| Característica				| Chamada por Posição	| Chamada por Nome	|
|-------------------------------|-----------------------|-------------------|
| Ordem dos parâmetros			| Importante			| Irrelevante		|
| Legibilidade					| Menor					| Maior				|
| Facilidade de manutenção		| Menor					| Maior				|
| Requer nomes dos parâmetros?	| Não					| Sim				|

No geral, a chamada **por nome** é recomendada para maior clareza e flexibilidade, especialmente quando há muitos parâmetros.
*/

--=======================================================================================================================
/*
Por meio do comnado RETURN,	é possivel fazer com que a procedure retorne um
valor, que deve ser um número inteiro, no seu próprio nome.
O retorno de valor com RETURN é utilizado normalmente para sinalizar algum tipo
de ero na execução ou para indicar que a procedure não conseguiu executar o que 
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
IF @RESULTADO <0 PRINT 'NÃO EXISTE PEDIDO COM O NOME INFORMADO'


/*
### Resumo da Procedure `STP_UltimaDataPedido`  
	**O que a procedure faz?**  
- Recebe um **ID de cliente** (`@CLIENTE_ID`).
- Verifica se existem pedidos para esse cliente na tabela `TB_PEDIDO`:
  - Se **não existirem**, a procedure retorna `-1`.
  - Se **existirem**, retorna a **data do último pedido** desse cliente (`MAX(DataPedido)`).

	**Motivo de uso**  
- Útil para **consultar rapidamente** a última compra de um cliente.
- Evita consultas repetitivas no código da aplicação.
- Retorna um código de erro (`-1`) caso o cliente **não tenha pedidos**, permitindo tratamento adequado.

 **Observação:** O código de chamada tem um problema: procedures não podem retornar valores diretamente para variáveis. Se precisar capturar o valor em uma variável, 
use um `OUTPUT` ou um `SELECT INTO`. 
*/