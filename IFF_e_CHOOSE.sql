/*COMANDOS IIF retorna um dos dois argumentos passados, dependendo do valor 
obtido em uma expressão booleana

IFF (<expressao_booleana>, <valor_positivo>, <valor_negativo>)
*/

--EXEMPLO_1
SELECT IIF(2=2, 'VERDADE', 'MENTIRA') --retorna verdade pois 2 é igual a 2
SELECT IIF(2=4, 'VERDADE', 'MENTIRA') --retorna mentira pois 2 não é igual a 4

--EXEMPLO_2
SELECT NomeCompleto, IIF(Salario >= 5000, 'PADRÃO', 'FORA DO PADRÃO') FROM TB_FUNCIONARIO


/*O comando CHOOSE age com um índice em uma lista de valores. O argumento índice
determina qual dos valores seguintes será retornado

CHOOSE(<indice>, <valor_1>, <valor_2> [, <valor_n1~>])
*/
--EXEMPLO
SELECT CHOOSE(3, 'PRIMEIRO', 'SEGUNDO', 'TERCEIRO', 'QUARTO', 'QUINTO') --NESSE EXEMPLO COM O USO DO 'CHOOSE' O RETORNO SERÁ = 'TERCEIRO', POIS
																		-- COMO INDICE DECLARAOS O VALOR '3' QUE SERÁ A TERCEIRA POSIÇÃO NA LISTA INFORMADA
