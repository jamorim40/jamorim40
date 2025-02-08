 --DELARAÇÃO DE VARIAVEIS
 --SINTAXE
 DECLARE @NUM1 INT = 10, @NUM2 INT = 20, @RESULT INT
SET @RESULT=@NUM1 + @NUM2
PRINT @RESULT

/*
No SQL Server, a declaração de variável é usada para armazenar temporariamente valores que podem ser manipulados ao longo de um script T-SQL. 
Isso é útil em diversas situações, como armazenar resultados intermediários, evitar repetição de cálculos ou melhorar a legibilidade do código.

---

Como declarar uma variável no SQL Server**
A sintaxe básica para declarar uma variável no SQL Server é:

```sql
DECLARE @NomeVariavel TipoDeDado;
```

Após a declaração, a variável pode receber um valor com `SET` ou `SELECT`:

```sql
DECLARE @Nome VARCHAR(50);
SET @Nome = 'SQL Server';

DECLARE @Idade INT;
SELECT @Idade = 30;
```

---

## **Situações em que se deve usar uma variável**
1. **Armazenamento Temporário de Dados**  
   Quando precisamos guardar um valor que será usado em diferentes partes da consulta.
   ```sql
   DECLARE @PrecoUnitario DECIMAL(10,2);
   SET @PrecoUnitario = 100.50;

   SELECT @PrecoUnitario * 10 AS Total;
   ```

2. **Evitar Repetição de Cálculo**  
   Se um valor precisa ser recalculado várias vezes, usar uma variável melhora a eficiência.
   ```sql
   DECLARE @TotalPedidos INT;
   SELECT @TotalPedidos = COUNT(*) FROM Pedidos;

   SELECT @TotalPedidos AS TotalPedidos, 
          @TotalPedidos * 2 AS DobroPedidos;
   ```

3. **Passagem de Parâmetros em Procedimentos Armazenados**  
   Variáveis são úteis dentro de `Stored Procedures` para armazenar parâmetros de entrada.
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
   Variáveis são essenciais em loops e estruturas condicionais (`IF`, `WHILE`).
   ```sql
   DECLARE @Contador INT = 1;
   WHILE @Contador <= 5
   BEGIN
       PRINT 'Iteração número ' + CAST(@Contador AS VARCHAR);
       SET @Contador = @Contador + 1;
   END;
   ```

---

## **Cuidados ao Usar Variáveis**
- **Escopo:** Variáveis só existem dentro do bloco onde foram declaradas.
- **Nulo Padrão:** Se não forem inicializadas, assumem `NULL` como valor.
- **Melhoria de Performance:** Evitam consultas repetitivas para buscar um mesmo dado.
*/
