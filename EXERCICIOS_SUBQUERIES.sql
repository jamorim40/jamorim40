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
