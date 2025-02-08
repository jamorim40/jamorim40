--LACO DE REPEDI��O

DECLARE @NUM INT = 10;

WHILE (@NUM >=0)
BEGIN
	IF @NUM = 5
	BEGIN
		PRINT 'IGUAL A 5, CONTINUE'
		SET @NUM -=1;
		CONTINUE
		PRINT 'N�O RODAR MAIS O C�DIGO'
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
O la�o de repeti��o **`WHILE`** � uma estrutura de controle que executa um bloco de c�digo enquanto uma condi��o for verdadeira. 
O c�digo dentro do la�o ser� repetido at� que a condi��o se torne falsa.

No exemplo , temos um la�o **`WHILE`** que vai de `@NUM = 10` at� `@NUM = 0`, com duas instru��es espec�ficas dentro 
dele: **`CONTINUE`** e **`BREAK`**. Vamos detalhar o funcionamento:

 Funcionamento do c�digo:
1. **Declara��o de vari�veis:**
   ```sql
   DECLARE @NUM INT = 10;
   ```
   A vari�vel `@NUM` � inicializada com o valor 10.

2. **La�o `WHILE`:**
   O la�o **`WHILE (@NUM >= 0)`** vai executar o c�digo dentro dele enquanto o valor de `@NUM` for maior ou igual a zero.

3. **Dentro do la�o:**
   O c�digo verifica se o valor de `@NUM` � igual a 5:
   ```sql
   IF @NUM = 5
   BEGIN
       PRINT 'IGUAL A 5, CONTINUE'
       SET @NUM -=1;
       CONTINUE
   END
   ```
   - Se `@NUM` for igual a 5, o c�digo imprime "IGUAL A 5, CONTINUE", decrementa `@NUM` em 1 (fazendo-o igual a 4), e depois usa **`CONTINUE`**, 
   que faz a execu��o pular o restante do bloco de c�digo no la�o e retornar � verifica��o da condi��o.

4. **Impress�o do valor de `@NUM`:**
   Mesmo fora da condi��o `IF`, o valor de `@NUM` � impresso a cada itera��o:
   ```sql
   PRINT @NUM;
   ```

5. **Decremento de `@NUM`:**
   O valor de `@NUM` � decrementado ap�s a impress�o:
   ```sql
   SET @NUM -=1;
   ```

6. **Verifica��o de `@NUM = 2`:**
   Quando o valor de `@NUM` atingir 2, o c�digo imprime "IGUAL A 3, BREAK" (apesar de estar com uma mensagem incorreta) e usa **`BREAK`** para 
   interromper o la�o:
   ```sql
   IF @NUM = 2
   BEGIN
       PRINT 'IGUAL A 3, BREAK'
       BREAK
   END
   ```

7. **Fim do la�o:**
   O la�o termina quando a condi��o do `WHILE` n�o for mais verdadeira ou quando o **`BREAK`** for executado.

### Situa��o em que utilizar o la�o de repeti��o:
Voc� deve usar um la�o de repeti��o (como `WHILE`, `FOR`, ou `LOOP`) quando precisar realizar uma opera��o repetitiva, geralmente quando:
- Voc� n�o sabe o n�mero exato de itera��es necess�rias e precisa que o la�o continue at� que uma condi��o seja atingida.
- Deseja realizar uma tarefa repetidamente at� que uma condi��o de parada seja atendida.
- Existem verifica��es ou condi��es espec�ficas durante a repeti��o que podem interromper ou modificar o fluxo do la�o, como o uso de `CONTINUE` ou `BREAK`.

Por exemplo:
- **`CONTINUE`**: Pula a execu��o do restante do bloco de c�digo e vai para a pr�xima itera��o do la�o.
- **`BREAK`**: Interrompe completamente o la�o de repeti��o, saindo dele independentemente da condi��o de parada.

### Situa��o t�pica:
- Processar registros em um banco de dados (como no seu caso, dentro de uma tabela).
- Executar tarefas repetitivas, como enviar e-mails ou realizar verifica��es at� que uma condi��o seja atendida.
- Contagem regressiva ou incremento de um contador at� um valor espec�fico.

No exemplo, o la�o executa um contador de 10 a 0, mas com condi��es especiais quando chega a 5 e 2, onde `CONTINUE` e `BREAK` s�o usados para controlar o 
fluxo de execu��o.

*/