/* VIEWS
Uma views � uma tabela virtual fromada por linhas e colunas de dados, os quais s�o provenientes de tabelas referenciadas em uma query que 
define a view. Suas linhas e colunas s�o geradas de forma din�micas no instante em que a refer�ncia a views � chamada.
A query que determina uma views pode ser proveniente de uma ou mais tabelas ou, at� mesmo, de outras views. Para determinar uma view que 
utiliza dados proveninetes de fontes distintas, podemos utilizar as queries distribuidas.

As views podem ser de tr�s tipos conforma sua finalidade:
- VIEWS STANDARD: Neste tipo de view s�o reunidos, em uma tabela virtual, dados provenientes de uma ou mais views ou tabelas base.
- VIEWS INDEXADAS: Este tipo de view � obtido por meio da cria��o de um �ndice clusterzado sobre a view.
- VIEWS PATRICIONADAS: Esse tipo de view permite que os dados em uma tabela sejam divididos em tavelas menores. Os dados s�o patrocinados
entre as tabelas de acordo com os valores aceitos nas colunas.
	
	SINTAXE:
	CREATE VIEW nome_view [coluna]
	[WITH[ENCRYPTION][,SCHEMABINDING]]
	AS intrucao_select
	[WITH CHECK OPTION]

nome_view: Nome da view
[coluna]: NOmes das colunas da view
WITH ENCRYPTION: Protege o c�digo fonte da view, impedidndo que ele seja aberto a partir do Object Explrer
WITH SCHEMABINDING: Cria uma view ligaada as estruturas das tabelas as quais ela faz refer�ncia. As tabelas que participam da view n�o poder�o ter suas
					estrutue=ras alteradas enquanto a view n�o for alterada de forma compat�vel
intruao_select: Comando SELECT que ser� gravado na view
WITH CHECK OPTION: Inmpede a inclus�o e a altera��o de dados atrav�s da view que sejam incompat�veis com a cl�usula WHERE da instru��o SELECT*/

--CRIANDO UMA TABELA PARA TESTE DA VIEW
CREATE TABLE TB_TESTE
(
	Nome VARCHAR(50) NULL,
	Telefone VARCHAR(30) NULL
)
GO

--INSERINDO DADOS
INSERT INTO TB_TESTE
(Nome)
VALUES('Jos�'), ('Maria'), ('Jo�o')
GO

--CRIANDO UMA VIEW
CREATE VIEW VIE_TESTE
WITH ENCRYPTION
AS
SELECT	Nome,
		Telefone
FROM TB_TESTE
WHERE Telefone IS NULL
GO

--INSERINDO DADOS NA VIEW
INSERT INTO VIE_TESTE
(Nome, Telefone)
VALUES('Marcos','1123232312')
GO

select * from VIE_TESTE
select * from TB_TESTE
GO

--ALETERANDO A VIEW PARA QUE ELA FA�A A CHECAGEM DOS DADOS INSERIDOS
ALTER VIEW VIE_TESTE
WITH ENCRYPTION
AS
SELECT	Nome,
		Telefone
FROM TB_TESTE
WHERE Telefone IS NULL
WITH CHECK OPTION
GO

--INSERIDO O CAMPO TELEFONE null POIS NA DECLARA��O DA VIEW A CL�USULA where FOI DECLARADA COMO NULA
INSERT INTO VIE_TESTE
(Nome, Telefone)
VALUES('Juliano',NULL)
GO
--CRIANDO UMA VIEW COM DECLARA��O DA with encryption. ESSA FUNC��O CRIA A VIEW CRIPTOGRAFADA, OU SEJA, N�O PODE SER VISUALIZADA (escript de cria��o)
CREATE VIEW VIE_PED1 WITH ENCRYPTION
AS
SELECT P.NumeroPedido, P.DataPedido, F.NomeCompleto
FROM TB_PEDIDO P 
JOIN TB_FUNCIONARIO F
	ON P.FuncionarioId =F.FuncionarioId
GO

SELECT * FROM VIE_PED1
WHERE NomeCompleto = 'Janet Leverling'

--REALIZANDO UMA ALTERA��O NA TABELA funcionarios
ALTER TABLE [dbo].[TB_FUNCIONARIO]
ADD Teste VARCHAR(50) NULL
GO

--CRIANDO UMA VIEW E IREMOS DECLARAR TANTO with encryption	QUANTO schemabinding. COM ISSO AL�M DE CRIPTOGRAFAR IREMOS TAMB�M VINCULAR A COLUNA Teste A VIEW
CREATE VIEW VIE_PED2
WITH ENCRYPTION, SCHEMABINDING
AS 
SELECT	F.NomeCompleto,
		P.NumeroPedido,
		F.Teste
FROM DBO.TB_FUNCIONARIO F
JOIN DBO.TB_PEDIDO P 
	ON F.FuncionarioId = P.FuncionarioId
GO

--UMA VEZ CRIADO A VIEW USANDO A FUN��O schemabindig,  VINCULAMOS A COLUNA Teste  E COM ISSO ESSA COLUNA N�O PODE SER ALTERADA OU APAGADA
SELECT * FROM VIE_PED2
GO

--ALTERANDO A VIEW - NESSE EXEMPLO IREMOS RETIRAR A FUN��O 'SCHEMABINDING' E A COLUNA ' F.Teste', POIS ASSIM A TABELA FICAR� LIVRE PARA ALTERA��ES
--E A RETIRADA DA COLUNA 'F.Teste' NOS PERMITIR� USAR A MESMA VIEW SEM ERROS FUTUROS

ALTER VIEW VIE_PED2
WITH ENCRYPTION
AS 
SELECT	F.NomeCompleto,
		P.NumeroPedido
FROM DBO.TB_FUNCIONARIO F
JOIN DBO.TB_PEDIDO P 
	ON F.FuncionarioId = P.FuncionarioId
GO

--DROP VIEW
DROP VIEW VIE_PED2
