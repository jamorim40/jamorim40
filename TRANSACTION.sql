--=================TRASNSACTION===========================
--*BEGIN TRASNSACTION ou BEGIN TRAN
--	Inicia um processo de trasnsação para a sessão atual

--*COMMIT TRANSACTION ou COMMIT WORK ou COMMIT
--	Finaliza o prcesso de trasnsação atual, confirmando todas as alterações efetuadas desde o início do processo

--*ROLLBACK TRANSACTION ou ROLLBACK WORK ou ROLLBACK
--	FInaliza o processo da transação atual, descartando todas as aletrações efetuadas desde o início do processo.

--*EXEMPLO DO USO:

SELECT * FROM TB_CLIENTE

BEGIN TRAN

UPDATE TB_CLIENTE
SET Email = 'TESTE@TESTE.COM'
WHERE Id = 5

COMMIT --usado caso tenha ceteza da alteração e queira FINALIZAR a transação
ROLLBACK --usado caso seja necessário voltar a transação
