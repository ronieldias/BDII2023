--###################################################################################################################
--##########################################	CRIANDO TABELAS	  ###################################################
--###################################################################################################################
CREATE TABLE TIPO_ACIDENTE(
	ID_TIPO INT NOT NULL PRIMARY KEY,
	NOME_TIPO VARCHAR(50)
);

CREATE TABLE CAUSA_ACIDENTE(
	ID_CAUSA INT NOT NULL PRIMARY KEY,
	NOME_CAUSA VARCHAR(50)
);

CREATE TABLE CLASSIFICACAO_ACIDENTE(
	ID_CLASS INT NOT NULL PRIMARY KEY,
	NOME_CLASS VARCHAR(50)
);

CREATE TABLE LOCALIZACAO(
	ID_LOCAL INT NOT NULL PRIMARY KEY,
	BAIRRO VARCHAR(50) NOT NULL,
	MUNICIPIO VARCHAR(50) NOT NULL,
	UF VARCHAR(2) NOT NULL,
	LATITUDE REAL,
	LONGITUDE REAL
);

CREATE TABLE BOLETIM(
	ID_BOLETIM INT NOT NULL PRIMARY KEY,
	ID_TIPO INT REFERENCES TIPO_ACIDENTE,
	ID_CAUSA INT REFERENCES CAUSA_ACIDENTE,
	ID_CLASS INT REFERENCES CLASSIFICACAO_ACIDENTE,
	DATA_HORA TIMESTAMP NOT NULL,
	DESCRICAO VARCHAR(100) NOT NULL,
	ID_LOCAL INT REFERENCES LOCALIZACAO,
	FINALIZADO BOOLEAN NOT NULL
);

CREATE TABLE VIA(
	ID_VIA INT NOT NULL PRIMARY KEY,
	NOME_VIA VARCHAR(100) NOT NULL
);

CREATE TABLE LOCALIZACAO_VIA(
	ID_LOCAL INT NOT NULL,
	ID_VIA INT NOT NULL,
	CONSTRAINT CHAVE_LV PRIMARY KEY(ID_LOCAL, ID_VIA)
);

CREATE TABLE ENVOLVIDO(
	ID_ENVOLVIDO INT NOT NULL PRIMARY KEY,
	NOME_ENVOLVIDO VARCHAR(100) NOT NULL,
	CPF VARCHAR(14) NOT NULL,
	DT_NASC DATE NOT NULL,
	SEXO VARCHAR(1) NOT NULL,
	POSSUI_CNH BOOLEAN NOT NULL,
	ESCOLARIDADE VARCHAR(50),
	ENDERECO VARCHAR(200)
);

CREATE TABLE CNH(
	ID_CNH SERIAL PRIMARY KEY,
	ID_ENVOLVIDO INT NOT NULL REFERENCES ENVOLVIDO,
	NUM_CNH VARCHAR(20) NOT NULL,
	DT_PRIMEIRA_CNH DATE NOT NULL,
	DT_VALIDADE_CNH DATE NOT NULL
);

CREATE TABLE ENVOLVIMENTO(
	ID_BOLETIM INT NOT NULL REFERENCES BOLETIM,
	ID_ENVOLVIDO INT NOT NULL REFERENCES ENVOLVIDO,
	CATEGORIA VARCHAR(50) NOT NULL,
	CAPACETE_CINTO BOOLEAN,
	PORTAVA_CNH BOOLEAN,
	CNH_VALIDA BOOLEAN,
	CONSTRAINT CHAVE_E PRIMARY KEY(ID_BOLETIM, ID_ENVOLVIDO)
);

CREATE TABLE VEICULO(
	ID_VEICULO SERIAL PRIMARY KEY,
	TIPO_VEICULO VARCHAR(30) NOT NULL,
	FABRICANTE VARCHAR(30) NOT NULL,
	MODELO VARCHAR(30) NOT NULL,
	COR VARCHAR(15) NOT NULL,
	ANO INT NOT NULL,
	PLACA VARCHAR(15) NOT NULL,
	CHASSI VARCHAR(20) NOT NULL
);

CREATE TABLE VEICULO_ENVOLVIDO_BOLETIM(
	ID_BOLETIM INT NOT NULL REFERENCES BOLETIM,
	ID_ENVOLVIDO INT NOT NULL REFERENCES ENVOLVIDO,
	ID_VEICULO INT NOT NULL REFERENCES VEICULO,
	PROPRIETARIO BOOLEAN NOT NULL,
	CONSTRAINT CHAVE_VEB PRIMARY KEY(ID_BOLETIM, ID_ENVOLVIDO, ID_VEICULO)
);


--###################################################################################################################
--##########################################	INSERTS	  ###########################################################
--###################################################################################################################
INSERT INTO TIPO_ACIDENTE VALUES(1, 'COLISÃO FRONTAL');
INSERT INTO TIPO_ACIDENTE VALUES(2, 'COLISÃO TRASEIRA');
INSERT INTO TIPO_ACIDENTE VALUES(3, 'COLISÃO LATERAL');
INSERT INTO TIPO_ACIDENTE VALUES(4, 'COLISÃO TRANSVERSAL');
INSERT INTO TIPO_ACIDENTE VALUES(5, 'COLISÃO COM OBJETO FIXO');
INSERT INTO TIPO_ACIDENTE VALUES(6, 'COLISÃO COM OBJETO MÓVEL');
INSERT INTO TIPO_ACIDENTE VALUES(7, 'COLISÃO COM BICICLETA');
INSERT INTO TIPO_ACIDENTE VALUES(8, 'ATROPELAMENTO DE PESSOA');
INSERT INTO TIPO_ACIDENTE VALUES(9, 'ATROPELAMENTO DE ANIMAL');
INSERT INTO TIPO_ACIDENTE VALUES(10, 'CAPOTAMENTO');
INSERT INTO TIPO_ACIDENTE VALUES(11, 'TOMBAMENTO');
INSERT INTO TIPO_ACIDENTE VALUES(12, 'SAIDA DE PISTA');
INSERT INTO TIPO_ACIDENTE VALUES(13, 'DERRAMAMENTO DE CARGA');
INSERT INTO TIPO_ACIDENTE VALUES(14, 'INCÊNDIO');
INSERT INTO TIPO_ACIDENTE VALUES(15, 'QUEDA MOTOCICLETA / BICICLETA / OUTRO VEÍCULO');
INSERT INTO TIPO_ACIDENTE VALUES(16, 'DANOS EVENTUAIS');

INSERT INTO CLASSIFICACAO_ACIDENTE VALUES(1, 'SEM VÍTIMA');
INSERT INTO CLASSIFICACAO_ACIDENTE VALUES(2, 'COM VÍTIMAS FERIDAS');
INSERT INTO CLASSIFICACAO_ACIDENTE VALUES(3, 'COM VÍTIMAS FATAIS');

INSERT INTO CAUSA_ACIDENTE VALUES(1, 'DEFEITO NA VIA');
INSERT INTO CAUSA_ACIDENTE VALUES(2, 'DEFEITO MECÂNICO EM VEÍCULO');
INSERT INTO CAUSA_ACIDENTE VALUES(3, 'ANIMAIS NA PISTA');
INSERT INTO CAUSA_ACIDENTE VALUES(4, 'DESOBEDIÊNCIA À SINALIZAÇÃO');
INSERT INTO CAUSA_ACIDENTE VALUES(5, 'ULTRAPASSAGEM INDEVIDA');
INSERT INTO CAUSA_ACIDENTE VALUES(6, 'NÃO GUARDAR DISTÂNCIA DE SEGURANÇA');
INSERT INTO CAUSA_ACIDENTE VALUES(7, 'DORMINDO');
INSERT INTO CAUSA_ACIDENTE VALUES(8, 'VELOCIDADE INCOMPATÍVEL');
INSERT INTO CAUSA_ACIDENTE VALUES(9, 'FALTA DE ATENÇÃO');
INSERT INTO CAUSA_ACIDENTE VALUES(10, 'INGESTÃO DE ÁLCOOL');