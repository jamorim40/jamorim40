 --DELARA��O DE VARIAVEIS
 --SINTAXE
 DECLARE @NUM1 INT = 10, @NUM2 INT = 20, @RESULT INT
SET @RESULT=@NUM1 + @NUM2
PRINT @RESULT

/*
No SQL Server, a declara��o de vari�vel � usada para armazenar temporariamente valores que podem ser manipulados ao longo de um script T-SQL. 
Isso � �til em diversas situa��es, como armazenar resultados intermedi�rios, evitar repeti��o de c�lculos ou melhorar a legibilidade do c�digo.

---

Como declarar uma vari�vel no SQL Server**
A sintaxe b�sica para declarar uma vari�vel no SQL Server �:

```sql
DECLARE @NomeVariavel TipoDeDado;
```

Ap�s a declara��o, a vari�vel pode receber um valor com `SET` ou `SELECT`:

```sql
DECLARE @Nome VARCHAR(50);
SET @Nome = 'SQL Server';

DECLARE @Idade INT;
SELECT @Idade = 30;
```

---

## **Situa��es em que se deve usar uma vari�vel**
1. **Armazenamento Tempor�rio de Dados**  
   Quando precisamos guardar um valor que ser� usado em diferentes partes da consulta.
   ```sql
   DECLARE @PrecoUnitario DECIMAL(10,2);
   SET @PrecoUnitario = 100.50;

   SELECT @PrecoUnitario * 10 AS Total;
   ```

2. **Evitar Repeti��o de C�lculo**  
   Se um valor precisa ser recalculado v�rias vezes, usar uma vari�vel melhora a efici�ncia.
   ```sql
   DECLARE @TotalPedidos INT;
   SELECT @TotalPedidos = COUNT(*) FROM Pedidos;

   SELECT @TotalPedidos AS TotalPedidos, 
          @TotalPedidos * 2 AS DobroPedidos;
   ```

3. **Passagem de Par�metros em Procedimentos Armazenados**  
   Vari�veis s�o �teis dentro de `Stored Procedures` para armazenar par�metros de entrada.
   ```sql
   CREATE PROCEDURE ObterCliente
   @ClienteID INT
   AS
   BEGIN
       DECLARE @NomeCliente VARCHAR(100);
       SELECT @NomeCliente = Nome FROM Clientes WHERE ID = @ClienteID;
       PRINT 'Nome do Cliente: ' + @NomeCliente;
   END;
   ```

4. **Uso em Estruturas de Controle**  
   Vari�veis s�o essenciais em loops e estruturas condicionais (`IF`, `WHILE`).
   ```sql
   DECLARE @Contador INT = 1;
   WHILE @Contador <= 5
   BEGIN
       PRINT 'Itera��o n�mero ' + CAST(@Contador AS VARCHAR);
       SET @Contador = @Contador + 1;
   END;
   ```

---

## **Cuidados ao Usar Vari�veis**
- **Escopo:** Vari�veis s� existem dentro do bloco onde foram declaradas.
- **Nulo Padr�o:** Se n�o forem inicializadas, assumem `NULL` como valor.
- **Melhoria de Performance:** Evitam consultas repetitivas para buscar um mesmo dado.
*/
