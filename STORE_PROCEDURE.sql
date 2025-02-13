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

