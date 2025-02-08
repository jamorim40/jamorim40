/*COMANDOS IIF retorna um dos dois argumentos passados, dependendo do valor 
obtido em uma express�o booleana

IFF (<expressao_booleana>, <valor_positivo>, <valor_negativo>)
*/

--EXEMPLO_1
SELECT IIF(2=2, 'VERDADE', 'MENTIRA') --retorna verdade pois 2 � igual a 2
SELECT IIF(2=4, 'VERDADE', 'MENTIRA') --retorna mentira pois 2 n�o � igual a 4

--EXEMPLO_2
SELECT NomeCompleto, IIF(Salario >= 5000, 'PADR�O', 'FORA DO PADR�O') FROM TB_FUNCIONARIO


/*O comando CHOOSE age com um �ndice em uma lista de valores. O argumento �ndice
determina qual dos valores seguintes ser� retornado

CHOOSE(<indice>, <valor_1>, <valor_2> [, <valor_n1~>])
*/
--EXEMPLO
SELECT CHOOSE(3, 'PRIMEIRO', 'SEGUNDO', 'TERCEIRO', 'QUARTO', 'QUINTO') --NESSE EXEMPLO COM O USO DO 'CHOOSE' O RETORNO SER� = 'TERCEIRO', POIS
																		-- COMO INDICE DECLARAOS O VALOR '3' QUE SER� A TERCEIRA POSI��O NA LISTA INFORMADA
