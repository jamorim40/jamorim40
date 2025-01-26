--Conceito do uso de CONSTRAINT
--Uma boa pr�tica � declarar CONSTRAINT separado das declara�oes de variaveis, como por exemplo: declarar chave primaria (PRIMARY KEY)
--		Pois assim demos a oportunidade de identificar o nome dessa CONSTRAIT, caso contrario, o sistema ir� identificar usando posi��o de mem�ria

-------------------------------------CONSTRAINT - PRIMARY KEY -------------------------------------

--PRIMARY KEY - Aqui iremos 'criar' uam tabela declarando a PRIMARY KEY junto com a declara��o da variavel(ProdutoId)
CREATE TABLE TB_PRODUTO
(
	ProdutoId INT IDENTITY PRIMARY KEY, --Aqui como citado, declaramos a chave primaria junto com a variavel. O nome da PK = PK_TB_PRODU_9C8800R321R214F7
	DescricaoProduto VARCHAR(30)
)

--Aqui iremos 'criar' uma tabela declarando a PRIMARY KEY separado da declara��o da variavel (ClienteId)

CREATE TABLE TB_CLIENTE
(
	ClienteID INT IDENTITY,
	NomeCliente VARCHAR(30)

	CONSTRAINT PK_CLIENTE PRIMARY KEY(ClienteID) --Aqui como citado, declaramos a chave primaria separado da variavel. O nome da PK = PK_CLEINTE
)
--Dessa forma fica muito melhor para identificar o nome da CONSTRAINT

--Podemos tamb�m criar CONSTRAINT compostas, usaremos nesse exemplo chaves primarias compostas

CREATE TABLE CHAVES_COMPOSTAS
(
	Chave_1 INT IDENTITY,
	Chave_2 INT 

	CONSTRAINT PK_CHAVES_COMPOSTAS PRIMARY KEY(Chave_1, Chave_2)
)

-------------------------------------CONSTRAINT UNIQUE -------------------------------------

--UNIQUE - Aqui iremos utilizar a CONSTRAINT (UNIQUE), nesse cen�rio estaremos declarando que a variavel dever� receber um valor �nico, por�m, n�o se caracteriza como PK(primary key)
CREATE TABLE UNICO
(
	Cliente varchar(30),
	Cpf varchar(12) NOT NULL

	CONSTRAINT UQ_UNICO_CPF UNIQUE(Cpf) --Ao declarar essa CONSTRAINT (UNIQUE) garantimos que n�o haver� dois ou mais cadastro com o mesmo cpf
)

INSERT INTO UNICO VALUES('Juliano', '32929453800')
INSERT INTO UNICO VALUES('Kelly', '32929453800')

--Quando tentamos inserir o mesmo 'CPF' e por estar declarado como UNIQUE a seguinte mensagem de erro aparece:

	--Mensagem 2627, N�vel 14, Estado 1, Linha 44
	--Viola��o da restri��o UNIQUE KEY 'UQ_UNICO_CPF'. N�o � poss�vel inserir a chave duplicada no objeto 'dbo.UNICO'. O valor de chave duplicada � (32929453800).


--INCLUIR CONSTRAINT - Podemos incluir ou alterar CONSTRAINT caso seja necess�rio
--No exemplo irei colocar a sintaxe de como deveria ser:


-------------------------------------SINTAXE DE ALTER TABLE incluindo uma chave primaria-------------------------------------
--ALTER TABLE TB_PRODUTO
--ADD CONSTRAINT PK_PRODUTO PRIMARY KEY(ClienteId); --N�o vou execultar por tratase apenas da representa��o da sintaxe


-------------------------------------CONSTRAINT CHECK -------------------------------------
--CHECK - Usado para 'validar' se o dado inserido atende a alguma espesifica��o ou condi��o
--Como exemplo irei criar uma tabela onde ser� validado se o cliente � maior de 16 anos, caso n�os seja, um erro ser� apresentado
CREATE TABLE VALIDAR_IDADE
(
	Nome VARCHAR(30) NOT NULL,
	Idade VARCHAR(3) NOT NULL

	CONSTRAINT CK_VALIDAR_IDADE CHECK(Idade > 16)
)

INSERT INTO VALIDAR_IDADE VALUES('Juliano', '18')
INSERT INTO VALIDAR_IDADE VALUES('Kelly', '16')

--Quando tentamos isnerir a idade '16' ser� retronado o seguinte erro:
	--Mensagem 547, N�vel 16, Estado 0, Linha 75
	--A instru��o INSERT conflitou com a restri��o do CHECK "CK_VALIDAR_IDADE". O conflito ocorreu no banco de dados "anotacoes", tabela "dbo.VALIDAR_IDADE", column 'Idade'.

--Caso seja necess�rio podemos altera (inlcuir) a CONSTRAINT (CHECK) em tabelas onde inicialmente n�o havia sido previsto a valida��o

-------------------------------------SINTAXE DE ALTER TABLE incluindo uma CHECK-------------------------------------
--ALTER TABLE VALIDAR_IDADE
--ADD CONSTRAINT CK_VALIDAR_IDADE CHECK(Idade > 16)


-------------------------------------CONSTRAINT DEFAULT -------------------------------------
--DEFAULT -  Usado para garantir que um dado espesifico seja preenchido quando n�o informado pelo usu�rio cpm um tipo de dado espesifico
--Como expemplo irei criar uma tabela onde declararei um variavel dataCriacao e esse campo deve ser preenchido obigat�riamente com um tipo DATA, caso n�o seja, um erro ser� exibido
CREATE TABLE REGISTRO_USUARIO
(
	Id INT IDENTITY NOT NULL,
	Nome VARCHAR(30),
	DataCriacao DATETIME2 NOT NULL 
)

INSERT INTO REGISTRO_USUARIO VALUES('Juliano','2024-01-25') --informei a data
INSERT INTO REGISTRO_USUARIO VALUES('Kelly') --n�o informei a data:
																	--Mensagem 213, N�vel 16, Estado 1, Linha 100
																	--O nome da coluna ou o n�mero de valores fornecidos n�o corresponde � defini��o da tabela.

--Para resolver esse erro, podemos tratar de duas formas; declarando na cria��o da tabela ou realizando a altera��o 
--Criado a tabela com a DEFAULT:
	--CREATE TABLE REGISTRO_USUARIO
	--(
	--	Id INT IDENTITY NOT NULL,
	--	Nome VARCHAR(30),
	--	DataCriacao DATETIME2 NOT NULL DEFAULT GETDATE()
	--)
--Alterando a tabela incluindo a CONSTRAINT DAFAULT:
ALTER TABLE REGISTRO_USUARIO
ADD CONSTRAINT DF_USUARIO_DATACRIACAO DEFAULT(GETDATE()) FOR DataCriacao

INSERT INTO REGISTRO_USUARIO VALUES('Mirinalva','') --Nesse cen�rio o campo DataCriacao ser� preenchido com valor DATA ao inv�s de nulo



-------------------------------------CONSTRAINT - FOREIGN KEY -------------------------------------
--FOREINGN - Refere-se a chave estrangeira, ou seja, faz referencia a outra tabela. qaundo criamos tabelas e declaramos chaves(primarias e estrangeiras) estamos criando 
		--relacionamentos entre elas.
--No exmplo abaixo irei criar duas tabelas e fazer o relacionamento entres elas usando chave primaria (PRIMARY KEY) que j� vimos acima e usaremos tamb�m chave estrangeira (FOREIGN KEY)
		--para referenciar o relacionamento.

CREATE TABLE CLIENTE
(
	ClienteId INT IDENTITY,
	Cliente VARCHAR(30)

	CONSTRAINT PK_CLIENTE_ID PRIMARY KEY (ClienteID)
)

CREATE TABLE ENDERECO
(
	EnderecoId INT IDENTITY,
	Logradouro VARCHAR(50),
	Numero VARCHAR(5),
	Bairro VARCHAR(35),
	CEP VARCHAR(15),
	ClienteID INT --Iremos usar 'ClienteID' como para podermos referenciar nossa chave estrangeira

	CONSTRAINT PK_ENDERECO_ID PRIMARY KEY(EnderecoID),

	CONSTRAINT FK_ENDERECO_CLIENTE_CLIENTE_ID FOREIGN KEY (ClienteId) --criamos uma chave estrangeira onde    FK = foreign key
																											--ENDERECO � a tabela que estamos 
																											--CLIENTE � a tabela da referencia
																											--CLIENTE_ID � o campo onde est� a chave de compara��o
		REFERENCES CLIENTE(ClienteId) --referencia a tabelas que consta a chave primaria
)
--Alterando a tabela incluindo a CONSTRAINT fFOREIGN KEY:
	--ALTER TABLE CLIENTE
	--ADD CONSTRAINT FK_CLIENTE_ClienteId FOREIGN KEY (CLienteId)
	--REFERENCES CLIENTE(ClienteID)


DROP TABLE TB_PRODUTO;
DROP TABLE TB_CLIENTE;
DROP TABLE CHAVES_COMPOSTAS;
DROP TABLE UNICO;
DROP TABLE VALIDAR_IDADE;
DROP TABLE REGISTRO_USUARIO


-------------------------------------CRIANDO E EXCLUINDO TABELAS E CONSTRAINT -------------------------------------

CREATE TABLE TB_CLIENTE
(
	ClienteId INT IDENTITY,
	Cliente VARCHAR(30)

	CONSTRAINT PK_CLIENTE_ID PRIMARY KEY (ClienteID)
)

CREATE TABLE TB_ENDERECO
(
	EnderecoId INT IDENTITY,
	Logradouro VARCHAR(50),
	Numero VARCHAR(5),
	Bairro VARCHAR(35),
	CEP VARCHAR(15),
	ClienteID INT NULL

	CONSTRAINT PK_EDNDERECO_EnderecoId PRIMARY KEY(EnderecoId)
	CONSTRAINT FK_ENDERECO_CLIENTE_ClienteId FOREIGN KEY(ClienteId)
		REFERENCES TB_CLIENTE(ClienteId)
)

--Com a tabela j� criada e caso seja necess�rio excluir uma constraint, devemos utilizar a sintaxe ALTER TABLE conforme exemplo abaixo:
--SINTAXE:
	--ALTER TABLE 'TABELA'
	--DROP CONSTRAINT 'NOME DA COSNTRAINT'

ALTER TABLE TB_ENDERECO
DROP CONSTRAINT FK_ENDERECO_CLIENTE_ClienteId
