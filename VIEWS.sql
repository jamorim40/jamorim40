/* VIEWS
Uma views é uma tabela virtual fromada por linhas e colunas de dados, os quais são provenientes de tabelas referenciadas em uma query que 
define a view. Suas linhas e colunas são geradas de forma dinâmicas no instante em que a referência a views é chamada.
A query que determina uma views pode ser proveniente de uma ou mais tabelas ou, até mesmo, de outras views. Para determinar uma view que 
utiliza dados proveninetes de fontes distintas, podemos utilizar as queries distribuidas.

As views podem ser de três tipos conforma sua finalidade:
- VIEWS STANDARD: Neste tipo de view são reunidos, em uma tabela virtual, dados provenientes de uma ou mais views ou tabelas base.
- VIEWS INDEXADAS: Este tipo de view é obtido por meio da criação de um índice clusterzado sobre a view.
- VIEWS PATRICIONADAS: Esse tipo de view permite que os dados em uma tabela sejam divididos em tavelas menores. Os dados são patrocinados
entre as tabelas de acordo com os valores aceitos nas colunas.
	
	SINTAXE:
	CREATE VIEW nome_view [coluna]
	[WITH[ENCRYPTION][,SCHEMABINDING]]
	AS intrucao_select
	[WITH CHECK OPTION]

nome_view: Nome da view
[coluna]: NOmes das colunas da view
WITH ENCRYPTION: Protege o c´digo fonte da view, impedidndo que ele seja aberto a partir do Object Explrer
WITH SCHEMABINDING: Cria uma view ligaada as estruturas das tabelas as quais ela faz referência. As tabelas que participam da view não poderão ter suas
					estrutue=ras alteradas enquanto a view não for alterada de forma compatível
intruao_select: Comando SELECT que será gravado na view
WITH CHECK OPTION: Inmpede a inclusão e a alteração de dados através da view que sejam incompatíveis com a cláusula WHERE da instrução SELECT*/

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
VALUES('José'), ('Maria'), ('João')
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

--ALETERANDO A VIEW PARA QUE ELA FAÇA A CHECAGEM DOS DADOS INSERIDOS
ALTER VIEW VIE_TESTE
WITH ENCRYPTION
AS
SELECT	Nome,
		Telefone
FROM TB_TESTE
WHERE Telefone IS NULL
WITH CHECK OPTION
GO

--INSERIDO O CAMPO TELEFONE null POIS NA DECLARAÇÃO DA VIEW A CLÁUSULA where FOI DECLARADA COMO NULA
INSERT INTO VIE_TESTE
(Nome, Telefone)
VALUES('Juliano',NULL)
GO
--CRIANDO UMA VIEW COM DECLARAÇÃO DA with encryption. ESSA FUNCÇÃO CRIA A VIEW CRIPTOGRAFADA, OU SEJA, NÃO PODE SER VISUALIZADA (escript de criação)
CREATE VIEW VIE_PED1 WITH ENCRYPTION
AS
SELECT P.NumeroPedido, P.DataPedido, F.NomeCompleto
FROM TB_PEDIDO P 
JOIN TB_FUNCIONARIO F
	ON P.FuncionarioId =F.FuncionarioId
GO

SELECT * FROM VIE_PED1
WHERE NomeCompleto = 'Janet Leverling'

--REALIZANDO UMA ALTERAÇÃO NA TABELA funcionarios
ALTER TABLE [dbo].[TB_FUNCIONARIO]
ADD Teste VARCHAR(50) NULL
GO

--CRIANDO UMA VIEW E IREMOS DECLARAR TANTO with encryption	QUANTO schemabinding. COM ISSO ALÉM DE CRIPTOGRAFAR IREMOS TAMBÉM VINCULAR A COLUNA Teste A VIEW
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

--UMA VEZ CRIADO A VIEW USANDO A FUNÇÃO schemabindig,  VINCULAMOS A COLUNA Teste  E COM ISSO ESSA COLUNA NÃO PODE SER ALTERADA OU APAGADA
SELECT * FROM VIE_PED2
GO

--ALTERANDO A VIEW - NESSE EXEMPLO IREMOS RETIRAR A FUNÇÃO 'SCHEMABINDING' E A COLUNA ' F.Teste', POIS ASSIM A TABELA FICARÁ LIVRE PARA ALTERAÇÕES
--E A RETIRADA DA COLUNA 'F.Teste' NOS PERMITIRÁ USAR A MESMA VIEW SEM ERROS FUTUROS

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
