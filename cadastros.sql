--###################################################################################################################
--##########################################	CADASTROS	  #######################################################
--###################################################################################################################

--###################################################################################################################
--##################################	FASE 1 (BOLETIM/LOCALIZACAO)	  ###########################################
--###################################################################################################################
/*
	OBJETIVO: (1) Cadastrar BOLETIM e LOCALIZACAO. (2) Relacionar com Tipo, Causa e Classificação do acidente
	PARAMETROS: id_tipo, id_causa, id_class, descricao, bairro, latitude, longitude
	RETORNO: void
*/
CREATE OR REPLACE FUNCTION CADASTRA_BO(ID_BO INT, ID_LO INT, ID_TI INT, ID_CA INT, ID_CL INT, DESCR VARCHAR(100), BAIR VARCHAR(50), LATI REAL, LONG REAL)
RETURNS VOID AS $$
BEGIN
	INSERT INTO LOCALIZACAO VALUES(ID_LO, BAIR, 'TERESINA', 'PI', LATI, LONG); -- insere uma nova localizacao
	INSERT INTO BOLETIM VALUES(ID_BO, ID_TI, ID_CA, ID_CL, NOW(), DESCR, ID_LO, FALSE); -- insere um novo boletim
END;
$$ Language 'plpgsql';


--###################################################################################################################
--##################################	FASE 2 (VIA/LOCAL_VIA)	  ###################################################
--###################################################################################################################

/*
	OBJETIVO: cadastrar uma nova via ou relacionar uma via ja existente
	PARAMETROS: id_boletim, id_via, nome_via
	RETORNO: void
*/
CREATE OR REPLACE FUNCTION CADASTRA_VIA(ID_BO INT, ID_VI INT, NOME_VI VARCHAR(100))
RETURNS VOID AS $$
DECLARE
	COD_LOC INT;
	COD_VIA INT;
BEGIN
	SELECT ID_LOCAL INTO COD_LOC FROM BOLETIM NATURAL JOIN LOCALIZACAO WHERE ID_BOLETIM = ID_BO; -- id_local a partir de id_bo 
	
	IF EXISTS (SELECT * FROM LOCALIZACAO_VIA WHERE ID_LOCAL = COD_LOC AND ID_VIA = ID_VI) THEN --via ja esta relacionada ao boletim
		RAISE EXCEPTION 'ERRO: CÓDIGO PARA A VIA INFORMADA JÁ ESTÁ NO BOLETIM INFORMADO';
	END IF;
	IF EXISTS (SELECT * FROM VIA WHERE NOME_VIA = NOME_VI) THEN -- se existe uma via com o mesmo nome
		SELECT ID_VIA INTO COD_VIA FROM VIA WHERE NOME_VIA = NOME_VI; -- pega o codigo da via existente
		INSERT INTO LOCALIZACAO_VIA VALUES(COD_LOC, COD_VIA); -- insere em localizacao_via
	ELSE -- se nao existe uma via com o mesmo nome		
		INSERT INTO VIA VALUES(ID_VI, NOME_VI); -- insere a nova via
		INSERT INTO LOCALIZACAO_VIA VALUES(COD_LOC, ID_VI); -- insere em localizacao_via
	END IF;
END;
$$ Language 'plpgsql';



--###################################################################################################################
--##################################	FASE 3 (ENVOLVIDO/ENVOLVIMENTO/CNH)	  ###########################################
--###################################################################################################################
/*
	OBJETIVO: cadastrar um novo envolvido no sistema e relacionar a um boletim existente
	PARÂMETROS: id_boletim, id_envolvido, categoria, nome_envolvido, cpf, nascimento, sexo, escolaridade, endereco, 
				capacete/cinto, possui_cnh, portava_cnh, cnh_valida
	RETORNO: void
*/
-- ATENCAO: se porta CHN, entao deve-se preencher se a mesma estava valida(FAZER)
CREATE OR REPLACE FUNCTION 
CADASTRA_ENVOLVIDO_NOVO(ID_BO INT, ID_EN INT, CAT VARCHAR(50), NOME VARCHAR(100), _CPF VARCHAR(14), NASC DATE, SEX VARCHAR(1), 
ESCO VARCHAR(50), ENDE VARCHAR(200), CA_CI BOOLEAN, PO_CNH BOOLEAN, PT_CNH BOOLEAN, CNH_VAL BOOLEAN)
RETURNS VOID AS $$
BEGIN
	IF EXISTS (SELECT * FROM ENVOLVIMENTO WHERE ID_BOLETIM = ID_BO AND ID_ENVOLVIDO = ID_EN) THEN -- verifica se codigo do envolvido ja esta no boletim informado
		RAISE EXCEPTION 'ERRO: CÓDIGO PARA ENVOLVIDO INFORMADO JÁ ESTÁ EM BOLETIM INFORMADO';
	ELSE -- se codigo envolvido nao esta no boletim informado
		IF (PO_CNH=FALSE AND PT_CNH=TRUE) THEN -- se o envolvido nao possui CNH, ele nao pode dizer que porta
			RAISE EXCEPTION 'ERRO: INFORMADO QUE O ENVOLVIDO NAO POSSUI CNH, MAS QUE PORTAVA';
		ELSE
			INSERT INTO ENVOLVIDO VALUES(ID_EN, NOME, _CPF, NASC, SEX, PO_CNH, ESCO, ENDE);
			INSERT INTO ENVOLVIMENTO VALUES(ID_BO, ID_EN, CAT, CA_CI, PT_CNH, CNH_VAL);
		END IF;
	END IF;
END;
$$Language 'plpgsql';

/*
	OBJETIVO: relacionar um envolvido existente a um boletim
	PARÂMETROS: id_boletim, cpf, categoria, capacete_cinto, portava_cnh, cnh_valida
	RETORNO: void
*/
-- ATENCAO: se porta CHN, entao deve-se preencher se a mesma estava valida(FAZER)
CREATE OR REPLACE FUNCTION RELACIONA_ENVOLVIDO_EXISTENTE(ID_BO INT, _CPF VARCHAR(15), CAT VARCHAR(30), PT_CNH BOOLEAN, CNH_VAL BOOLEAN, CA_CI BOOLEAN)
RETURNS VOID AS $$
DECLARE
	COD_ENV INT;
BEGIN
	IF NOT EXISTS (SELECT * FROM ENVOLVIDO WHERE CPF = _CPF) THEN -- se o cpf nao for encontrado
		RAISE EXCEPTION 'ERRO: CPF NAO ENCONTRADO';
	END IF;
	
	SELECT ID_ENVOLVIDO INTO COD_ENV FROM ENVOLVIDO WHERE CPF = _CPF; -- busca o id do envolvido
	INSERT INTO ENVOLVIMENTO VALUES(ID_BO, COD_ENV, CAT, CA_CI, PT_CNH, CNH_VAL); -- insert em Envolvimento relacionando o envolvido com o boletim informado
END;
$$ Language 'plpgsql';



/*
	OBJETIVO: cadastrar uma cnh e relacionar a um envolvido do tipo motorista
	PARÂMETROS: id_envolvido, numero_cnh, data_primeira_cnh, data_validade_cnh
	RETORNO: void
*/
drop function cadastra_cnh()
CREATE OR REPLACE FUNCTION CADASTRA_CNH(_CPF VARCHAR(15), NUM_CNH VARCHAR(20), DT_PRI_CNH DATE, DT_VAL_CNH DATE)
RETURNS VOID AS $$
DECLARE
	COD_ENV INT;
	CAT VARCHAR(50);
	PO_CNH BOOLEAN;
BEGIN
	IF NOT EXISTS(SELECT * FROM ENVOLVIDO WHERE CPF = _CPF) THEN
		RAISE EXCEPTION 'ERRO: CPF NAO ENCONTRADO';
	END IF;
	
	SELECT ID_ENVOLVIDO INTO COD_ENV FROM ENVOLVIDO WHERE CPF = _CPF;
	SELECT CATEGORIA INTO CAT FROM ENVOLVIDO NATURAL JOIN ENVOLVIMENTO WHERE ID_ENVOLVIDO = COD_ENV; -- busca a categoria do envolvido informado
	SELECT POSSUI_CNH INTO PO_CNH FROM ENVOLVIDO WHERE ID_ENVOLVIDO = COD_ENV; -- busca o status de possui_cnh para o envolvido informado
	
	IF (PO_CNH = FALSE) THEN -- se nao possui cnh
		RAISE EXCEPTION 'ERRO: INFORMADO QUE O ENVOLVIDO CADASTRADO NAO POSSUI CNH';
	END IF;
	
	IF EXISTS (SELECT * FROM ENVOLVIDO NATURAL JOIN CNH WHERE ID_ENVOLVIDO = COD_ENV) THEN -- se o envolvido ja esta vindulado a uma cnh
		RAISE EXCEPTION 'ERRO: O ENVOLVIDO JÁ ESTÁ VINCULADO A UMA CNH';
	END IF;
	
	INSERT INTO CNH VALUES(DEFAULT, COD_ENV, NUM_CNH, DT_PRI_CNH, DT_VAL_CNH);
END;
$$Language 'plpgsql';



--###################################################################################################################
--##############################	FASE 4 (VEICULO/BOLETIM/ENVOLLVIDO)	  ###########################################
--###################################################################################################################
/*
	OBJETIVO: cadastrar um veículo
	PARÂMETROS: id_veiculo, tipo_veiculo, modelo, cor, ano, placa, chassi, 
	RETORNO:void
*/
CREATE OR REPLACE FUNCTION cadastra_veiculo(id_vei INT, tp_vei VARCHAR(30), 
											fabricante VARCHAR(30), model VARCHAR(30), cor VARCHAR(30), ano INT, 
											vei_placa VARCHAR(30), chassi_vei VARCHAR(30))
RETURNS VOID AS $$
BEGIN
	IF EXISTS (SELECT * FROM veiculo WHERE id_vei = id_veiculo OR placa = vei_placa OR chassi_vei = chassi) THEN
		RAISE EXCEPTION 'ERRO: JÁ EXISTEM DADOS NO SISTEMA COM VALORES IDÊNTICOS AO INFORMADO, POR FAVOR, VERIFIQUE E TENTE NOVAMENTE.';
	ELSE 
		INSERT INTO veiculo VALUES (id_vei, tp_vei, fabricante, model, cor, ano, vei_placa, chassi_vei);
	END IF;
END;
$$ LANGUAGE 'plpgsql'


/*
	OBJETIVO: relacioanr um VEICULO / ENVOLVIDO / BOLETIM
	PARÂMETROS:
	RETORNO:
*/

CREATE OR REPLACE FUNCTION relacionar_veiculo_envolvido_boletim (id_bol INT, id_env INT, id_vei INT, prop BOOL)
RETURNS VOID AS $$
DECLARE
	condutor BOOL;
BEGIN
	IF NOT EXISTS (SELECT * FROM ENVOLVIDO NATURAL JOIN ENVOLVIMENTO WHERE ID_BOLETIM=ID_BOL AND ID_ENVOLVIDO=ID_ENV) THEN
		RAISE EXCEPTION 'ERRO: O ENVOLVIDO NÃO PERTENCE AO BOLETIM QUE ESTA TENTANDO RELACIONAR';
	END IF;
	
	SELECT 
		CASE envolvimento.categoria 
			WHEN 'CONDUTOR' THEN TRUE
			ELSE FALSE
		END condutor
	INTO condutor
			FROM envolvimento WHERE envolvimento.id_boletim = id_bol AND envolvimento.id_envolvido = id_env;
	
	IF condutor = true 
	THEN 
		IF EXISTS (
			SELECT veb.id_envolvido
				FROM veiculo_envolvido_boletim veb
				INNER JOIN envolvimento e
					ON e.id_envolvido = veb.id_envolvido 
			AND e.categoria = 'CONDUTOR' 
			AND veb.id_boletim = id_bol
			AND veb.id_veiculo = id_vei
		) THEN
				RAISE EXCEPTION 'ERRO: Um veículo não pode ter mais de um condutor no mesmo boletim';
				
		END IF;
		
		IF EXISTS (
			SELECT * 
				FROM veiculo_envolvido_boletim veb 
				INNER JOIN envolvimento e 
					ON veb.id_envolvido = e.id_envolvido
	   		WHERE veb.id_boletim = id_bol AND veb.id_envolvido = id_env AND e.categoria ILIKE 'CONDUTOR'		
		) THEN
			RAISE EXCEPTION 'ERRO: Um condutor não pode ter mais de um veículo no mesmo boletim';
			
		END IF;
		
	ELSE
	
		IF EXISTS (SELECT * FROM envolvimento WHERE id_envolvido = id_env AND (categoria ILIKE 'PEDESTRE' OR categoria ILIKE 'CICLISTA' OR categoria ILIKE 'TESTEMUNHA')) THEN
			RAISE EXCEPTION 'ERRO: Envolvidos da categoria pedestre, ciclista e testemunha não podem se relacionar com um veículo';
		END IF;
		
		IF EXISTS (
			SELECT * 
				FROM veiculo_envolvido_boletim veb 
			WHERE veb.id_boletim = id_bol AND veb.id_envolvido = id_env
			) THEN
				RAISE EXCEPTION 'ERRO: Um envolvido não pode estar em mais de um veículo ao mesmo tempo';
	END IF;
		END IF;

	
			INSERT INTO veiculo_envolvido_boletim VALUES (id_bol, id_env, id_vei, prop);

END;
$$ LANGUAGE 'plpgsql'
