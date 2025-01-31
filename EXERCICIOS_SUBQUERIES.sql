--SUBQUERIES
--EXEMPLOS
--========================================================================
--Traga a descrição dos produtos que possem o preço maior que a média de todos os produtos
SELECT P.Descricao 
FROM TB_PRODUTO P
WHERE P.Preco  >	(SELECT AVG(P2.Preco) 
					 FROM TB_PRODUTO P2)
--========================================================================
--Traga todos os clientes que exista pedidos no mês 7 de 1996
SELECT C.NomeCompleto
FROM TB_CLIENTE C
WHERE EXISTS (SELECT * FROM TB_PEDIDO P
						WHERE C.ClienteId = P.ClienteId
						AND P.DataPedido BETWEEN '1996-07-01' AND '1996-07-31') 
--========================================================================
--Traga o nome e o total de pedidos de cada cliente
SELECT C.NomeCompleto,
		(SELECT  COUNT(*)  FROM TB_PEDIDO P
				WHERE C.ClienteId = P.ClienteId) AS [TOTAL PEDIDOS]
FROM TB_CLIENTE C
ORDER BY [TOTAL PEDIDOS]

--========================================================================
SELECT C.*
FROM TB_CLIENTE C
WHERE NOT EXISTS
		(SELECT * FROM TB_PEDIDO P
		 WHERE P.ClienteId = C.ClienteId
			AND
			P.DataPedido BETWEEN '2020-07-01' AND '2020-07-31')
--========================================================================
--SUBQUERIES EM DELITE E UPDATE
SELECT * FROM TB_PRODUTO P JOIN TB_CATEGORIA C ON P.CategoriaId = C.CategoriaId WHERE C.Descricao = 'Bebidas'

UPDATE TB_PRODUTO
SET Preco += 1
WHERE CategoriaId = (SELECT CategoriaId FROM TB_CATEGORIA
						WHERE Descricao = 'Bebidas')

					
DELETE FROM TB_PEDIDO
WHERE FuncionarioId = 2  (SELECT FuncionarioId, Cargo FROM TB_FUNCIONARIO
	WHERE Cargo = 'Vice-Presidente de Vendas')
--========================================================================					

/* 
EXERCICIO 1:
QUAIS CARGOS POSSUEM MÉDIA SALARIAL MAIOR QUE A MÉDIA SALARIAL DO CARGO DE Coordenador de Vendas Internas
*/

--MINHA VERSÃO DE CONSULTA
SELECT Cargo, Salario 
FROM TB_FUNCIONARIO
WHERE Salario >		(SELECT Salario 
						FROM TB_FUNCIONARIO
						WHERE Cargo = 'Coordenador de Vendas Internas')

--VERSÃO DE CONSULTA DO PROFESSOR
SELECT F1.Cargo, AVG(F1.Salario)
FROM TB_FUNCIONARIO F1
GROUP BY F1.Cargo
HAVING AVG(F1.Salario) > (SELECT AVG(F2.Salario)
							FROM TB_FUNCIONARIO F2
							WHERE F2.Cargo = 'Coordenador de Vendas Internas')
--========================================================================
/* 
EXERCICIO 2:
QUAL PRODUTO TEVE MAIS VENDAS EM 07 DE 1996
*/

SELECT	 C1.Descricao
		,C1.QTD
		,C1.CategoriaId
FROM
(
	SELECT TOP 1 PR.Descricao
				,PR.CategoriaId
				, SUM( D.Quantidade) AS QTD 
	FROM TB_PRODUTO PR
	JOIN TB_DETALHE_PEDIDO D ON PR.ProdutoId = D.ProdutoId
	WHERE D.NumeroPedido IN (
							SELECT PE.NumeroPedido FROM TB_PEDIDO PE
							WHERE PE.DataPedido BETWEEN '1996-07-01' AND '1996-07-31'
							)
	GROUP BY PR.Descricao, PR.CategoriaId
	ORDER BY SUM(D.Quantidade) DESC
) AS C1

--========================================================================
/* 
EXERCICIO 3:
QUAL VENDEDOR TEVE O MAIOR VALOR NO TOTAL DE VENDAS
*/

SELECT C1.NomeCompleto, C1.TOTAL
FROM 
	(
		SELECT TOP 1 C2.NomeCompleto, SUM(D.Preco) TOTAL FROM TB_DETALHE_PEDIDO D
			JOIN	(SELECT P.NumeroPedido, F.NomeCompleto FROM TB_PEDIDO P
					JOIN TB_FUNCIONARIO F ON P.FuncionarioId = F.FuncionarioId
					WHERE F.Cargo = 'Representante de Vendas'
					) AS C2
			ON C2.NumeroPedido = D.NumeroPedido
			GROUP BY C2.NomeCompleto
			ORDER BY TOTAL DESC
	) AS C1
/* Primeiro realizamos a consulta c2 que irá alimentar a consulta c1, que por sua vez nos trará o resultado para a consulta principal
