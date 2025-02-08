/*
Em uma consulta (SELECT), os operadores LAG e LEAD permitem recuperar em campo de N linhas anteriores á atual
(LAG) ou posteriores á atual (LEAD).

LAG(coluna, offset [, default])
LEAD(coluna, offset [, default])
*/


SELECT	NomeCompleto,
		Salario
FROM TB_FUNCIONARIO

SELECT	NomeCompleto,
		Salario,
		LAG(Salario,1,0)  OVER(ORDER BY NomeCompleto) ,
		LEAD(Salario,1,0) OVER(ORDER BY NomeCompleto) 
FROM TB_FUNCIONARIO