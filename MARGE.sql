
CREATE TABLE dbo.TB_FUNCIONARIO_TEMP
(
	FuncionarioId INT NOT NULL PRIMARY KEY,
	NomeCompleto VARCHAR(70) NOT NULL,
	Cargo VARCHAR(50) NOT NULL,
	DataNascimento DATETIME2(7) NOT NULL,
	Salario MONEY NOT NULL
)
GO

INSERT INTO dbo.TB_FUNCIONARIO_TEMP
(FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario)
	SELECT FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario FROM TB_FUNCIONARIO
GO

DELETE dbo.TB_FUNCIONARIO_TEMP WHERE FuncionarioId IN(1,2,3)
GO

UPDATE DBO.TB_FUNCIONARIO_TEMP SET Salario = 500 WHERE FuncionarioId IN(9,8,7)
GO

SELECT * FROM TB_FUNCIONARIO_TEMP
SELECT * FROM TB_FUNCIONARIO

MERGE dbo.TB_FUNCIONARIO_TEMP AS ALVO 
USING dbo.TB_FUNCIONARIO AS ORIGEM 
	ON ALVO.FuncionarioId = ORIGEM.FuncionarioId 
WHEN MATCHED AND ALVO.Salario <> ORIGEM.Salario 
	THEN UPDATE SET ALVO.salario = ORIGEM.Salario
WHEN NOT MATCHED
	THEN
		INSERT (FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario)
		VALUES (FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario);

/*
Essa consulta SQL utiliza o comando `MERGE`, que é usado para sincronizar dados entre duas tabelas. Vamos analisar cada parte do código em detalhes.  

---

## **1. Entendendo o que o `MERGE` faz**
O `MERGE` permite **inserir, atualizar ou excluir registros** em uma tabela de destino com base em uma tabela de origem, de forma eficiente.

- **`dbo.TB_FUNCIONARIO_TEMP`** → É a **tabela de destino** (onde as mudanças serão aplicadas).  
- **`dbo.TB_FUNCIONARIO`** → É a **tabela de origem** (de onde os dados são obtidos para comparação e possível atualização/inserção).

---

## **2. Explicação passo a passo do código**
```sql
MERGE dbo.TB_FUNCIONARIO_TEMP AS ALVO 
USING dbo.TB_FUNCIONARIO AS ORIGEM 
    ON ALVO.FuncionarioId = ORIGEM.FuncionarioId 
```
- Aqui, definimos a tabela de destino (`ALVO`) e a tabela de origem (`ORIGEM`).
- A cláusula `ON` especifica a **condição de correspondência**, que neste caso é `FuncionarioId` (ou seja, um funcionário é o mesmo nas duas tabelas se tiver 
o mesmo ID).

---

### **2.1 Quando há correspondência (`WHEN MATCHED`)**
```sql
WHEN MATCHED AND ALVO.Salario <> ORIGEM.Salario 
    THEN UPDATE SET ALVO.salario = ORIGEM.Salario
```
- Se um **registro existir em ambas as tabelas** (`MATCHED`), a condição `AND ALVO.Salario <> ORIGEM.Salario` verifica se o salário é diferente.
- Se for diferente, o comando **atualiza o salário** da tabela `TB_FUNCIONARIO_TEMP` (`ALVO`) para o valor da `TB_FUNCIONARIO` (`ORIGEM`).

**⚠️ Importante:**  
- Apenas registros com salários diferentes serão atualizados.
- Se os salários forem iguais, nenhuma atualização será feita.

---

### **2.2 Quando não há correspondência (`WHEN NOT MATCHED`)**
```sql
WHEN NOT MATCHED
    THEN
        INSERT (FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario)
        VALUES (FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario);
```
- Se um registro **está na tabela de origem (`ORIGEM`) mas não na tabela de destino (`ALVO`)**, ele será **inserido** em `TB_FUNCIONARIO_TEMP`.
- Todos os campos necessários (`FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario`) são preenchidos com os valores correspondentes da tabela `ORIGEM`.

---

## **3. O que essa consulta faz na prática?**
1. **Se um funcionário já existe nas duas tabelas**, mas o salário é diferente → **Atualiza o salário na tabela `TB_FUNCIONARIO_TEMP`**.
2. **Se um funcionário existe na tabela de origem (`TB_FUNCIONARIO`) e não existe na de destino (`TB_FUNCIONARIO_TEMP`)** → **Insere o funcionário na tabela `TB_FUNCIONARIO_TEMP`**.
3. **Se um funcionário existe na tabela de destino (`TB_FUNCIONARIO_TEMP`) mas não na origem (`TB_FUNCIONARIO`)**, essa consulta **não faz nada**.  
   - Se você quisesse remover esses funcionários, teria que adicionar um `WHEN NOT MATCHED BY SOURCE THEN DELETE;`

---

## **4. Exemplo prático**
### **Suponha que temos essas tabelas**

#### **Tabela `TB_FUNCIONARIO` (Origem)**
| FuncionarioId | NomeCompleto | Cargo  | DataNascimento | Salario |
|--------------|-------------|--------|---------------|---------|
| 1            | Ana Silva   | Analista | 1990-05-10    | 5000    |
| 2            | João Souza  | Gerente  | 1985-08-20    | 7000    |
| 3            | Maria Lima  | Assistente | 1992-10-05    | 3000    |

#### **Tabela `TB_FUNCIONARIO_TEMP` (Destino)**
| FuncionarioId | NomeCompleto | Cargo  | DataNascimento | Salario |
|--------------|-------------|--------|---------------|---------|
| 1            | Ana Silva   | Analista | 1990-05-10    | 4500    |
| 2            | João Souza  | Gerente  | 1985-08-20    | 7000    |

### **Após rodar o `MERGE`, o que acontece?**
1. **Ana Silva (ID=1)** já existe, mas o salário está diferente (**4500 ≠ 5000**) → Atualiza o salário para **5000**.
2. **João Souza (ID=2)** já existe e o salário é igual → Não faz nada.
3. **Maria Lima (ID=3)** existe na tabela `TB_FUNCIONARIO`, mas não na `TB_FUNCIONARIO_TEMP` → Insere o registro na `TB_FUNCIONARIO_TEMP`.

#### **Resultado final da `TB_FUNCIONARIO_TEMP`**
| FuncionarioId | NomeCompleto | Cargo  | DataNascimento | Salario |
|--------------|-------------|--------|---------------|---------|
| 1            | Ana Silva   | Analista | 1990-05-10    | 5000    |
| 2            | João Souza  | Gerente  | 1985-08-20    | 7000    |
| 3            | Maria Lima  | Assistente | 1992-10-05    | 3000    |

---

## **5. Conclusão**
Essa consulta `MERGE` **mantém a tabela `TB_FUNCIONARIO_TEMP` atualizada** com os dados da `TB_FUNCIONARIO`, garantindo que:
✅ Funcionários já existentes tenham o **salário atualizado**, se necessário.  
✅ Novos funcionários sejam **inseridos** na tabela temporária.  
✅ Nenhum funcionário seja removido da tabela temporária (mas poderia ser, se adicionássemos `WHEN NOT MATCHED BY SOURCE THEN DELETE;`).

*/


--OUTPUT em um MERGE
INSERT INTO dbo.TB_FUNCIONARIO_TEMP
(FuncionarioId, NomeCompleto, Cargo, DataNascimento,Salario)
VALUES
(123, 'MARIA DA SILVA', 'VENDEDPR(A)', '1968-12-08 00:00:00.0000000',3333),
(321, 'JOAO PADRO', 'VENDEDPR(A)', '1968-12-08 00:00:00.0000000',3333);


MERGE dbo.TB_FUNCIONARIO_TEMP AS ALVO 
USING dbo.TB_FUNCIONARIO AS ORIGEM 
	ON ALVO.FuncionarioId = ORIGEM.FuncionarioId 
WHEN MATCHED AND ALVO.Salario <> ORIGEM.Salario 
	THEN UPDATE SET ALVO.salario = ORIGEM.Salario
WHEN NOT MATCHED
	THEN
		INSERT (FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario)
		VALUES (FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario)
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE
		OUTPUT 
			$ACTION AS [AÇÃO],
			INSERTED.FuncionarioId  AS [FuncionarioId após],
			DELETED.FuncionarioId AS [FuncionarioId antes],
			INSERTED.NomeCompleto AS [NomeCompleto após],
			DELETED.NomeCompleto AS [NomeCompleto antes],
			INSERTED.Salario AS [Salario após],
			DELETED.Salario AS [Salario antes];

SELECT * FROM TB_FUNCIONARIO_TEMP

/*
O script usa o comando `MERGE` no SQL Server para sincronizar os dados entre duas tabelas:  
- **`dbo.TB_FUNCIONARIO_TEMP`** (a tabela de destino, chamada de `ALVO`)  
- **`dbo.TB_FUNCIONARIO`** (a tabela de origem, chamada de `ORIGEM`)  

Agora, vamos analisar cada parte do script em detalhes:

---

### 1️⃣ **Definição do `MERGE`**
```sql
MERGE dbo.TB_FUNCIONARIO_TEMP AS ALVO 
USING dbo.TB_FUNCIONARIO AS ORIGEM 
ON ALVO.FuncionarioId = ORIGEM.FuncionarioId
```
- A tabela `TB_FUNCIONARIO` (ORIGEM) será comparada com `TB_FUNCIONARIO_TEMP` (ALVO) usando a chave `FuncionarioId`.  
- Isso significa que, para cada linha na ORIGEM, ele buscará uma correspondência na ALVO com o mesmo `FuncionarioId`.

---

### 2️⃣ **Atualização de Registros Existentes (`WHEN MATCHED`)**
```sql
WHEN MATCHED AND ALVO.Salario <> ORIGEM.Salario 
    THEN UPDATE SET ALVO.salario = ORIGEM.Salario
```
- Quando um `FuncionarioId` da ORIGEM for encontrado na ALVO (`MATCHED`), mas os salários forem diferentes,  
  o salário da ALVO será atualizado com o valor da ORIGEM.  
- Assim, a ALVO sempre terá o salário mais recente da ORIGEM.

---

### 3️⃣ **Inserção de Novos Registros (`WHEN NOT MATCHED`)**
```sql
WHEN NOT MATCHED
    THEN
        INSERT (FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario)
        VALUES (FuncionarioId, NomeCompleto, Cargo, DataNascimento, Salario)
```
- Se um `FuncionarioId` da ORIGEM **não existir** na ALVO (`NOT MATCHED`),  
  então um novo registro será inserido na ALVO com todos os dados da ORIGEM.

---

### 4️⃣ **Exclusão de Registros Removidos na Origem (`WHEN NOT MATCHED BY SOURCE`)**
```sql
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
```
- Se um `FuncionarioId` da ALVO **não existir** na ORIGEM (`NOT MATCHED BY SOURCE`),  
  significa que ele foi removido da ORIGEM e, portanto, deve ser excluído da ALVO.

---

### 5️⃣ **Saída de Informações (`OUTPUT`)**
```sql
OUTPUT 
    $ACTION AS [AÇÃO],
    INSERTED.FuncionarioId  AS [FuncionarioId após],
    DELETED.FuncionarioId AS [FuncionarioId antes],
    INSERTED.NomeCompleto AS [NomeCompleto após],
    DELETED.NomeCompleto AS [NomeCompleto antes],
    INSERTED.Salario AS [Salario após],
    DELETED.Salario AS [Salario antes];
```
- **`$ACTION`**: Indica qual ação foi executada (`INSERT`, `UPDATE` ou `DELETE`).  
- **`INSERTED`**: Contém os valores **após** a alteração.  
- **`DELETED`**: Contém os valores **antes** da alteração.  
- Os campos selecionados ajudam a rastrear as mudanças feitas pela operação `MERGE`.  

### 📌 Exemplo de saída da consulta:
| AÇÃO   | FuncionarioId antes | FuncionarioId após | NomeCompleto antes | NomeCompleto após | Salario antes | Salario após |
|--------|---------------------|--------------------|---------------------|--------------------|--------------|--------------|
| UPDATE | 101                 | 101                | João Silva          | João Silva         | 5000         | 5500         |
| INSERT | NULL                | 105                | NULL                | Maria Santos       | NULL         | 4800         |
| DELETE | 102                 | NULL               | Pedro Souza         | NULL               | 6000         | NULL         |

- O `UPDATE` ocorreu porque o salário de João Silva mudou.  
- O `INSERT` adicionou um novo funcionário (`Maria Santos`).  
- O `DELETE` removeu um funcionário (`Pedro Souza`) que não estava mais na ORIGEM.  

---

### 📌 **Resumo das operações realizadas pelo `MERGE`:**
1. **Atualiza** (`UPDATE`) o salário se o `FuncionarioId` existir em ambas as tabelas e o salário for diferente.  
2. **Insere** (`INSERT`) um funcionário novo se ele existir na ORIGEM mas não na ALVO.  
3. **Exclui** (`DELETE`) um funcionário da ALVO se ele não estiver mais na ORIGEM.  
4. **Retorna os detalhes das alterações** via `OUTPUT`.  

Isso garante que a `TB_FUNCIONARIO_TEMP` fique sempre sincronizada com a `TB_FUNCIONARIO`.  
*/
