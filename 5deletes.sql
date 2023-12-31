--###################################################################################################################
--##########################################	DELETAR	  ###########################################################
--###################################################################################################################
/*
	OBJETIVO: deletar boletim
	PARAMETROS: id_boletim
	RETORNO: void
*/
CREATE OR REPLACE FUNCTION DELETA_BO(ID_BO INT)
RETURNS VOID AS $$
DECLARE
	COD_LOC INT;
BEGIN
	IF NOT EXISTS (SELECT * FROM BOLETIM WHERE ID_BOLETIM = ID_BO) THEN
		RAISE EXCEPTION 'ERRO: O CÓDIGO PARA O BOLETIM INFORMADO NÃO EXISTE';
	END IF;
	
	SELECT ID_LOCAL INTO COD_LOC FROM BOLETIM WHERE ID_BOLETIM=ID_BO;
	
	DELETE FROM VEICULO_ENVOLVIDO_BOLETIM WHERE ID_BOLETIM=ID_BO;
	DELETE FROM ENVOLVIMENTO WHERE ID_BOLETIM=ID_BO;
	DELETE FROM LOCALIZACAO_VIA WHERE ID_LOCAL IN (SELECT ID_LOCAL FROM LOCALIZACAO WHERE ID_LOCAL IN (SELECT ID_LOCAL FROM BOLETIM WHERE ID_BOLETIM=ID_BO));
	DELETE FROM BOLETIM WHERE ID_BOLETIM=ID_BO;
	DELETE FROM LOCALIZACAO WHERE ID_LOCAL IN (SELECT ID_LOCAL FROM BOLETIM WHERE ID_BOLETIM=ID_BO);
	DELETE FROM LOCALIZACAO WHERE ID_LOCAL=COD_LOC;
END;
$$ Language 'plpgsql';




/*
	OBJETIVO: desvincular uma VIA de um BOLETIM
	PARÂMETROS: id_via, id_boletim
	RETORNO: void
*/
CREATE OR REPLACE FUNCTION DESVINCULA_VIA_BO(ID_VI INT, ID_BO INT)
RETURNS VOID AS $$
BEGIN
	IF NOT EXISTS (SELECT * FROM VIA NATURAL JOIN LOCALIZACAO_VIA NATURAL JOIN LOCALIZACAO NATURAL JOIN BOLETIM WHERE ID_BOLETIM = ID_BO AND ID_VIA=ID_VI) THEN
		RAISE EXCEPTION 'ERRO: CÓDIGO PARA VIA E BOLETINS INFORMADOS NÃO SE RELACIONAM';
	END IF;
	
	DELETE FROM LOCALIZACAO_VIA WHERE ID_LOCAL IN (SELECT ID_LOCAL FROM LOCALIZACAO WHERE ID_LOCAL IN (SELECT ID_LOCAL FROM BOLETIM WHERE ID_BOLETIM=ID_BO AND ID_VIA=ID_VI));
END;
$$ Language 'plpgsql';




/*
	OBJETIVO: desvincular um ENVOLVIDO de um BOLETIM
	PARÂMETROS: cpf, id_boletim
	RETORNO: void
*/
CREATE OR REPLACE FUNCTION DESVINCULA_ENVOLVIDO_BO(CPF_ENV VARCHAR(15), ID_BO INT)
RETURNS VOID AS $$
BEGIN
	IF NOT EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN ENVOLVIDO WHERE CPF=CPF_ENV AND ID_BOLETIM=ID_BO) THEN
		RAISE EXCEPTION 'ERRO: ERRO: CPF E ID_BOLETIM INFORMADOS NÃO SE RELACIONAM';
	END IF;
		
	DELETE FROM ENVOLVIMENTO WHERE ID_ENVOLVIDO IN (SELECT ID_ENVOLVIDO FROM ENVOLVIDO WHERE CPF=CPF_ENV AND ID_BOLETIM=ID_BO);
END;
$$ Language 'plpgsql';




/*
	OBJETIVO: desvincular um VEICULO de um BOLETIM	
	PARÂMETROS: placa, id_boletim
	RETORNO: void
*/
--ATENÇÃO: ao desvincular um veículo de um boletim, todos os relacionamentos de veiculo com os envolvidos do mesmo boletim serao desfeitos
CREATE OR REPLACE FUNCTION DESVINCULA_VEICULO_BO(PLACA_VEI VARCHAR(15), ID_BO INT)
RETURNS VOID AS $$
BEGIN
	IF NOT EXISTS (SELECT * FROM VEICULO_ENVOLVIDO_BOLETIM NATURAL JOIN VEICULO WHERE PLACA=PLACA_VEI AND ID_BOLETIM=ID_BO) THEN
		RAISE EXCEPTION 'ERRO: PLACA E ID_BOLETIM NÃO SE RELACIONAM';
	END IF;
	
	DELETE FROM VEICULO_ENVOLVIDO_BOLETIM WHERE ID_VEICULO IN (SELECT ID_VEICULO FROM VEICULO WHERE PLACA=PLACA_VEI AND ID_BOLETIM=ID_BO);
END;
$$ Language 'plpgsql'; 