--Triggers

/*
Um trigger, tamb�m popularmente chamado de gatilho, � um tipo especial de store procedure que � automaticamnete disparado
h� um evento de linguagem, ou seja, quando � realizada alguma altera��o nos dados de uma tabela, sua principal usabilidade 
� automatizar processos.

Tr�s tipos de Triggers gen�ricos no SQL Sever:
	- Trigger DML (Data Manipulation Language)
	- Trigger DDL (Data Definition Language)
	- Trigger de logon
--==================================================================
CREATE TRIGGERS
Sintaxe d cria��o:
CREATE TRIGGER <nome_do_trigger>
ON <nome_da_tabela>
[FOR/ AFTER/ INSTEAD OF/ [INSERT/ UPDATE/ DLETE]]
AS
<corpo_do_trigger>

--==================================================================
FOR => Executa ao mesmo tempo que o comando
AFTER => Executa depois do comando
INSTEAD OF => Executa no lugar do comando
--==================================================================
ALTER TRIGGERS
sintaxe de altera��o:
ALTER TRIGGER <nome_do_trigger>
ON <nome_da_tabela>
[FOR/ AFTER/ INSTEAD OF/ [INSERT/ UPDATE/ DLETE]]
AS
<corpo_do_trigger>
--==================================================================
DISABLE TRIGGERS
sintaxe de desabilita��o:
DISABLE TRIGGER {[nome_schema.] nome_trigger [,...n] | ALL}
ON {nome_objeto| DATABASE| ALL SEVER} [;]
--==================================================================
ENABLE TRIGGERS
sintaxe de habilita��o:
ENABLEE TRIGGER {[nome_schema.] nome_trigger [,...n] | ALL}
ON {nome_objeto| DATABASE| ALL SEVER} [;]
--==================================================================
DROP TRIGGER
-Trigger DML
	DROP TRIGGER[nome_schema.] nome_trigger[,...n][;]

-Trigger DDL
	DROP TRIGGER nome_trigger [,...n]
	ON {DATABASE| ALL SERVER} [;]

_Trigger de logon
	DROP TRIGGER nome_trigger [,...n]
	ON ALL SERVER
--========================TRIGGERS DML===============================

-TRIGGER INSERT: � aquele que � executado quando uma instru��o INSERT
insere dados em uma tabela ou view na qual i trigger est� configurado.
-TRIGGER DELETE: � aquele que � executado quando uma instru��o DELETE
� executado para excluir dados em uma tabela ou view.
-TRIGGER UPDATE: � aquele que � executado quando uma instru��o UPDATE
altera dados em uma tabela ou view na qual o trigger est� configurado
*/
--==================================================================
--exemplo de trigger DML UPDATE

--Criando uma tabela para o trigger, para exemplo
CREATE TABLE TB_HIST_SALARIO
(
	FuncionarioID INT PRIMARY KEY,
	DataAlteracao DATETIME2 DEFAULT GETDATE(),
	SalarioAntigo MONEY,
	SalarioNovo MONEY,
	CONSTRAINT FK_TB_HIST_SALARIO_FUNCIONARIO FOREIGN KEY (FuncionarioId)
	REFERENCES TB_FUNCIONARIO(FuncionarioId)
)

--Criando uma Trigger
CREATE TRIGGER TRG_TB_HIST_SALARIO ON TB_FUNCIONARIO
FOR UPDATE
AS
BEGIN
	DECLARE	@FUNCIONARIO_ID INT,
			@SALARIO_ANTIGO MONEY,
			@SALARIO_NOVO MONEY;

	SELECT	@SALARIO_ANTIGO = Salario FROM deleted;

	SELECT	@FUNCIONARIO_ID = FuncionarioId, 
			@SALARIO_NOVO = salario FROM inserted;

	IF @SALARIO_ANTIGO <> @SALARIO_NOVO
		BEGIN
			INSERT INTO TB_HIST_SALARIO
			(FuncionarioID, SalarioAntigo, SalarioNovo)
			VALUES
			(@FUNCIONARIO_ID, @SALARIO_ANTIGO, @SALARIO_NOVO)
		END
END


--realizando altera��o UPDATE na tabela TB_FUNCIONARIO
UPDATE TB_FUNCIONARIO
SET Salario = 5650.00
WHERE FuncionarioId = 1

--visualiza��o da tabela criada para o trigger
SELECT * FROM TB_HIST_SALARIO

--==================================================================
--Exercicios:

--Alteramos a tabela TB_PEDIDO criando uma nova coluna VALOR_TOTAL 
ALTER TABLE TB_PEDIDO
ADD VALOR_TOTAL MONEY DEFAULT 0

--Criando a Triiger que ir� inserir no campo VALOR_TOTAL 
CREATE TRIGGER TRG_CORRIGE_VLR_TOTAL ON TB_DETALHE_PEDIDO
FOR DELETE, INSERT, UPDATE
AS
BEGIN
	--PARA EVENTO DE DELETE
	IF NOT EXISTS (SELECT * FROM inserted)
	BEGIN
		UPDATE TB_PEDIDO
		SET VALOR_TOTAL = (SELECT SUM(D.Preco * D.Quantidade) FROM TB_DETALHE_PEDIDO D
							WHERE P.NumeroPedido = D.NumeroPedido)
							FROM TB_PEDIDO P JOIN deleted
							ON P.NumeroPedido = deleted.NumeroPedido;
	END
	--PARA EVENTO DE UPDATE OU INSERT
	ELSE
	BEGIN
		UPDATE TB_PEDIDO
		SET VALOR_TOTAL = (SELECT SUM(D.Preco * D.Quantidade) FROM TB_DETALHE_PEDIDO D
							WHERE P.NumeroPedido = D.NumeroPedido)
							FROM TB_PEDIDO P JOIN inserted
							ON P.NumeroPedido = inserted.NumeroPedido;
	END
END

--Realizamos um update no campo quantidade para que a trigger inseri-se o valor programado
UPDATE TB_DETALHE_PEDIDO
SET Quantidade = 10
WHERE ProdutoId = 14

--==================================================================
--Alteramos a tabela TB_PEDIDO criando uma nova coluna ativo
ALTER TABLE TB_CLIENTE
ADD ativo BIT DEFAULT 1

--Realizamos um UPDATE para garantir que o campo ativo esteja default 1 (ativo)
UPDATE TB_CLIENTE
SET ativo = 1
go

--==================================================================
--Criando a Triiger do tipo INSTEAD OF que ir� desativar o cliente (ativo = 0) ao inv�s de apagar o registro, 
--mesmo que o comando seja DELETE 
CREATE TRIGGER TRG_DESATIVA_CLIENTE ON TB_CLIENTE
INSTEAD OF DELETE
AS 
BEGIN
	UPDATE TB_CLIENTE SET ativo = 0
	FROM TB_CLIENTE C JOIN deleted D ON C.ClienteId = D.ClienteId
END

--Realizando um DELETE
DELETE TB_CLIENTE
WHERE ClienteId = 'ALFKI'

/* Ap�s o comando de DELETE na tabela TB_CLIENTE, ao inves de deletar o registro, a Trigger realizaou 
um UPDATE na tabela modificando o campo ativo de 1 (ativo) para 0 (inativo)*/

--========================TRIGGERS DDL===============================
--Criado uma tabela para guardar os logs
CREATE TABLE Logs
(
	EventoType VARCHAR(100),
	ObjectType VARCHAR(100),
	ObjectName VARCHAR(100),
	CommandText VARCHAR(5000),
	UserName VARCHAR(100)
)
GO

--Criando uma Trigger para registrar os eventos, salvando-os na tabela Logs
CREATE TRIGGER TRG_LOG_BANCO
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
	DECLARE @DATA XML,
			--@MSG VARCHAR(5000)
	SET @DATA = EVENTDATA();

	INSERT INTO Logs (EventoType, ObjectType, ObjectName,CommandText, UserName)
	VALUES
	(	@DATA.value('(/EVENT_INSTANCE/EventType)[1]', 'VARCHAR(100)'),
		@DATA.value('(/EVENT_INSTANCE/ObjectType)[1]', 'VARCHAR(100)'),
		@DATA.value('(/EVENT_INSTANCE/ObjectName)[1]', 'VARCHAR(100)'),
		@DATA.value ('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'VARCHAR(5000)'),
		SUSER_SNAME()); --Captura o usu�rio atual do SQL
END

--Realizando teste de cria��o, altera��o e exclus�o de tabela
CREATE TABLE TESTE(ID INT, NOME VARCHAR(35));
ALTER TABLE TESTE ADD E_MAIL VARCHAR(120);
DROP TABLE TESTE

--Verificando os registros
SELECT * FROM Logs

--==================================================================
--Criando uma Trigger que n�o permita criar novas tabelas sem a autoriza��o do admin
CREATE TRIGGER TRG_BLOQUEIO_CREATE_TABLE
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
	SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'VARCHAR(MAX)');
	RAISERROR('N�o � poss�vel criar novas tabelas, procure o admin para isso.',16,1);
	ROLLBACK
END

--Criando uma nova tabela
CREATE TABLE TB_TABELA_TESTE(ID INT);

--Mensagem de erro ao tentar criar a tabela
/*'Msg 50000, N�vel 16, Estado 1, Procedimento TRG_BLOQUEIO_CREATE_TABLE, Linha 7 [Linha de In�cio do Lote 12]
N�o � poss�vel criar novas tabelas, procure o admin para isso.
Mensagem 3609, N�vel 16, Estado 2, Linha 13
A transa��o foi encerrada no gatilho. O lote foi anulado.'*/


--========================TRIGGERS LOGON===============================
