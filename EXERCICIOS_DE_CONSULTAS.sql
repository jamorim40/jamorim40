--Exercicios

/*Faça uma consulta onde o resultado seja:
1- Qual produto teve maior quantidade de vendas no mês 7 de 1996*/
SELECT  TOP 1 
		PR.Descricao
		,SUM(DP.Quantidade) AS QTD
FROM TB_PRODUTO PR
	INNER JOIN TB_DETALHE_PEDIDO DP
		ON PR.ProdutoId = DP.ProdutoId
	INNER JOIN TB_PEDIDO P
		ON P.NumeroPedido = DP.NumeroPedido
WHERE P.DataPedido BETWEEN '1996-07-01' AND '1996-07-31'
GROUP BY PR.Descricao
ORDER BY SUM(DP.Quantidade) DESC
--========================================================================
--2- Qual cliente teve o maior gasto no mês 7 de 1996
SELECT TOP 1 
		C.NomeCompleto
		,SUM(D.Preco) AS 'TOTAL GASTO'
FROM TB_CLIENTE C
JOIN TB_PEDIDO P
ON C.ClienteId = P.ClienteId
JOIN TB_DETALHE_PEDIDO D
ON D.NumeroPedido = P.NumeroPedido
WHERE P.DataPedido BETWEEN '1996-07-01' AND '1996-07-31'
GROUP BY C.NomeCompleto
ORDER BY SUM(D.Preco) DESC
--========================================================================
--3- Listar todos clientes que moram na alemanha
SELECT C.NomeCompleto
		, E.Pais
FROM TB_CLIENTE C
	JOIN TB_ENDERECO E
		ON C.ClienteId = E.ClienteId
WHERE E.Pais = 'Alemanha'
--========================================================================
--4- Listar todos os clientes que compraram produtos da categoria bebida
SELECT C.NomeCompleto
		,SUM(D.Quantidade) AS SOMA
FROM TB_CLIENTE C
	JOIN TB_PEDIDO P 
		ON C.ClienteId =  P.ClienteId
	JOIN TB_DETALHE_PEDIDO D 
		ON P.NumeroPedido = D.NumeroPedido
	JOIN TB_PRODUTO PR 
		ON D.ProdutoId = PR.ProdutoId
	JOIN TB_CATEGORIA CA 
		ON PR.CategoriaId = CA.CategoriaId
WHERE CA.Descricao = 'Bebidas'
GROUP BY C.NomeCompleto
ORDER BY SUM(D.Quantidade) DESC






