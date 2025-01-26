

--===============Criar bancos===================--
	CREATE DATABASE nomeBanco
--=================================================--

--===============Criar colunas===================--
	CREATE TABLE nomeTabela 
	(nomeCampo varchar(tipo))
--=================================================--

--===============Criar constraint===================--
	CONSTRAINT nomeConstraint PRIMARY KEY (tipo) (campo_de_identificacao)
--=================================================--

--===============Inserir dados===================--
	INSERT INTO nomeTabela VALUES('dados de acordo com os tipos de cada campo')
--=================================================--

--===============Alterar colunas===================--
	ALTER TABLE tabela ALTER COLUMN nomeColuna DATE (tipo)
--=================================================--

--===============Adicionar colunas===================--
	ALTER TABLE tabela ADD novoCampo CHAR(tipo) NULL --definir sempre com NULL pois como já existe outras colunas e SQLServer pode reclamar a falta de dados
--=================================================--

--===============Alterar Constraint=================--
	ALTER TABLE tabela ADD CONSTRAINT nomeConstraint PRIMARY KEY (tipo) (campo_de_identificacao)
--=================================================--

--===============Atualizar campos===================--
	UPDATE nomeTabela SET nomeCampo = 'valor a ser atualizado' WHERE nomeCampo ('que será usado como condição de filtro') = 'condição'
--=================================================--

--===============Deletar campos (LINHA)===================--
DELETE nomeTabela WHERE nomeCampo ('que será usado como condição de filtro') = 'condição'
--=================================================--


--===============Selecionar determinados nº de linhas===================--
	SELECT TOP 3* FROM TB_CLIENTE --usado a função TOP e informado o nº de linhas a serem projetadas
--=================================================--

--===============Selecionar linhas exclusivas(unicas)===================--
	SELECT DISTINCT NomeCampo FROM TB_CLIENTE  --Importante informa o nome dos campos a serem exibidos, pois se houver dados repetidos e com Id diferentes, o distinnct irá considerar Id como distinto
--=================================================--

--===============Insert com TOP===================--
	INSERT TOP(3) INTO nomeTabelaDestino
	SELECT camposTabela
		FROM nomeTabelaOrigem
		WHERE nomeCampo ('que será usado como condição de filtro') = 'condição'
--=================================================--