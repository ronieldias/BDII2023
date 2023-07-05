/*
###############################################################################################################
####################################	PERMISSOES USUÁRIO	###################################################
###############################################################################################################
##########################################	  AGENTE	###################################################
*/
CREATE ROLE AGENTE;
GRANT SELECT, INSERT, DELETE, UPDATE 	ON BOLETIM 						TO AGENTE;
GRANT SELECT 						 	ON TIPO_ACIDENTE 				TO AGENTE;
GRANT SELECT 						 	ON CAUSA_ACIDENTE 				TO AGENTE;
GRANT SELECT 						 	ON CLASSIFICACAO_ACIDENTE 		TO AGENTE;
GRANT SELECT, INSERT, DELETE, UPDATE 	ON LOCALIZACAO 					TO AGENTE;
GRANT SELECT, INSERT, DELETE, UPDATE 	ON LOCALIZACAO_VIA 				TO AGENTE;
GRANT SELECT, INSERT, UPDATE 			ON VIA 							TO AGENTE;
GRANT SELECT, INSERT, DELETE, UPDATE 	ON ENVOLVIMENTO 				TO AGENTE;
GRANT SELECT, INSERT, UPDATE 		 	ON ENVOLVIDO 					TO AGENTE;
GRANT SELECT, INSERT, UPDATE 		 	ON CNH 							TO AGENTE;
GRANT SELECT, INSERT, DELETE, UPDATE 	ON VEICULO_ENVOLVIDO_BOLETIM 	TO AGENTE;
GRANT SELECT, INSERT, UPDATE			ON VEICULO 						TO AGENTE;
GRANT UPDATE, UPDATE					ON CNH_ID_CNH_SEQ				TO AGENTE;
GRANT SELECT, UPDATE					ON VEICULO_ID_VEICULO_SEQ		TO AGENTE;

GRANT SELECT 	ON RANK_VIAS_ACIDENTES									TO AGENTE;
GRANT SELECT 	ON rank_tipo_acidente									TO AGENTE;
GRANT SELECT 	ON rank_faixa_horario									TO AGENTE;
GRANT SELECT 	ON rank_causa_acidente									TO AGENTE;
GRANT SELECT 	ON rank_classificacao_acidente							TO AGENTE;
GRANT SELECT 	ON total_condutores_por_sexo_envolvidos_em_acidente		TO AGENTE;
GRANT SELECT 	ON rank_acidentes_por_marca_veiculos					TO AGENTE;
GRANT SELECT 	ON rank_idade_cnhs										TO AGENTE;
GRANT SELECT 	ON rank_acidentes_por_bairro							TO AGENTE;
GRANT SELECT 	ON rank_por_estado_fisico								TO AGENTE;
GRANT SELECT 	ON rank_usava_cinto_capacete							TO AGENTE;



CREATE USER AGENTE_TRANSITO
LOGIN
PASSWORD '123'
IN ROLE AGENTE

CREATE USER POLICIAL_MILITAR
LOGIN
PASSWORD '123'
IN ROLE AGENTE

/*
###############################################################################################################
########################################	ENVOLVIDO	#######################################################
*/
CREATE ROLE ENVOLVIDO
GRANT SELECT	ON BOLETIM	  					TO ENVOLVIDO;
GRANT SELECT	ON TIPO_ACIDENTE	  			TO ENVOLVIDO;
GRANT SELECT	ON CAUSA_ACIDENTE	  			TO ENVOLVIDO;
GRANT SELECT	ON CLASSIFICACAO_ACIDENTE	  	TO ENVOLVIDO;
GRANT SELECT	ON LOCALIZACAO	  				TO ENVOLVIDO;
GRANT SELECT	ON LOCALIZACAO_VIA	  			TO ENVOLVIDO;
GRANT SELECT	ON VIA	  						TO ENVOLVIDO;
GRANT SELECT	ON ENVOLVIMENTO	  				TO ENVOLVIDO;
GRANT SELECT	ON ENVOLVIDO	  				TO ENVOLVIDO;
GRANT SELECT	ON CNH	  						TO ENVOLVIDO;
GRANT SELECT	ON VEICULO_ENVOLVIDO_BOLETIM	TO ENVOLVIDO;
GRANT SELECT	ON VEICULO	  					TO ENVOLVIDO;

GRANT SELECT 	ON RANK_VIAS_ACIDENTES									TO ENVOLVIDO;
GRANT SELECT 	ON rank_tipo_acidente									TO ENVOLVIDO;
GRANT SELECT 	ON rank_faixa_horario									TO ENVOLVIDO;
GRANT SELECT 	ON rank_causa_acidente									TO ENVOLVIDO;
GRANT SELECT 	ON rank_classificacao_acidente							TO ENVOLVIDO;
GRANT SELECT 	ON total_condutores_por_sexo_envolvidos_em_acidente		TO ENVOLVIDO;
GRANT SELECT 	ON rank_acidentes_por_marca_veiculos					TO ENVOLVIDO;
GRANT SELECT 	ON rank_idade_cnhs										TO ENVOLVIDO;
GRANT SELECT 	ON rank_acidentes_por_bairro							TO ENVOLVIDO;
GRANT SELECT 	ON rank_por_estado_fisico								TO ENVOLVIDO;
GRANT SELECT 	ON rank_usava_cinto_capacete							TO ENVOLVIDO;

CREATE USER PESSOA1
LOGIN
PASSWORD '123'
IN ROLE ENVOLVIDO
