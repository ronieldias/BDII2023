--###################################################################################################################
--##########################################	TESTES	AGENTE  ###########################################################
--###################################################################################################################

-- ############ ATROPELAMENTO DE VACA NA FREI SERAFIM ###############################################################
--			       bo   lo  ti ca  cl 			descrição 					bairro       lati       longi
SELECT CADASTRA_BO(100, 200, 9, 3, 1, 'ATROPELAMENTO DE VACA NA FREI SERAFIM', 'CENTRO', -4.12412, -42.23461);
--					bo    vi          nome
SELECT CADASTRA_VIA(100, 300, 'AV. FREI SERAFIM');
-- 							   bo   env      cat         nome           cpf            nasc       sex       esc              endereço                                 ca    po    pt    val               
SELECT CADASTRA_ENVOLVIDO_NOVO(100, 1000, 'CONDUTOR', 'JOAO MARCOS', '00011122233', '1996-12-05', 'M', 'ENSINO MEDIO', '1231, RUA DAS BALSAS, MONTE ALTO, TERESINA', TRUE, TRUE, TRUE, TRUE);
SELECT CADASTRA_ENVOLVIDO_NOVO(100, 1001, 'PASSAGEIRO', 'ANDRÉ GARFO', '11122233344', '1997-12-15', 'M', 'SUPERIOR INCOMPLETO', '1231, RUA DAS FLORES, DIRCEU, TERESINA', TRUE, FALSE, FALSE, NULL);
SELECT CADASTRA_ENVOLVIDO_NOVO(100, 1002, 'AGENTE DE TRANSITO', 'ALBERTO COSTA', '33344455566', '1982-10-04', 'M', 'GRADUAÇÃO', '3256, RUA DA MULTA, PARQUE SUL, TERESINA', NULL, TRUE, NULL, NULL);
SELECT CADASTRA_ENVOLVIDO_NOVO(100, 1003, 'PEDESTRE', 'MARIANA RIOS', '44455566677', '2005-10-04', 'F', 'ENSINO FUNDAMENTAL', '3256, RUA DO AZAR, PARQUE SUL, TERESINA', NULL, FALSE, NULL, NULL);
--					    cpf              cnh              dt_pri       dt_val
SELECT CADASTRA_CNH('00011122233', '000111222333-44', '2019-06-01', '2024-06-01');
--						id     tipo    fab     mod     cor    ano     placa        chassi
SELECT cadastra_veiculo(400, 'CARRO', 'FIAT', 'UNO', 'PRETO', 2020, 'PIX-2020', 'CHA-0000000000');
--											bo    env  vei   prop
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(100, 1000, 400, TRUE);
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(100, 1001, 400, FALSE);

---novo
--			       bo   lo  ti ca  cl 			descrição 					bairro       lati       longi
SELECT CADASTRA_BO(110, 220, 4, 4, 3, 'ACIDENTE 20', 'CENTRO', -4.12412, -42.23461);
SELECT CADASTRA_VIA(110, 350, 'R. RUUI BARBOSA');
SELECT CADASTRA_VIA(110, 3000, 'AV. FREI SERAFIM');

SELECT RELACIONA_ENVOLVIDO_EXISTENTE(110, '00011122233', 'CONDUTOR', FALSE, FALSE, TRUE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(110, '33344455566', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);

SELECT * FROM BOLETIM NATURAL JOIN ENVOLVIMENTO NATURAL JOIN ENVOLVIDO
WHERE ID_BOLETIM=110

--SELECT * FROM EXIBIR_BO(110);
--SELECT * FROM BOLETIM NATURAL JOIN LOCALIZACAO NATURAL JOIN LOCALIZACAO_VIA NATURAL JOIN VIA

SELECT * FROM BOLETIM
SELECT * FROM LOCALIZACAO
SELECT * FROM VIA

select * from tipo_acidente
select * from causa_acidente
select * from classificacao_acidente

--############## ENGAVETAMENTO NO MERCADO DO PEIXE ######################################################################
--			       bo   lo  ti ca  cl 			descrição 					bairro       lati       longi
SELECT CADASTRA_BO(101, 201, 2, 4, 2, 'ENGAVETAMENTO NO MERCADO DO PEIXE', 'SAO JOAO', -4.12412, -42.23461);
--                  bo  vi        nome
SELECT CADASTRA_VIA(101, 301, 'AV. DOS EXPEDCIONARIOS');
SELECT CADASTRA_VIA(101, 302, 'AV. DOS IPÊS');
-- 							   bo   env      cat         nome           cpf            nasc       sex       esc              endereço                                 ca    po    pt    val               
SELECT CADASTRA_ENVOLVIDO_NOVO(101, 1004, 'CONDUTOR', 'LEONARDO DRUMMOND', '55566677788', '1992-10-05', 'M', 'GRADUAÇÃO', '1231, RUA DO SOM, MONTE PINNA, TERESINA', TRUE, TRUE, TRUE, TRUE);
SELECT CADASTRA_ENVOLVIDO_NOVO(101, 1005, 'CONDUTOR', 'THIAGO AMAZING', '66677788899', '1989-10-01', 'M', 'GRADUAÇÃO', '1231, RUA DE BAIXO, MONTE PINNA, TERESINA', TRUE, TRUE, FALSE, TRUE);
--									 bo		  cpf		 categoria    por   val   cap
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(101, '44455566677', 'CONDUTOR', FALSE, FALSE, TRUE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(101, '33344455566', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);
--					    cpf              cnh              dt_pri       dt_val
SELECT CADASTRA_CNH('55566677788', '555666777888-99', '2015-06-01', '2023-06-01');
SELECT CADASTRA_CNH('66677788899', '666777888999-00', '2013-06-01', '2025-06-01');
--						id     tipo    fab     mod     cor    ano     placa        chassi
SELECT cadastra_veiculo(401, 'CARRO', 'HONDA', 'CIVIC', 'AMARELO', 2022, 'ETA-2022', 'CHA-1111111111');
SELECT cadastra_veiculo(402, 'CARRO', 'VOLKSWAGEN', 'GOL', 'AMARELO', 2000, 'ETA-2000', 'CHA-2222222222');
SELECT cadastra_veiculo(403, 'CARRO', 'FIAT', 'PALIO', 'CINZA', 2019, 'ETA-2222', 'PLA-23212');
--											bo    env  vei   prop
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(101, 1004, 401, TRUE);
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(101, 1005, 402, TRUE);
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(101, 1003, 403, FALSE);




--############# CHOQUE EM CRUZAMENTO ###################################################################################
--			       bo   lo  ti ca  cl 			descrição 		bairro     lati       longi
SELECT CADASTRA_BO(102, 202, 9, 3, 1, 'CHOQUE EM CRUZAMENTO', 'CENTRO', -4.12415, -42.14623);
--                  bo  vi        nome
SELECT CADASTRA_VIA(102, 300, 'AV. FREI SERAFIM'); --VIA EXISTENTE
SELECT CADASTRA_VIA(102, 303, 'AV. MIGEL ROSA');
-- 							   bo   env      cat         nome           cpf            nasc       sex       esc              endereço                                    ca    po    pt    val               
SELECT CADASTRA_ENVOLVIDO_NOVO(102, 1006, 'CONDUTOR', 'SALVADOR SOBRAL', '77788899900', '1991-10-05', 'M', 'GRADUAÇÃO', '1231, RUA DO CONTRALTO, NOVA LISBOA, TERESINA', TRUE, TRUE, TRUE, FALSE);
SELECT CADASTRA_ENVOLVIDO_NOVO(102, 1007, 'CONDUTOR', 'TIAGO NACARATO', '88899900011', '1992-10-01', 'M', 'GRADUAÇÃO', '1231, RUA DO TENOR, NOVA LISBOA, TERESINA', TRUE, TRUE, TRUE, TRUE);
--									 bo		  cpf		 categoria    por   val   cap
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(102, '33344455566', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);
--					    cpf              cnh              dt_pri       dt_val
SELECT CADASTRA_CNH('77788899900', '777888999000-11', '2015-06-01', '2023-06-01');
SELECT CADASTRA_CNH('88899900011', '888999000111-22', '2013-06-01', '2025-06-01');
--						id     tipo    fab     mod     cor    ano     placa        chassi
SELECT cadastra_veiculo(404, 'CARRO', 'RENAULT', 'SANDERO', 'VINHO', 2022, 'ETA-0000', 'CHA-3333333333');
SELECT cadastra_veiculo(405, 'CARRO', 'VOLKSWAGEN', 'GOL', 'AMARELO', 2000, 'ETA-0001', 'CHA-4444444444');
--											bo    env  vei   prop
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(102, 1006, 404, TRUE);
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(102, 1007, 405, TRUE);

--############ COLISÃO MOTOCICLISTA X POSTE ##############################################################################
--			       bo   lo  ti ca  cl 			descrição 		bairro     lati       longi
SELECT CADASTRA_BO(103, 203, 5, 7, 3, 'COLISÃO MOTOCICLISTA X POSTE', 'NOVO URUGUAI', -4.12415, -42.14623);
--                  bo  vi        nome
SELECT CADASTRA_VIA(103, 304, 'BR-343');
-- 							   bo   env      cat         nome           cpf            nasc       sex       esc              endereço                                    ca    po    pt    val               
SELECT CADASTRA_ENVOLVIDO_NOVO(103, 1008, 'CONDUTOR', 'MARKOS KLEINE', '99900011122', '1970-10-05', 'M', 'GRADUAÇÃO', '1231, RUA DO SOLO, JARDIM DAS PERDIZES, SAO PAULO', TRUE, TRUE, TRUE, FALSE);
SELECT CADASTRA_ENVOLVIDO_NOVO(103, 1009, 'AGENTE DE TRÂNSITO', 'MURILO COUTO', '00022244466', '1990-10-01', 'M', 'GRADUAÇÃO', '1231, RUA DA MULTA, HAVAIANAS, BELÉM', NULL, TRUE, NULL, NULL);
--					    cpf              cnh              dt_pri       dt_val
SELECT CADASTRA_CNH('99900011122', '999000111222-33', '2002-06-01', '2023-12-31');
--						id      tipo          fab     mod        cor    ano     placa        chassi
SELECT cadastra_veiculo(406, 'MOTOCICLETA', 'HONDA', 'CB-300', 'VINHO', 2018, 'PLA-0000', 'CHA-5555555555');
--											bo    env  vei   prop
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(103, 1008, 406, TRUE);



--############ CAPOTAMENTO DE FUSCA ##############################################################################
SELECT CADASTRA_BO(104, 204, 10, 8, 1, 'CAPOTAMENTO DE FUSCA', 'CENTRO', -4.12415, -42.14623);
--                  bo  vi        nome
SELECT CADASTRA_VIA(104, 305, 'AV. MARANHÃO');
--									 bo		  cpf		 categoria    por   val   cap
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(104, '00011122233', 'CONDUTOR', TRUE, TRUE, TRUE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(104, '11122233344', 'PARTE LESADA', NULL, NULL, NULL);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(104, '00022244466', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);
--						id      tipo          fab     mod        cor    ano     placa        chassi
SELECT cadastra_veiculo(407, 'CARRO', 'VOLKSWAGEN', 'FUSCA', 'BRANCO', 1989, 'PLA-1111', 'CHA-6666666666');
--											bo    env  vei   prop
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(104, 1000, 407, FALSE);
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(104, 1001, 407, TRUE);



-- ########## ACIDENTE A ####################################################################################
SELECT CADASTRA_BO(105, 205, 8, 10, 2, 'ACIDENTE A', 'CENTRO', -4.12415, -42.14623);
SELECT CADASTRA_VIA(105, 320, 'R. BARROSO');
--									 bo		  cpf		 categoria    por   val   cap
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(105, '55566677788', 'CONDUTOR', TRUE, TRUE, TRUE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(105, '44455566677', 'PEDESTRE', NULL, NULL, NULL);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(105, '33344455566', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);
--
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(105, 1004, 406, TRUE);


-- ########## ACIDENTE B ####################################################################################
SELECT CADASTRA_BO(106, 206, 8, 10, 2, 'ACIDENTE B', 'CENTRO', -4.12415, -42.14623);
SELECT CADASTRA_VIA(106, 306, 'R. PAISANDU');
--									 bo		  cpf		 categoria    por   val   cap
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(106, '44455566677', 'CONDUTOR', TRUE, TRUE, TRUE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(106, '55566677788', 'PEDESTRE', NULL, NULL, NULL);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(106, '33344455566', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);
--
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(106, 1003, 405, TRUE);


-- ########## ACIDENTE C ####################################################################################
SELECT CADASTRA_BO(107, 207, 2, 2, 2, 'ACIDENTE C', 'ININGA', -4.13542, -42.14623);
SELECT CADASTRA_VIA(107, 307, 'AV. UNIVERSITÁRIA');
--									 bo		  cpf		 categoria    por   val   cap
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(107, '44455566677', 'CONDUTOR', TRUE, TRUE, TRUE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(107, '66677788899', 'CONDUTOR', TRUE, TRUE, TRUE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(107, '33344455566', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);
--
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(107, 1003, 405, TRUE);
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(107, 1005, 404, TRUE);

-- ########## ACIDENTE D ####################################################################################
SELECT CADASTRA_BO(108, 208, 2, 2, 2, 'ACIDENTE D', 'ININGA', -4.13542, -42.14623);
SELECT CADASTRA_VIA(108, 308, 'AV. NOSSA SENHORA DE FÁTIMA');
--									 bo		  cpf		 categoria    por   val   cap
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(108, '44455566677', 'CONDUTOR', TRUE, TRUE, FALSE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(108, '66677788899', 'CONDUTOR', TRUE, TRUE, FALSE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(108, '33344455566', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);
--
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(108, 1003, 405, TRUE);
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(108, 1005, 404, TRUE);


-- ########## ACIDENTE E ####################################################################################
SELECT CADASTRA_BO(109, 209, 8, 10, 2, 'ACIDENTE E', 'AV. DUQUE DE CAXIAS', -4.12415, -42.14623);
SELECT CADASTRA_VIA(109, 306, 'R. PAISANDU');
--									 bo		  cpf		 categoria    por   val   cap
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(109, '88899900011', 'CONDUTOR', TRUE, TRUE, TRUE);
SELECT RELACIONA_ENVOLVIDO_EXISTENTE(109, '33344455566', 'AGENTE DE TRÂNSITO', NULL, NULL, NULL);
--
SELECT RELACIONAR_VEICULO_ENVOLVIDO_BOLETIM(109, 1007, 402, TRUE);


select * from boletim

--PERMITIDO
SELECT FINALIZA_BO(109); --update
SELECT DESVINCULA_VIA_BO(306, 109); --delete
SELECT DELETA_BO(109); --delete
SELECT DESVINCULA_ENVOLVIDO_BO('88899900011', 109); --delete
SELECT DESVINCULA_VEICULO_BO('ETA-2000', 109); --delete
SELECT atualiza_dados_envolvido ('88899900011', 'ESCOLARIDADE', 'PÓS GRADUAÇÃO'); --update
SELECT ATUALIZA_VALIDADE_CNH('000111222333-44', '2026-12-31'); --update
SELECT ATUALIZA_COR_VEICULO('ETA-2000', 'VERDE'); --update
SELECT ATUALIZAR_NOME_VIA(301, 'AV. DOS EXPEDICIONÁRIOS'); --update

--PERMITIDO
SELECT * FROM EXIBIR_BOS_ENVOLVIDO('44455566677');
SELECT * FROM EXIBIR_BOS_VEICULO('ETA-2000');
SELECT * FROM EXIBIR_BOS_VIA('AV. FREI SERAFIM');
SELECT * FROM EXIBIR_BO(109);

--PERMITIDO
SELECT * FROM RANK_VIAS_ACIDENTES
SELECT * FROM rank_tipo_acidente;
SELECT * FROM rank_faixa_horario;
SELECT * FROM rank_causa_acidente;
SELECT * FROM rank_classificacao_acidente;
SELECT * FROM total_condutores_por_sexo_envolvidos_em_acidente;
SELECT * FROM rank_acidentes_por_marca_veiculos;
SELECT * FROM rank_idade_cnhs;
SELECT * FROM rank_acidentes_por_bairro;
SELECT * FROM rank_por_estado_fisico
SELECT * FROM rank_usava_cinto_capacete;


DELETE FROM LOCALIZACAO WHERE ID_LOCAL=208
SELECT * FROM LOCALIZACAO_VIA

SELECT * FROM BOLETIM NATURAL JOIN LOCALIZACAO
DELETE FROM VEICULO WHERE ID_VEICULO=400

SELECT * FROM LOCALIZACAO
SELECT * FROM BOLETIM
SELECT * FROM VIA
SELECT * FROM ENVOLVIDO
SELECT * FROM VEICULO
SELECT * FROM TIPO_ACIDENTE
SELECT * FROM CAUSA_ACIDENTE
SELECT * FROM CLASSIFICACAO_ACIDENTE
SELECT * FROM CNH
SELECT * FROM BOLETIM natural join ENVOLVIMENTO