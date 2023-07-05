--###############################################################################################################
--######################################	GATILHOS	#########################################################
--###############################################################################################################

-- OBJETIVO: nao permitir alteração de dados na tabela LOCALIZACAO_VIA quando um BOLETIM já estiver finalizado
drop trigger controla_localizacao_via on localizacao_via;
CREATE OR REPLACE TRIGGER CONTROLA_LOCALIZACAO_VIA
BEFORE INSERT OR DELETE OR UPDATE ON LOCALIZACAO_VIA
FOR EACH ROW
EXECUTE PROCEDURE TRATA_LOCALIZACAO_VIA()

-------------
drop function trata_localizacao_via()
CREATE OR REPLACE FUNCTION TRATA_LOCALIZACAO_VIA()
RETURNS TRIGGER AS $CONTROLA_LOCALIZACAO_VIA$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF EXISTS (SELECT * FROM LOCALIZACAO_VIA NATURAL JOIN LOCALIZACAO NATURAL JOIN BOLETIM WHERE ID_LOCAL=NEW.ID_LOCAL AND FINALIZADO=TRUE) THEN 
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NÃO PODE RECEBER DADOS NOVOS (LOCALIZACAO_VIA)';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF EXISTS (SELECT * FROM LOCALIZACAO_VIA NATURAL JOIN LOCALIZACAO NATURAL JOIN BOLETIM WHERE ID_LOCAL=OLD.ID_LOCAL AND FINALIZADO=TRUE) THEN 
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NÃO PODE SER ATUALIZADO (LOCALIZACAO_VIA)';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		IF EXISTS (SELECT * FROM LOCALIZACAO_VIA NATURAL JOIN LOCALIZACAO NATURAL JOIN BOLETIM WHERE ID_LOCAL=OLD.ID_LOCAL AND FINALIZADO=TRUE) THEN 
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NÃO PODE SER APAGADO (LOCALIZACAO_VIA)';
		END IF;
		RETURN OLD;
	END IF;
	RETURN NEW;
END;
$CONTROLA_LOCALIZACAO_VIA$ Language 'plpgsql';


--###############################################################################################################
-- OBJETIVO: nao permitir alteração de dados na tabela LOCALIZACAO quando um BOLETIM já estiver finalizado
drop trigger controla_localizacao on localizacao
CREATE OR REPLACE TRIGGER CONTROLA_LOCALIZACAO
BEFORE INSERT OR DELETE OR UPDATE ON LOCALIZACAO
FOR EACH ROW
EXECUTE PROCEDURE TRATA_LOCALIZACAO()

-------------
drop function trata_localizacao();
CREATE OR REPLACE FUNCTION TRATA_LOCALIZACAO()
RETURNS TRIGGER AS $CONTROLA_LOCALIZACAO$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF EXISTS (SELECT * FROM LOCALIZACAO WHERE ID_LOCAL=NEW.ID_LOCAL) THEN
			RAISE EXCEPTION 'ERRO: CODIGO DO LOCAL DUPLICADO';
		END IF;
		IF EXISTS (SELECT * FROM LOCALIZACAO NATURAL JOIN BOLETIM WHERE ID_LOCAL=NEW.ID_LOCAL AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NÃO PODE RECEBER DADOS NOVOS (LOCALIZCAO)';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF (NEW.ID_LOCAL <> OLD.ID_LOCAL) THEN
			RAISE EXCEPTION 'ERRO: BLOQUEADA A ALTERAÇÃO DE CHAVE PRIMÁRIA (LOCALIZACAO)';
		END IF;
		IF EXISTS (SELECT * FROM LOCALIZACAO NATURAL JOIN BOLETIM WHERE ID_LOCAL=OLD.ID_LOCAL AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NAO PODE SER ATUALIZADO (LOCALIZACAO)';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		IF EXISTS (SELECT * FROM LOCALIZACAO NATURAL JOIN BOLETIM WHERE ID_LOCAL=OLD.ID_LOCAL AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NAO PODE SER APAGADO (LOCALIZACAO)';
		END IF;
		RETURN OLD;
	END IF;
	RETURN NEW;
END;
$CONTROLA_LOCALIZACAO$ Language 'plpgsql';


--###############################################################################################################
--OBJETIVO: nao permitir alteração de dados na tabela ENVOLVIMENTO quando um BOLETIM já estiver finalizado
drop trigger controla_envolvimento on envolvimento
CREATE OR REPLACE TRIGGER CONTROLA_ENVOLVIMENTO
BEFORE INSERT OR DELETE OR UPDATE ON ENVOLVIMENTO
FOR EACH ROW 
EXECUTE PROCEDURE TRATA_ENVOLVIMENTO()

---------------
drop function trata_envolvimento();
CREATE OR REPLACE FUNCTION TRATA_ENVOLVIMENTO()
RETURNS TRIGGER AS $CONTROLA_ENVOLVIMENTO$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN BOLETIM WHERE ID_BOLETIM=NEW.ID_BOLETIM AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NÃO PODE RECEBER DADOS NOVOS (ENVOLVIMENTO)';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN BOLETIM WHERE ID_BOLETIM=OLD.ID_BOLETIM AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NAO PODE SER ATUALIZADO (ENVOLVIMENTO)';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		IF EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN BOLETIM WHERE ID_BOLETIM=OLD.ID_BOLETIM AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NAO PODE SER APAGADO (ENVOLVIMENTO)';
		END IF;
		RETURN OLD;
	END IF;
	RETURN NEW;
END;
$CONTROLA_ENVOLVIMENTO$ Language 'plpgsql';


--###############################################################################################################
--OBJETIVO: nao permitir alteração de dados na tabela VEICULO_ENVOLVIDO_BOLETIM quando um BOLETIM já estiver finalizado
drop trigger controla_veiculo_envolvido_boletim on veiculo_envolvido_boletim
CREATE OR REPLACE TRIGGER CONTROLA_VEICULO_ENVOLVIDO_BOLETIM
BEFORE INSERT OR DELETE OR UPDATE ON VEICULO_ENVOLVIDO_BOLETIM
FOR EACH ROW 
EXECUTE PROCEDURE TRATA_VEICULO_ENVOLVIDO_BOLETIM()


drop function trata_veiculo_envolvido_boletim()
CREATE OR REPLACE FUNCTION TRATA_VEICULO_ENVOLVIDO_BOLETIM()
RETURNS TRIGGER AS $CONTROLA_VEICULO_ENVOLVIDO_BOLETIM$
BEGIN
	--ATENÇÃO AQUI
	IF (TG_OP = 'INSERT') THEN
		IF NOT EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN BOLETIM WHERE ID_ENVOLVIDO=NEW.ID_ENVOLVIDO) THEN
			RAISE EXCEPTION 'ERRO: NAO SE PODE ATRIBUIR UM VEICULO A UM ENVOLVIDO QUE NAO ESTA NO BOLETIM';
		END IF;
		IF EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN BOLETIM WHERE ID_BOLETIM=NEW.ID_BOLETIM AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NÃO PODE RECEBER DADOS NOVOS (VEICULO_ENVOLVIDO_BOLETIM)';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF NOT EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN BOLETIM WHERE ID_ENVOLVIDO=NEW.ID_ENVOLVIDO) THEN
			RAISE EXCEPTION 'ERRO: NAO SE PODE ATRIBUIR UM VEICULO A UM ENVOLVIDO QUE NAO ESTA NO BOLETIM';
		END IF;
		IF EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN BOLETIM WHERE ID_BOLETIM=OLD.ID_BOLETIM AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NAO PODE SER ATUALIZADO (VEICULO_ENVOLVIDO_BOLETIM)';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		IF EXISTS (SELECT * FROM ENVOLVIMENTO NATURAL JOIN BOLETIM WHERE ID_BOLETIM=OLD.ID_BOLETIM AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NAO PODE SER APAGADO (VEICULO_ENVOLVIDO_BOLETIM)';
		END IF;
		RETURN OLD;
	END IF;
	RETURN NEW;
END;
$CONTROLA_VEICULO_ENVOLVIDO_BOLETIM$ Language 'plpgsql';


--###############################################################################################################
--OBJETIVO: não permitir alterações na tabela BOLETIM quando um BOLETIM já estiver finalizado
drop trigger controla_boletim on boletim
CREATE OR REPLACE TRIGGER CONTROLA_BOLETIMCONTROLA_BOLETIM
BEFORE INSERT OR DELETE OR UPDATE ON BOLETIM
FOR EACH ROW
EXECUTE PROCEDURE TRATA_BOLETIM()

----------------
drop function trata_boletim()
CREATE OR REPLACE FUNCTION TRATA_BOLETIM()
RETURNS TRIGGER AS $CONTROLA_BOLETIM$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF EXISTS (SELECT * FROM BOLETIM WHERE ID_BOLETIM=NEW.ID_BOLETIM) THEN
			RAISE EXCEPTION 'ERRO: CÓDIGO DO BOLETIM DUPLICADO';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF (NEW.FINALIZADO = OLD.FINALIZADO) THEN -- apenas a coluna finalizado pode ser alterada
			IF EXISTS (SELECT * FROM BOLETIM WHERE ID_BOLETIM=OLD.ID_BOLETIM AND FINALIZADO=TRUE) THEN
				RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NAO PODE SER ATUALIZADO (BOLETIM)';
			END IF;
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		IF EXISTS (SELECT * FROM BOLETIM WHERE ID_BOLETIM=OLD.ID_BOLETIM AND FINALIZADO=TRUE) THEN
			RAISE EXCEPTION 'ERRO: BOLETIM FINALIZADO NAO PODE SER APAGADO (BOLETIM)';
		END IF;
		RETURN OLD;
	END IF;
	RETURN NEW;
END;
$CONTROLA_BOLETIM$ Language 'plpgsql';


--###############################################################################################################
--OBJETIVO: controlar operações para a tabela ENVOLVIDO
drop trigger controla_envolvido on envolvido;
CREATE OR REPLACE TRIGGER CONTROLA_ENVOLVIDO
BEFORE INSERT OR UPDATE OR DELETE ON ENVOLVIDO
FOR EACH ROW 
EXECUTE PROCEDURE TRATA_ENVOLVIDO()

-----------
drop function trata_envolvido();
CREATE OR REPLACE FUNCTION TRATA_ENVOLVIDO()
RETURNS TRIGGER AS $CONTROLA_ENVOLVIDO$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF EXISTS (SELECT * FROM ENVOLVIDO WHERE ID_ENVOLVIDO=NEW.ID_ENVOLVIDO) THEN
			RAISE EXCEPTION 'ERRO: CODIGO DO ENVOLVIDO DUPLICADO';
		END IF;
		IF EXISTS (SELECT * FROM ENVOLVIDO WHERE CPF=NEW.CPF) THEN
			RAISE EXCEPTION 'ERRO: CPF DUPLICADO';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF ((NEW.ID_ENVOLVIDO <> OLD.ID_ENVOLVIDO) OR (NEW.CPF <> OLD.CPF) OR (NEW.DT_NASC <> OLD.DT_NASC) OR (NEW.SEXO <> OLD.SEXO)) THEN
			RAISE EXCEPTION 'ERRO: ATRIBUTOS DO TIPO ID, CPF, NASCIMENTO E SEXO NÃO PODEM SER ALTERADOS';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		RAISE EXCEPTION 'ERRO: NAO É PERMITIDA A EXCLUSÃO DE ENVOLVIDOS, AINDA QUE NAO ESTEJAM RELACIONADOS A UM BOLETIM';
	END IF;
	RETURN NEW;
END;
$CONTROLA_ENVOLVIDO$ Language 'plpgsql';


--###############################################################################################################
--OBJETIVO: controlar operações na tabela CNH
drop trigger controla_cnh on cnh
CREATE OR REPLACE TRIGGER CONTROLA_CNH
BEFORE INSERT OR DELETE OR UPDATE ON CNH
FOR EACH ROW
EXECUTE PROCEDURE TRATA_CNH()

----------------------------
drop function trata_cnh()
CREATE OR REPLACE FUNCTION TRATA_CNH()
RETURNS TRIGGER AS $CONTROLA_CNH$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF EXISTS (SELECT * FROM CNH WHERE ID_CNH=NEW.ID_CNH OR NUM_CNH=NEW.NUM_CNH) THEN
			RAISE EXCEPTION 'ERRO: DUPLICIDADE PARA ID_CNH OU PARA NUM_CNH';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF((NEW.ID_CNH <> OLD.ID_CNH) OR (NEW.ID_ENVOLVIDO <> OLD.ID_ENVOLVIDO) OR (NEW.NUM_CNH <> OLD.NUM_CNH) OR (NEW.DT_PRIMEIRA_CNH <> OLD.DT_PRIMEIRA_CNH)) THEN
			RAISE EXCEPTION 'ERRO: O UNICO DADO DE UMA CNH QUE PODE SER ALTERADO É A DATA DE VALIDADE';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		RAISE EXCEPTION 'ERRO: PROIBIDO APAGAR REGISTROS PARA A TABELA CNH';		
	END IF;
	RETURN NEW;
END;
$CONTROLA_CNH$ Language 'plpgsql';


--###############################################################################################################
--OBJETIVO: controlar operações na tabela VEICULO
drop trigger controla_veiculo
CREATE OR REPLACE TRIGGER CONTROLA_VEICULO
BEFORE INSERT OR DELETE OR UPDATE ON VEICULO
FOR EACH ROW
EXECUTE PROCEDURE TRATA_VEICULO()

----------------
drop function trata_veiculo()
CREATE OR REPLACE FUNCTION TRATA_VEICULO()
RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF EXISTS (SELECT * FROM VEICULO WHERE ID_VEICULO=NEW.ID_VEICULO OR PLACA=NEW.PLACA OR CHASSI=NEW.CHASSI) THEN
			RAISE EXCEPTION 'ERRO: ID_VEICULO, PLACA OU CHASSI DUPLICADO PARA VEICULO';
		END IF;
	END IF;
	IF (TG_OP = 'UPDATE') THEN
		IF ((NEW.ID_VEICULO<>OLD.ID_VEICULO) OR (NEW.TIPO_VEICULO<>OLD.TIPO_VEICULO) OR (NEW.FABRICANTE<>OLD.FABRICANTE) OR (NEW.MODELO<>OLD.MODELO) OR (NEW.ANO<>OLD.ANO) OR (NEW.PLACA<>OLD.PLACA) OR (NEW.CHASSI<>OLD.CHASSI)) THEN
			RAISE EXCEPTION 'ERRO: NÃO PERMITIDA A ALTERAÇÃO DE ID, TIPO, FABRICANTE, MODELO, ANO, PLACA OU CHASSI PARA VEÍCULO';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		RAISE EXCEPTION 'ERRO: PROIBIDO APAGAR REGISTROS PARA A TABELA VEICULO';
	END IF;
	RETURN NEW;
END;
$$ Language 'plpgsql';



--###############################################################################################################
--OBJETIVO: controlar operações na tabela VIA
drop trigger controla_via
CREATE OR REPLACE TRIGGER CONTROLA_VIA
BEFORE INSERT OR DELETE OR UPDATE ON VIA
FOR EACH ROW
EXECUTE PROCEDURE TRATA_VIA()

-----------------
drop function trata_via()
CREATE OR REPLACE FUNCTION TRATA_VIA()
RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		IF (NEW.ID_VIA <> OLD.ID_VIA) THEN
			RAISE EXCEPTION 'ERRO: NAO PERMITIDA A ALTERAÇÃO DE CHAVE PRIMARIA PARA A TABELA VIA';
		END IF;
		IF EXISTS (SELECT * FROM VIA WHERE NOME_VIA = NEW.NOME_VIA) THEN
			RAISE EXCEPTION 'ERRO: JÁ EXISTE OUTRA VIA COM O MESMO NOME NO REGISTRO';
		END IF;
	END IF;
	IF (TG_OP = 'DELETE') THEN
		RAISE EXCEPTION 'ERRO: PROIBIDO APAGAR REGISTROS PARA A TABELA VIA';
	END IF;
	RETURN NEW;
END;
$$ Language 'plpgsql';