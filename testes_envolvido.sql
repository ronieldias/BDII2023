-- NAO PERMITIDO
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
SELECT * FROM EXIBIR_BO(107);

-- PERMITIDO
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
