--LACO DE REPEDIÇÃO

DECLARE @NUM INT = 10;

WHILE (@NUM >=0)
BEGIN
	IF @NUM = 5
	BEGIN
		PRINT 'IGUAL A 5, CONTINUE'
		SET @NUM -=1;
		CONTINUE
		PRINT 'NÃO RODAR MAIS O CÓDIGO'
	END

	PRINT @NUM;

	SET @NUM -=1;

	IF @NUM = 2
	BEGIN
		PRINT 'IGUAL A 2, BREAK'
		BREAK
	END
END

/*
O laço de repetição **`WHILE`** é uma estrutura de controle que executa um bloco de código enquanto uma condição for verdadeira. 
O código dentro do laço será repetido até que a condição se torne falsa.

No exemplo , temos um laço **`WHILE`** que vai de `@NUM = 10` até `@NUM = 0`, com duas instruções específicas dentro 
dele: **`CONTINUE`** e **`BREAK`**. Vamos detalhar o funcionamento:

 Funcionamento do código:
1. **Declaração de variáveis:**
   ```sql
   DECLARE @NUM INT = 10;
   ```
   A variável `@NUM` é inicializada com o valor 10.

2. **Laço `WHILE`:**
   O laço **`WHILE (@NUM >= 0)`** vai executar o código dentro dele enquanto o valor de `@NUM` for maior ou igual a zero.

3. **Dentro do laço:**
   O código verifica se o valor de `@NUM` é igual a 5:
   ```sql
   IF @NUM = 5
   BEGIN
       PRINT 'IGUAL A 5, CONTINUE'
       SET @NUM -=1;
       CONTINUE
   END
   ```
   - Se `@NUM` for igual a 5, o código imprime "IGUAL A 5, CONTINUE", decrementa `@NUM` em 1 (fazendo-o igual a 4), e depois usa **`CONTINUE`**, 
   que faz a execução pular o restante do bloco de código no laço e retornar à verificação da condição.

4. **Impressão do valor de `@NUM`:**
   Mesmo fora da condição `IF`, o valor de `@NUM` é impresso a cada iteração:
   ```sql
   PRINT @NUM;
   ```

5. **Decremento de `@NUM`:**
   O valor de `@NUM` é decrementado após a impressão:
   ```sql
   SET @NUM -=1;
   ```

6. **Verificação de `@NUM = 2`:**
   Quando o valor de `@NUM` atingir 2, o código imprime "IGUAL A 3, BREAK" (apesar de estar com uma mensagem incorreta) e usa **`BREAK`** para 
   interromper o laço:
   ```sql
   IF @NUM = 2
   BEGIN
       PRINT 'IGUAL A 3, BREAK'
       BREAK
   END
   ```

7. **Fim do laço:**
   O laço termina quando a condição do `WHILE` não for mais verdadeira ou quando o **`BREAK`** for executado.

### Situação em que utilizar o laço de repetição:
Você deve usar um laço de repetição (como `WHILE`, `FOR`, ou `LOOP`) quando precisar realizar uma operação repetitiva, geralmente quando:
- Você não sabe o número exato de iterações necessárias e precisa que o laço continue até que uma condição seja atingida.
- Deseja realizar uma tarefa repetidamente até que uma condição de parada seja atendida.
- Existem verificações ou condições específicas durante a repetição que podem interromper ou modificar o fluxo do laço, como o uso de `CONTINUE` ou `BREAK`.

Por exemplo:
- **`CONTINUE`**: Pula a execução do restante do bloco de código e vai para a próxima iteração do laço.
- **`BREAK`**: Interrompe completamente o laço de repetição, saindo dele independentemente da condição de parada.

### Situação típica:
- Processar registros em um banco de dados (como no seu caso, dentro de uma tabela).
- Executar tarefas repetitivas, como enviar e-mails ou realizar verificações até que uma condição seja atendida.
- Contagem regressiva ou incremento de um contador até um valor específico.

No exemplo, o laço executa um contador de 10 a 0, mas com condições especiais quando chega a 5 e 2, onde `CONTINUE` e `BREAK` são usados para controlar o 
fluxo de execução.

*/