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

