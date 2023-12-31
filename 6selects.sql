--###################################################################################################################
--##########################################	EXIBIR  (SELECTS)	  ###############################################
--###################################################################################################################
/*
	OBJETIVO: visualizar um BOLETIM e informações de todas as tabelas que se relacionam com o mesmo
	PARÂMETROS: id_boletim
	RETORNO: setof
*/
CREATE OR REPLACE FUNCTION EXIBIR_BO(ID_BO INT)
RETURNS TABLE (
	FINALIZADO BOOLEAN, ID_BOLETIM INT, DESCRICAO VARCHAR(200), NOME_TIPO VARCHAR(50), NOME_CAUSA VARCHAR(50), NOME_CLASS VARCHAR(50),
	NOME_VIA VARCHAR(100), BAIRRO VARCHAR(50), MUNICIPIO VARCHAR(50), UF VARCHAR(50), DATA_HORA TIMESTAMP,
	LATITUDE REAL, LONGITUDE REAL, CATEGORIA VARCHAR(50), NOME_ENVOLVIDO VARCHAR(100),
	CPF VARCHAR(14), SEXO VARCHAR(1), DT_NASC DATE, ESCOLARIDADE VARCHAR(50), ENDERECO VARCHAR(200),
	CAPACETE_CINTO BOOLEAN, POSSUI_CNH BOOLEAN, PORTAVA_CNH BOOLEAN, CNH_VALIDA BOOLEAN, NUM_CNH VARCHAR(20),
	DT_PRIMEIRA_CNH DATE, DT_VALIDADE_CNH DATE, TIPO_VEICULO VARCHAR(30), FABRICANTE VARCHAR(30), MODELO VARCHAR(30),
	COR VARCHAR(15), ANO INT, PLACA VARCHAR(15), CHASSI VARCHAR(20), PROPRIETARIO BOOLEAN
)
AS $$
BEGIN
	RETURN QUERY
	SELECT
		T1.FINALIZADO, T1.ID_BOLETIM, T1.DESCRICAO, T1.NOME_TIPO, T1.NOME_CAUSA, T1.NOME_CLASS,
		T1.NOME_VIA, T1.BAIRRO, T1.MUNICIPIO, T1.UF, T1.DATA_HORA,
		T1.LATITUDE, T1.LONGITUDE, T1.CATEGORIA, T1.NOME_ENVOLVIDO,
		T1.CPF, T1.SEXO, T1.DT_NASC, T1.ESCOLARIDADE, T1.ENDERECO,
		T1.CAPACETE_CINTO, T1.POSSUI_CNH, T1.PORTAVA_CNH, T1.CNH_VALIDA, T1.NUM_CNH,
		T1.DT_PRIMEIRA_CNH, T1.DT_VALIDADE_CNH, T2.TIPO_VEICULO, T2.FABRICANTE, T2.MODELO,
		T2.COR, T2.ANO, T2.PLACA, T2.CHASSI, T2.PROPRIETARIO
	FROM
		((SELECT
		BOLETIM.FINALIZADO, BOLETIM.ID_BOLETIM, BOLETIM.DESCRICAO, TIPO_ACIDENTE.NOME_TIPO, CAUSA_ACIDENTE.NOME_CAUSA, CLASSIFICACAO_ACIDENTE.NOME_CLASS, VIA.NOME_VIA, LOCALIZACAO.BAIRRO, LOCALIZACAO.MUNICIPIO, LOCALIZACAO.UF, BOLETIM.DATA_HORA, LOCALIZACAO.LATITUDE, LOCALIZACAO.LONGITUDE,
		ENVOLVIMENTO.CATEGORIA, ENVOLVIDO.ID_ENVOLVIDO, ENVOLVIDO.NOME_ENVOLVIDO, ENVOLVIDO.CPF, ENVOLVIDO.SEXO, ENVOLVIDO.DT_NASC, ENVOLVIDO.ESCOLARIDADE, ENVOLVIDO.ENDERECO, ENVOLVIMENTO.CAPACETE_CINTO, 
		ENVOLVIDO.POSSUI_CNH, ENVOLVIMENTO.PORTAVA_CNH, ENVOLVIMENTO.CNH_VALIDA, CNH.NUM_CNH, CNH.DT_PRIMEIRA_CNH, CNH.DT_VALIDADE_CNH
		FROM 
		BOLETIM NATURAL JOIN LOCALIZACAO NATURAL JOIN TIPO_ACIDENTE NATURAL JOIN  CAUSA_ACIDENTE NATURAL JOIN 
		CLASSIFICACAO_ACIDENTE NATURAL JOIN LOCALIZACAO_VIA NATURAL JOIN VIA NATURAL JOIN ENVOLVIMENTO NATURAL JOIN
		ENVOLVIDO LEFT JOIN CNH ON ENVOLVIDO.ID_ENVOLVIDO = CNH.ID_ENVOLVIDO
		WHERE BOLETIM.ID_BOLETIM=ID_BO) T1
		LEFT JOIN
		(SELECT VEICULO.TIPO_VEICULO, VEICULO.FABRICANTE, VEICULO.MODELO, VEICULO.COR, VEICULO.ANO, VEICULO.PLACA, VEICULO.CHASSI, VEICULO_ENVOLVIDO_BOLETIM.PROPRIETARIO, VEICULO_ENVOLVIDO_BOLETIM.ID_ENVOLVIDO
		FROM VEICULO NATURAL JOIN VEICULO_ENVOLVIDO_BOLETIM
		WHERE VEICULO_ENVOLVIDO_BOLETIM.ID_BOLETIM=ID_BO) T2
		ON T1.ID_ENVOLVIDO = T2.ID_ENVOLVIDO);
END;
$$ Language 'plpgsql';

--SELECT * FROM EXIBIR_BO(100)




/*
	OBJETIVO: mostrar boletins que um envolvido se relaciona
	PARÂMETROS: cpf_envolvido
	RETORNO: tabela
*/
CREATE OR REPLACE FUNCTION EXIBIR_BOS_ENVOLVIDO(CPF_ENV VARCHAR(14))
RETURNS TABLE(
	ID_BOLETIM INT,
	DESCRICAO VARCHAR(200),
	DATA_HORA TIMESTAMP,
	CATEGORIA VARCHAR(30),
	NOME_ENVOLVIDO VARCHAR(100),
	CPF VARCHAR(15)
) 
AS $$
BEGIN
	IF NOT EXISTS (SELECT * FROM ENVOLVIDO WHERE ENVOLVIDO.CPF = CPF_ENV) THEN
		RAISE EXCEPTION 'ERRO: CPF NÃO ENCONTRADO';
	END IF;
	IF NOT EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN ENVOLVIDO WHERE ENVOLVIDO.CPF = CPF_ENV) THEN
		RAISE EXCEPTION 'ERRO: O ENVOLVIDO INFORMADO NÃO SE RELACIONA COM NENHUM BOLETIM';
	END IF;
	
	RETURN QUERY
	SELECT
	BOLETIM.ID_BOLETIM, BOLETIM.DESCRICAO, BOLETIM.DATA_HORA, ENVOLVIMENTO.CATEGORIA, ENVOLVIDO.NOME_ENVOLVIDO, ENVOLVIDO.CPF
	FROM
	ENVOLVIDO NATURAL JOIN ENVOLVIMENTO NATURAL JOIN BOLETIM
	WHERE 
	ENVOLVIDO.CPF = CPF_ENV;
END;
$$ Language 'plpgsql';





/*
	OBJETIVO: mostrar boletins que um veiculo se relaciona
	PARÂMETROS: placa_veiculo
	RETORNO: tabela
*/
CREATE OR REPLACE FUNCTION EXIBIR_BOS_VEICULO(PLAC_A VARCHAR(15))
RETURNS TABLE(
	ID_BOLETIM INT,
	DESCRICAO VARCHAR(200),
	DATA_HORA TIMESTAMP,
	FABRICANTE VARCHAR(30),
	MODELO VARCHAR(30),
	PLACA VARCHAR(15),
	COR VARCHAR(20),
	ANO INT
) 
AS $$
BEGIN
	IF NOT EXISTS (SELECT * FROM VEICULO WHERE VEICULO.PLACA = PLAC_A) THEN
		RAISE EXCEPTION 'ERRO: PLACA NAO ENCONTRADA';
	END IF;
	IF NOT EXISTS (SELECT * FROM VEICULO_ENVOLVIDO_BOLETIM NATURAL JOIN VEICULO WHERE VEICULO.PLACA = PLAC_A) THEN
		RAISE EXCEPTION 'ERRO: VEICULO INFORMADO NAO SE RELACIONA COM NENHUM BOLETIM';
	END IF;
	
	RETURN QUERY
	SELECT DISTINCT
	BOLETIM.ID_BOLETIM, BOLETIM.DESCRICAO, BOLETIM.DATA_HORA, VEICULO.FABRICANTE, VEICULO.MODELO, VEICULO.PLACA, VEICULO.COR, VEICULO.ANO
	FROM
	VEICULO NATURAL JOIN VEICULO_ENVOLVIDO_BOLETIM NATURAL JOIN BOLETIM
	WHERE
	VEICULO.PLACA = PLAC_A;
END;
$$ Language 'plpgsql';




/*
	OBJETIVO: mostrar boletins que uma via se relaciona
	PARÂMETROS: nome_via
	RETORNO: tabela
*/
CREATE OR REPLACE FUNCTION EXIBIR_BOS_VIA(N_VIA VARCHAR(50))
RETURNS TABLE(
	ID_BOLETIM INT,
	DESCRICAO VARCHAR(200),
	DATA_HORA TIMESTAMP,
	NOME_VIA VARCHAR(100)
)
AS $$
BEGIN
	IF NOT EXISTS(SELECT * FROM VIA WHERE VIA.NOME_VIA = N_VIA) THEN
		RAISE EXCEPTION 'ERRO: VIA NAO ENCONTRADA';
	END IF;
	IF NOT EXISTS (SELECT * FROM VIA NATURAL JOIN LOCALIZACAO_VIA NATURAL JOIN LOCALIZACAO NATURAL JOIN BOLETIM WHERE VIA.NOME_VIA = N_VIA) THEN
		RAISE EXCEPTION 'ERRO: VIA INFORMADA NAO SE RELACIONA COM NENHUM BOLETIM';
	END IF;
	
	RETURN QUERY
	SELECT
	BOLETIM.ID_BOLETIM, BOLETIM.DESCRICAO, BOLETIM.DATA_HORA, VIA.NOME_VIA
	FROM
	VIA NATURAL JOIN LOCALIZACAO_VIA NATURAL JOIN LOCALIZACAO NATURAL JOIN BOLETIM
	WHERE
	VIA.NOME_VIA = N_VIA;
END;
$$ Language 'plpgsql';
