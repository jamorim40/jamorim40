--=================TRASNSACTION===========================
--*BEGIN TRASNSACTION ou BEGIN TRAN
--	Inicia um processo de trasnsa��o para a sess�o atual

--*COMMIT TRANSACTION ou COMMIT WORK ou COMMIT
--	Finaliza o prcesso de trasnsa��o atual, confirmando todas as altera��es efetuadas desde o in�cio do processo

--*ROLLBACK TRANSACTION ou ROLLBACK WORK ou ROLLBACK
--	FInaliza o processo da transa��o atual, descartando todas as aletra��es efetuadas desde o in�cio do processo.

--*EXEMPLO DO USO:

SELECT * FROM TB_CLIENTE

BEGIN TRAN

UPDATE TB_CLIENTE
SET Email = 'TESTE@TESTE.COM'
WHERE Id = 5

COMMIT --usado caso tenha ceteza da altera��o e queira FINALIZAR a transa��o
ROLLBACK --usado caso seja necess�rio voltar a transa��o
