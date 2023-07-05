DELETE FROM VEICULO WHERE ID_VEICULO=400

SEL

--###################################################################################################################
--############################################	   ESTATISTICAS	    #################################################
--###################################################################################################################

CREATE VIEW rank_vias_acidentes AS
	(
		SELECT v.nome_via AS nome_via, COUNT(*) AS quantidade_acidentes
			FROM boletim b 
				INNER JOIN localizacao_via l ON l.id_local = b.id_local
				INNER JOIN via v ON v.id_via = l.id_via
		GROUP BY v.nome_via
		ORDER BY 2 DESC
		LIMIT 10
	);

SELECT * FROM RANK_VIAS_ACIDENTES
--SELECT * FROM boletim;

CREATE VIEW rank_tipo_acidente AS
	(
		SELECT ta.nome_tipo AS nome_tipo, COUNT(*) AS quantidade_acidentes
			FROM boletim b 
				INNER JOIN tipo_acidente ta ON ta.id_tipo = b.id_tipo
		GROUP BY ta.nome_tipo
		ORDER BY 2 DESC
		LIMIT 10
	);
	
SELECT * FROM rank_tipo_acidente;

CREATE VIEW rank_faixa_horario AS
	(
	SELECT 
		CASE extract(hour from data_hora)
			WHEN 00 THEN 'Entre 00 e 01 horas'
			WHEN 01 THEN 'Entre 01 e 02 horas'
			WHEN 02 THEN 'Entre 01 e 02 horas'
			WHEN 03 THEN 'Entre 03 e 04 horas'
			WHEN 04 THEN 'Entre 04 e 05 horas'
			WHEN 05 THEN 'Entre 05 e 06 horas'
			WHEN 06 THEN 'Entre 06 e 07 horas'
			WHEN 07 THEN 'Entre 07 e 08 horas'
			WHEN 08 THEN 'Entre 08 e 09 horas'
			WHEN 09 THEN 'Entre 09 e 10 horas'
			WHEN 10 THEN 'Entre 10 e 11 horas'
			WHEN 11 THEN 'Entre 11 e 12 horas'
			WHEN 12 THEN 'Entre 12 e 13 horas'
			WHEN 13 THEN 'Entre 13 e 14 horas'
			WHEN 14 THEN 'Entre 14 e 15 horas'
			WHEN 15 THEN 'Entre 15 e 16 horas'
			WHEN 16 THEN 'Entre 16 e 17 horas'
			WHEN 17 THEN 'Entre 17 e 18 horas'
			WHEN 18 THEN 'Entre 18 e 19 horas'
			WHEN 19 THEN 'Entre 19 e 20 horas'
			WHEN 20 THEN 'Entre 20 e 21 horas'
			WHEN 21 THEN 'Entre 21 e 22 horas'
			WHEN 22 THEN 'Entre 22 e 23 horas'
			WHEN 23 THEN 'Entre 23 e 00 horas'
		END faixa_horario,
		COUNT(*) quantidade_acidentes
		FROM boletim
		GROUP BY EXTRACT(HOUR FROM data_hora)
	);
	
SELECT * FROM rank_faixa_horario;


--##########	############	#############

CREATE OR REPLACE VIEW rank_causa_acidente AS
(
	SELECT a.nome_causa, COUNT(*) AS quantidade_acidentes
	FROM boletim b
	INNER JOIN causa_acidente a
		ON a.id_causa = b.id_causa
	GROUP BY a.nome_causa
	ORDER BY quantidade_acidentes DESC
);

SELECT * FROM rank_causa_acidente;

CREATE OR REPLACE VIEW rank_classificacao_acidente AS
(
	SELECT a.nome_class, COUNT(*) AS quantidade_acidentes
	FROM boletim b
	INNER JOIN classificacao_acidente a
		ON a.id_class = b.id_class
	GROUP BY a.nome_class
	ORDER BY quantidade_acidentes DESC
);

SELECT * FROM rank_classificacao_acidente;

CREATE OR REPLACE VIEW total_condutores_por_sexo_envolvidos_em_acidente AS
(
	SELECT 
		CASE ev.sexo
		WHEN 'M' THEN 'Homens'
		WHEN 'F' THEN 'Mulheres'
		END sexo, 
		COUNT(*) as quantidade
	FROM envolvimento e
		INNER JOIN envolvido ev
		ON e.id_envolvido = ev.id_envolvido
	WHERE e.categoria = 'CONDUTOR'
	GROUP BY ev.sexo
);

SELECT * FROM total_condutores_por_sexo_envolvidos_em_acidente;


Ranquear marca do veículo em ocorrências
/*
CREATE OR REPLACE VIEW rank_acidentes_por_marca_veiculos AS
(
	SELECT COUNT(*), v.fabricante 
		FROM veiculo_envolvido_boletim veb
			INNER JOIN veiculo v
			ON v.id_veiculo = veb.id_veiculo
	GROUP BY v.fabricante
        ORDER BY 1 DESC
);
*/

CREATE OR REPLACE VIEW rank_acidentes_por_marca_veiculos AS(
	SELECT COUNT(*), T1.FABRICANTE
	FROM (SELECT DISTINCT ID_VEICULO, ID_BOLETIM, FABRICANTE FROM VEICULO NATURAL JOIN VEICULO_ENVOLVIDO_BOLETIM) T1
	GROUP BY T1.FABRICANTE
	ORDER BY 1 DESC
);

SELECT * FROM rank_acidentes_por_marca_veiculos;

/*
CREATE OR REPLACE VIEW rank_idade_cnhs AS
(
	SELECT (DATE_PART('year', NOW()::date)) - (DATE_PART('year', C.DT_PRIMEIRA_CNH::date)) AS idade, COUNT(*) AS quantidade
		FROM CNH C NATURAL JOIN ENVOLVIDO E1 NATURAL JOIN ENVOLVIMENTO E2
		--INNER JOIN envolvido e
		--ON e.id_envolvido = c.id_envolvido
	GROUP BY 1
	ORDER BY 2 DESC
);
*/

CREATE OR REPLACE VIEW rank_idade_cnhs AS(
	SELECT (DATE_PART('year', NOW()::date)) - (DATE_PART('year', T1.DT_PRIMEIRA_CNH::date)) AS idade, COUNT(*) AS quantidade
	FROM (SELECT DISTINCT ID_CNH, DT_PRIMEIRA_CNH, ID_ENVOLVIDO FROM CNH NATURAL JOIN ENVOLVIDO NATURAL JOIN ENVOLVIMENTO) T1
	GROUP BY 1
	ORDER BY 1 DESC
);

SELECT * FROM rank_idade_cnhs;



CREATE VIEW rank_acidentes_por_bairro AS
(
	SELECT l.bairro, COUNT(*) AS quantidade
		FROM boletim b
		INNER JOIN localizacao l
			ON b.id_local = l.id_local
	GROUP BY 1
	ORDER BY 2 DESC
);

SELECT * FROM rank_acidentes_por_bairro;

CREATE VIEW rank_por_estado_fisico AS
(
	SELECT ca.nome_class estado_fisico, COUNT(*) quantidade
		FROM BOLETIM B 
			INNER JOIN classificacao_acidente ca
			ON ca.id_class = b.id_class
	GROUP BY 1
	ORDER BY 2 DESC
);	

SELECT * FROM rank_por_estado_fisico


CREATE VIEW rank_usava_cinto_capacete AS
(
	SELECT 
		CASE e.capacete_cinto
		WHEN false THEN 'Condutores sem cinto/capacete'
		WHEN true THEN 'Condutores com cinto/capacate'
		END as capacete_cinto,
		COUNT(*) as quantidade
	FROM envolvimento e
		INNER JOIN envolvido ev
		ON e.id_envolvido = ev.id_envolvido
	WHERE e.categoria = 'CONDUTOR'
	GROUP BY e.capacete_cinto
	ORDER BY 2 DESC
);

SELECT * FROM rank_usava_cinto_capacete;
