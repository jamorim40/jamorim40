

SELECT	C1.CATEGORIA,
		C1.ANO, 
		C1.FATURAMENTO,
		(C1.FATURAMENTO/ C2.FATURAMENTO) * 100 [PERCENTUAL (%)]

FROM	(SELECT	C.Descricao AS CATEGORIA,
				YEAR(P.DataPedido) AS ANO,
				SUM(D.Quantidade * D.Preco) AS FATURAMENTO
		FROM TB_DETALHE_PEDIDO D
		JOIN TB_PRODUTO PR
			ON D.ProdutoId = PR.ProdutoId
		JOIN TB_CATEGORIA C
			ON C.CategoriaId = PR.CategoriaId
		JOIN TB_PEDIDO P
			ON P.NumeroPedido = D.NumeroPedido
		WHERE YEAR(P.DataPedido) = 1996
		GROUP BY C.Descricao, YEAR(P.DataPedido)) C1

JOIN

		(SELECT	
				YEAR(P.DataPedido) AS ANO,
				SUM(D.Quantidade * D.Preco) AS FATURAMENTO
		FROM TB_DETALHE_PEDIDO D
		JOIN TB_PRODUTO PR
			ON D.ProdutoId = PR.ProdutoId
		JOIN TB_CATEGORIA C
			ON C.CategoriaId = PR.CategoriaId
		JOIN TB_PEDIDO P
			ON P.NumeroPedido = D.NumeroPedido
		WHERE YEAR(P.DataPedido) = 1996
		GROUP BY YEAR(P.DataPedido)) C2
ON C1.ANO = C2.ANO
ORDER BY C1.FATURAMENTO DESC
	
