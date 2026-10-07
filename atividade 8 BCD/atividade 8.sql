DROP DATABASE IF EXISTS agroindustria_db;

-- Cria o banco de dados.
CREATE DATABASE agroindustria_db;

-- Define o uso da base de dados.
USE agroindustria_db;

-- Cria a tabela de setores.
CREATE TABLE setor 
(
id INT PRIMARY KEY not null,
nome VARCHAR(40),
descricao TEXT
);

-- Cria a tabela de medidas do processo produtivo para cada setor.
CREATE TABLE medidas 
(
id INT PRIMARY KEY not null,
id_setor INT,
data_hora DATETIME,
variavel VARCHAR(20),
valor DECIMAL(10,2)
);

-- Define a chave estrangeira.
ALTER TABLE medidas
ADD CONSTRAINT fk_medidas_setor 
FOREIGN KEY (id_setor) REFERENCES setor(id);

-- Cadastro dos setores.
INSERT INTO setor (id, nome, descricao) 
VALUES
(1, 'Moagem', 'Responsável pela extração do caldo da cana-de-açúcar.'),
(2, 'Clarificação', 'Remove impurezas do caldo e ajusta pH.'),
(3, 'Evaporação', 'Concentra o caldo por remoção de água.'),
(4, 'Fermentação', 'Converte açúcares em etanol através de leveduras.'),
(5, 'Destilação', 'Separa o etanol produzido na fermentação.'),
(6, 'Caldeira', 'Gera vapor para os processos industriais.');

-- Registro das medidas coletadas.
INSERT INTO medidas (id, id_setor, data_hora, variavel, valor)
VALUES
(1, 1, '2025-10-09 08:00:00', 'VAZÃO', '210.50'),
(2, 1, '2025-10-09 08:10:00', 'TEMP', '32.80'),
(3, 2, '2025-10-09 08:20:00', 'PH', '6.45'),
(4, 2, '2025-10-09 08:30:00', 'BRIX', '13.20'),
(5, 3, '2025-10-09 08:40:00', 'TEMP', '78.50'),
(6, 3, '2025-10-09 08:50:00', 'BRIX', '36.70'),
(7, 4, '2025-10-09 09:00:00', 'PH', '4.60'),
(8, 4, '2025-10-09 09:10:00', 'TEMP', '33.90'),
(9, 5, '2025-10-09 09:20:00', 'ETOH', '92.10'),
(10, 6, '2025-10-09 09:30:00', 'PRESSÃO', '17.80');

SELECT * FROM setor;
SELECT * FROM medidas;

-- 1. Todas as medições da mais recente para a mais antiga
SELECT id, variavel, valor 
FROM medidas 
ORDER BY data_hora DESC;

-- 2. Medições de Temperatura (TEMP) do maior valor para o menor
SELECT * 
FROM medidas 
WHERE variavel = 'TEMP' 
ORDER BY valor DESC;

-- 3. Medições de BRIX entre 30 e 80% do menor para o maior valor
SELECT * 
FROM medidas 
WHERE variavel = 'BRIX' AND valor BETWEEN 30.00 AND 80.00 
ORDER BY valor ASC; 

-- 4. Quantidade de medidas de cada variável (Mais medidas para menos)
SELECT variavel, COUNT(id) AS quantidade_medidas
FROM medidas 
GROUP BY variavel 
ORDER BY quantidade_medidas DESC;

-- 5. Valor médio de cada variável do maior para o menor
SELECT variavel, AVG(valor) AS valor_medio
FROM medidas 
GROUP BY variavel 
ORDER BY valor_medio DESC;

-- 6. Menor (Mínimo) e Maior (Máximo) valor de cada variável de A a Z
SELECT variavel, MIN(valor) AS menor_valor, MAX(valor) AS maior_valor
FROM medidas 
GROUP BY variavel 
ORDER BY variavel ASC;

-- 7. Média de Temperatura (TEMP) por Setor (Maior média para menor)
SELECT s.nome AS setor, AVG(m.valor) AS media_temperatura
FROM medidas m
INNER JOIN setor s ON m.id_setor = s.id -- Junta a tabela de medidas com setor
WHERE m.variavel = 'TEMP'
GROUP BY s.nome
ORDER BY media_temperatura DESC;

-- 8. Maior e menor valor de ETOH para cada setor de A a Z
SELECT s.nome AS setor, MIN(m.valor) AS menor_etoh, MAX(m.valor) AS maior_etoh
FROM medidas m
INNER JOIN setor s ON m.id_setor = s.id
WHERE m.variavel = 'ETOH'
GROUP BY s.nome
ORDER BY s.nome ASC;

-- 9. Total de medições feitas em cada setor (Do setor com mais para o com menos)
SELECT s.nome AS setor, COUNT(m.id) AS total_medicoes
FROM medidas m
INNER JOIN setor s ON m.id_setor = s.id
GROUP BY s.nome
ORDER BY total_medicoes DESC;