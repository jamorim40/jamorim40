--TABELAS TEMPORARIAS
/*
As tabebela tempor�rias quandocriadas s�o salvas no banco de dados de sistema TempDB e podem de dois tipos:

- Locais
-Globais

Locais:
	S�o criadas com o prefixo '#' antes do nome da tabela,
	S�o visiveis apenas na conex�o responsav�l por sua cria��o.

Globais:
	S�o crisdas com dois prefixos '##' antes do nome da tabela,
	S�o vis�veis por todas conex�es
*/

--CRIANDO UMA TABELA LOCAL 
CREATE TABLE #TB_TEMP
(
	Nome VARCHAR(20) NULL
)

INSERT INTO #TB_TEMP(Nome) VALUES('JULIANO')

SELECT * FROM #TB_TEMP

/*

-- Criando a tabela tempor�ria local
CREATE TABLE #TB_TEMP
(
    Nome VARCHAR(20) NULL  -- Coluna que armazena nomes com at� 20 caracteres
)

-- Inserindo um valor na tabela tempor�ria
INSERT INTO #TB_TEMP(Nome) VALUES('JULIANO')

-- Consultando os dados da tabela tempor�ria
SELECT * FROM #TB_TEMP
```

O que acontece?  
1. **Cria��o**: A tabela `#TB_TEMP` � criada na **tempdb** e s� pode ser acessada dentro da mesma sess�o.  
2. **Inser��o**: O nome **"JULIANO"** � adicionado na coluna `Nome`.  
3. **Consulta**: O `SELECT` retorna os dados inseridos.  

Importante:  
- Se voc� rodar esse c�digo em outra sess�o (nova aba no SSMS), **n�o conseguir� acessar a tabela**, pois ela � local � sess�o original.  
- Assim que a sess�o terminar, o SQL Server **remove automaticamente** a tabela.  

Dicas de Uso:  
- Use tabelas tempor�rias quando precisar **armazenar dados tempor�rios** dentro de um procedimento ou query complexa.  
- Se precisar que a tabela seja compartilhada entre v�rias sess�es, use **tabelas tempor�rias globais** (`##TB_TEMP`).  

*/
--CRIANDO UMA TABELA GLOBAL 
CREATE TABLE ##TB_TEMP
(
	Nome VARCHAR(20) NULL
)

INSERT INTO ##TB_TEMP(Nome) VALUES('KELLY')

SELECT * FROM ##TB_TEMP

/*
Uma **Tabela Tempor�ria Global** no SQL Server � uma tabela tempor�ria que pode ser acessada por v�rias sess�es ou conex�es 
ao banco de dados. Ela � criada com `##` antes do nome da tabela e permanece dispon�vel at� que todas as conex�es que a est�o 
utilizando sejam encerradas.  

---

Como funciona?

1. **Cria��o**:  
   - A tabela tempor�ria global � criada com `##` antes do nome, por exemplo:  
     ```sql
     CREATE TABLE ##TempGlobal (
         ID INT PRIMARY KEY,
         Nome VARCHAR(100)
     );
     ```
   - Diferente da tabela tempor�ria local (`#TempLocal`), que � vis�vel apenas dentro da sess�o que a criou, a global pode ser usada por qualquer sess�o.

2. **Acesso e Uso**:  
   - Qualquer sess�o pode inserir, atualizar ou excluir dados na tabela.
   - Mesmo que a sess�o que criou a tabela seja encerrada, ela ainda estar� dispon�vel para outras conex�es.

3. **Exclus�o**:  
   - Ela � automaticamente exclu�da quando a �ltima conex�o que a estiver usando for fechada.
   - Tamb�m pode ser exclu�da manualmente com:  
     ```sql
     DROP TABLE ##TempGlobal;
     ```

---

### **Quando usar?**  

A tabela tempor�ria global � �til quando **m�ltiplos processos ou sess�es precisam compartilhar dados tempor�rios**. Alguns exemplos:  

Processamento em lote**: Diferentes processos ou usu�rios acessando um conjunto de dados tempor�rio.  
Integra��es**: Quando um processo externo precisa inserir dados tempor�rios para serem processados por outros servi�os.  
An�lises tempor�rias**: Quando diversos analistas ou consultas precisam acessar os mesmos dados tempor�rios antes de serem descartados.  

Cuidado**:  
- Se v�rias sess�es usarem a tabela ao mesmo tempo, pode haver conflitos de concorr�ncia.  
- Pode gerar bloqueios se muitos usu�rios tentarem acessar a mesma tabela.  

*/