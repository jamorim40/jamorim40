--TABELAS TEMPORARIAS
/*
As tabebela temporárias quandocriadas são salvas no banco de dados de sistema TempDB e podem de dois tipos:

- Locais
-Globais

Locais:
	São criadas com o prefixo '#' antes do nome da tabela,
	São visiveis apenas na conexão responsavél por sua criação.

Globais:
	São crisdas com dois prefixos '##' antes do nome da tabela,
	São visíveis por todas conexões
*/

--CRIANDO UMA TABELA LOCAL 
CREATE TABLE #TB_TEMP
(
	Nome VARCHAR(20) NULL
)

INSERT INTO #TB_TEMP(Nome) VALUES('JULIANO')

SELECT * FROM #TB_TEMP

/*

-- Criando a tabela temporária local
CREATE TABLE #TB_TEMP
(
    Nome VARCHAR(20) NULL  -- Coluna que armazena nomes com até 20 caracteres
)

-- Inserindo um valor na tabela temporária
INSERT INTO #TB_TEMP(Nome) VALUES('JULIANO')

-- Consultando os dados da tabela temporária
SELECT * FROM #TB_TEMP
```

O que acontece?  
1. **Criação**: A tabela `#TB_TEMP` é criada na **tempdb** e só pode ser acessada dentro da mesma sessão.  
2. **Inserção**: O nome **"JULIANO"** é adicionado na coluna `Nome`.  
3. **Consulta**: O `SELECT` retorna os dados inseridos.  

Importante:  
- Se você rodar esse código em outra sessão (nova aba no SSMS), **não conseguirá acessar a tabela**, pois ela é local à sessão original.  
- Assim que a sessão terminar, o SQL Server **remove automaticamente** a tabela.  

Dicas de Uso:  
- Use tabelas temporárias quando precisar **armazenar dados temporários** dentro de um procedimento ou query complexa.  
- Se precisar que a tabela seja compartilhada entre várias sessões, use **tabelas temporárias globais** (`##TB_TEMP`).  

*/
--CRIANDO UMA TABELA GLOBAL 
CREATE TABLE ##TB_TEMP
(
	Nome VARCHAR(20) NULL
)

INSERT INTO ##TB_TEMP(Nome) VALUES('KELLY')

SELECT * FROM ##TB_TEMP

/*
Uma **Tabela Temporária Global** no SQL Server é uma tabela temporária que pode ser acessada por várias sessões ou conexões 
ao banco de dados. Ela é criada com `##` antes do nome da tabela e permanece disponível até que todas as conexões que a estão 
utilizando sejam encerradas.  

---

Como funciona?

1. **Criação**:  
   - A tabela temporária global é criada com `##` antes do nome, por exemplo:  
     ```sql
     CREATE TABLE ##TempGlobal (
         ID INT PRIMARY KEY,
         Nome VARCHAR(100)
     );
     ```
   - Diferente da tabela temporária local (`#TempLocal`), que é visível apenas dentro da sessão que a criou, a global pode ser usada por qualquer sessão.

2. **Acesso e Uso**:  
   - Qualquer sessão pode inserir, atualizar ou excluir dados na tabela.
   - Mesmo que a sessão que criou a tabela seja encerrada, ela ainda estará disponível para outras conexões.

3. **Exclusão**:  
   - Ela é automaticamente excluída quando a última conexão que a estiver usando for fechada.
   - Também pode ser excluída manualmente com:  
     ```sql
     DROP TABLE ##TempGlobal;
     ```

---

### **Quando usar?**  

A tabela temporária global é útil quando **múltiplos processos ou sessões precisam compartilhar dados temporários**. Alguns exemplos:  

Processamento em lote**: Diferentes processos ou usuários acessando um conjunto de dados temporário.  
Integrações**: Quando um processo externo precisa inserir dados temporários para serem processados por outros serviços.  
Análises temporárias**: Quando diversos analistas ou consultas precisam acessar os mesmos dados temporários antes de serem descartados.  

Cuidado**:  
- Se várias sessões usarem a tabela ao mesmo tempo, pode haver conflitos de concorrência.  
- Pode gerar bloqueios se muitos usuários tentarem acessar a mesma tabela.  

*/