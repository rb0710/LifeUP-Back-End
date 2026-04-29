-- ============================================================
-- LifeUp Suplementos — Script completo do banco de dados
-- Gerado em: 2026-04-22
-- ============================================================

CREATE DATABASE IF NOT EXISTS lifeup
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE lifeup;

-- ============================================================
-- TABELA: clientes
-- ============================================================
CREATE TABLE IF NOT EXISTS clientes (
  id_clientes      INT AUTO_INCREMENT PRIMARY KEY,
  nome             VARCHAR(100)  NOT NULL,
  endereco         VARCHAR(200)  DEFAULT '',
  cpf              VARCHAR(11)   NOT NULL UNIQUE,
  telefone         VARCHAR(20)   DEFAULT '',
  data_nascimento  DATE          NOT NULL,
  email            VARCHAR(100)  NOT NULL UNIQUE,
  senha            VARCHAR(255)  NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABELA: categoria
-- ============================================================
CREATE TABLE IF NOT EXISTS categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nome_categoria VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABELA: produtos
-- ============================================================
CREATE TABLE IF NOT EXISTS produtos (
  id_produtos       INT AUTO_INCREMENT PRIMARY KEY,
  nome_produto      VARCHAR(100)   NOT NULL,
  descricao_produto TEXT           NOT NULL,
  preco             DECIMAL(10,2)  NOT NULL,
  marca             VARCHAR(100)   DEFAULT 'LifeUp',
  estoque           INT            NOT NULL DEFAULT 0,
  id_categoria      INT            DEFAULT NULL,
  id_fornecedor     INT            DEFAULT NULL,
  FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABELA: pedidos
-- ============================================================
CREATE TABLE IF NOT EXISTS pedidos (
  id_pedidos   INT AUTO_INCREMENT PRIMARY KEY,
  id_clientes  INT            NOT NULL,
  valor_total  DECIMAL(10,2)  NOT NULL DEFAULT 0,
  data_pedido  TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_clientes) REFERENCES clientes(id_clientes)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABELA: itens_pedido
-- ============================================================
CREATE TABLE IF NOT EXISTS itens_pedido (
  id_itens        INT AUTO_INCREMENT PRIMARY KEY,
  id_pedidos      INT            NOT NULL,
  id_produtos     INT            NOT NULL,
  quantidade      INT            NOT NULL DEFAULT 1,
  preco_unitario  DECIMAL(10,2)  NOT NULL,
  FOREIGN KEY (id_pedidos)  REFERENCES pedidos(id_pedidos),
  FOREIGN KEY (id_produtos) REFERENCES produtos(id_produtos)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- TABELA: avaliacoes
-- ============================================================
CREATE TABLE IF NOT EXISTS avaliacoes (
  id_avaliacoes  INT AUTO_INCREMENT PRIMARY KEY,
  id_produtos    INT  NOT NULL,
  id_clientes    INT  NOT NULL,
  nota           TINYINT NOT NULL CHECK (nota BETWEEN 1 AND 5),
  comentario     TEXT    DEFAULT NULL,
  data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_produtos) REFERENCES produtos(id_produtos),
  FOREIGN KEY (id_clientes) REFERENCES clientes(id_clientes)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- DADOS: categoria
-- ============================================================
INSERT INTO categoria (id_categoria, nome_categoria) VALUES
(1, 'Proteína'),
(2, 'Pré-Treino'),
(3, 'Snacks'),
(4, 'Roupas'),
(5, 'Vitaminas')
ON DUPLICATE KEY UPDATE
  nome_categoria = VALUES(nome_categoria);

-- ============================================================
-- DADOS: produtos (48 produtos)
-- ============================================================
INSERT INTO produtos (id_produtos, nome_produto, descricao_produto, preco, marca, estoque, id_categoria) VALUES
-- Whey
(1,  'Whey Protein Concentrado',    'Whey concentrado com 24g de proteína por dose. Ótimo custo-benefício para ganho de massa muscular e recuperação pós-treino.',                          129.90, 'LifeUp', 50, 1),
(2,  'Whey Protein Isolado',        'Whey isolado de alta pureza, baixo teor de gordura e lactose. Ideal para intolerantes e atletas de alto rendimento.',                                  159.90, 'LifeUp', 50, 1),
(19, 'Whey Protein 3W',             'Blend triplo de whey concentrado, isolado e hidrolisado. Máxima absorção e recuperação muscular. 900g.',                                               189.90, 'LifeUp', 40, 1),
(20, 'Whey Protein Zero Lactose',   'Whey sem lactose para intolerantes. 25g de proteína por dose, sabor suave e fácil digestão. 900g.',                                                   149.90, 'LifeUp', 35, 1),
-- Creatina
(3,  'Creatina Monohidratada',      'Aumento de força e desempenho nos treinos.',                                                                                                           79.90,  'LifeUp', 30, 1),
(21, 'Creatina Micronizada',        'Creatina micronizada de alta solubilidade. Maior absorção e desempenho nos treinos de força. 300g.',                                                   89.90,  'LifeUp', 30, 1),
-- Pré-Treino
(4,  'Pré-Treino Pepay Perips',     'Energia máxima e foco para treinos intensos.',                                                                                                         99.90,  'LifeUp', 20, 2),
(22, 'Pré-Treino Explosive',        'Pré-treino com cafeína, beta-alanina e citrulina. Energia explosiva e pump intenso. 300g.',                                                           109.90, 'LifeUp', 25, 2),
(23, 'Pré-Treino Black',            'Fórmula avançada com nootrópicos para foco extremo e resistência prolongada nos treinos. 300g.',                                                      119.90, 'LifeUp', 20, 2),
(24, 'Pré-Treino Pump',             'Pré-treino sem estimulantes focado em pump muscular e vasodilatação. Ideal para treinos noturnos. 300g.',                                              99.90,  'LifeUp', 22, 2),
(25, 'Cafeína 200mg',               'Cafeína anidra pura para foco, energia e queima de gordura. 60 cápsulas de 200mg.',                                                                   29.90,  'LifeUp', 70, 2),
(26, 'Cafeína + L-Teanina',         'Combo cafeína e L-teanina para energia sem ansiedade. Foco limpo e sustentado. 60 cápsulas.',                                                         39.90,  'LifeUp', 55, 2),
(27, 'Termogênico LifeUp',          'Termogênico com cafeína, pimenta e extrato de chá verde. Acelera o metabolismo e a queima de gordura.',                                               69.90,  'LifeUp', 45, 2),
-- Outros suplementos
(5,  'BCAA LifeUp',                 'Aminoácidos de cadeia ramificada para recuperação.',                                                                                                   59.90,  'LifeUp', 40, 1),
(6,  'Barrinha de Proteína',        'Lanche saudável e proteico para qualquer hora.',                                                                                                        9.90,  'LifeUp',100, 3),
(29, 'Hipercalórico Mass',          'Hipercalórico com 1000kcal por dose, carboidratos complexos e proteínas para ganho de massa. 3kg.',                                                   139.90, 'LifeUp', 30, 1),
-- Vitaminas
(13, 'Vitamina C 1000mg',           'Vitamina C de alta dosagem para imunidade, antioxidante e recuperação muscular. 60 cápsulas.',                                                         39.90,  'LifeUp', 60, 5),
(14, 'Vitamina D3 + K2',            'Combo Vitamina D3 e K2 para saúde óssea, imunidade e absorção de cálcio. 60 cápsulas.',                                                               49.90,  'LifeUp', 50, 5),
(15, 'Ômega 3 Fish Oil',            'Óleo de peixe rico em EPA e DHA. Suporte cardiovascular, anti-inflamatório e saúde cerebral. 120 cápsulas.',                                          54.90,  'LifeUp', 45, 5),
(16, 'Multivitamínico',             'Complexo completo com 23 vitaminas e minerais essenciais para o dia a dia do atleta. 60 comprimidos.',                                                 44.90,  'LifeUp', 55, 5),
(17, 'Magnésio Quelato',            'Magnésio de alta absorção para relaxamento muscular, qualidade do sono e redução de câimbras.',                                                        34.90,  'LifeUp', 40, 5),
(18, 'Vitamina B12',                'Vitamina B12 para energia, saúde neurológica e produção de glóbulos vermelhos. 60 cápsulas.',                                                          29.90,  'LifeUp', 65, 5),
(28, 'Multivitamínico Sport',       'Multivitamínico específico para atletas com doses elevadas de vitaminas do complexo B, C, D e zinco.',                                                 54.90,  'LifeUp', 50, 5),
(30, 'Clorofila Líquida',           'Clorofila líquida para desintoxicação, energia e saúde intestinal. 500ml, 60 doses.',                                                                  44.90,  'LifeUp', 40, 5),
(31, 'Coenzima Q10',                'CoQ10 para saúde cardiovascular, energia celular e ação antioxidante. 60 cápsulas de 100mg.',                                                          59.90,  'LifeUp', 35, 5),
-- Roupas
(7,  'Camiseta de Treino Azul',     'Camiseta dry-fit de alta performance para treinos intensos. Tecido respirável e leve.',                                                                79.90,  'LifeUp', 30, 4),
(8,  'Camiseta de Treino Preta',    'Camiseta dry-fit preta com corte moderno. Ideal para musculação e corrida.',                                                                           79.90,  'LifeUp', 30, 4),
(9,  'Calça de Treino',             'Calça legging de compressão para treinos de alta intensidade. Tecido elástico e confortável.',                                                        119.90,  'LifeUp', 25, 4),
(10, 'Conjunto de Treino',          'Conjunto top e legging combinando. Perfeito para academia e atividades ao ar livre.',                                                                 189.90,  'LifeUp', 20, 4),
(11, 'Regata de Treino',            'Regata dry-fit com ampla mobilidade para treinos de força e cardio.',                                                                                  59.90,  'LifeUp', 35, 4),
(12, 'Short de Treino',             'Short esportivo com bolso lateral e elástico ajustável. Conforto total nos treinos.',                                                                  89.90,  'LifeUp', 28, 4),
(32, 'Blusa de Treino Feminina',    'Blusa dry-fit feminina com proteção UV. Tecido leve e respirável para treinos ao ar livre.',                                                           89.90,  'LifeUp', 28, 4),
(33, 'Blusa de Frio Moletom',       'Moletom esportivo com capuz para pós-treino. Tecido macio e aquecido para dias frios.',                                                               129.90,  'LifeUp', 22, 4),
(34, 'Blusa de Frio Zip',           'Blusa de frio com zíper frontal para fácil remoção. Ideal para aquecimento antes do treino.',                                                         119.90,  'LifeUp', 20, 4),
(35, 'Calça de Treino Slim',        'Calça legging slim com cós alto e bolso lateral. Compressão moderada para treinos funcionais.',                                                       109.90,  'LifeUp', 25, 4),
(36, 'Calça de Treino Cargo',       'Calça cargo esportiva com bolsos laterais. Conforto e estilo para treinos e uso casual.',                                                             129.90,  'LifeUp', 20, 4),
(37, 'Calça de Treino Jogger',      'Calça jogger com punho na barra e elástico ajustável. Perfeita para corrida e academia.',                                                             119.90,  'LifeUp', 22, 4),
(38, 'Camiseta Cinza Mescla',       'Camiseta dry-fit cinza mescla com corte regular. Versátil para treino e uso casual.',                                                                  79.90,  'LifeUp', 30, 4),
(39, 'Camiseta Cinza Slim',         'Camiseta dry-fit cinza com corte slim fit. Valoriza a silhueta durante os treinos.',                                                                   84.90,  'LifeUp', 28, 4),
(40, 'Camiseta Colorida',           'Camiseta dry-fit colorida com estampa exclusiva LifeUp. Tecido leve e resistente.',                                                                    89.90,  'LifeUp', 25, 4),
(41, 'Conjunto de Treino Premium',  'Conjunto top e legging premium com tecido de alta compressão. Suporte máximo para treinos intensos.',                                                 219.90,  'LifeUp', 18, 4),
(42, 'Conjunto de Treino Sport',    'Conjunto camiseta e bermuda esportiva. Combinação perfeita para treinos e atividades ao ar livre.',                                                   169.90,  'LifeUp', 20, 4),
(43, 'Regata Dry-Fit',              'Regata dry-fit com tecnologia de absorção de suor. Leveza máxima para treinos de alta intensidade.',                                                   64.90,  'LifeUp', 35, 4),
(44, 'Regata Muscle',               'Regata muscle com abertura lateral ampla. Design atlético para musculação e crossfit.',                                                                59.90,  'LifeUp', 32, 4),
(45, 'Regata Compressão',           'Regata de compressão para suporte muscular e redução de vibração durante corridas.',                                                                   74.90,  'LifeUp', 28, 4),
(46, 'Regata Performance',          'Regata com tecido de alta performance e proteção UV50+. Ideal para treinos ao ar livre.',                                                              69.90,  'LifeUp', 30, 4),
(47, 'Short Preto Treino',          'Short preto esportivo com forro interno e bolso traseiro. Conforto e mobilidade total.',                                                               89.90,  'LifeUp', 28, 4),
(48, 'Short Preto Slim',            'Short slim fit preto com elástico ajustável. Design moderno para academia e corrida.',                                                                 94.90,  'LifeUp', 25, 4)
ON DUPLICATE KEY UPDATE
  nome_produto      = VALUES(nome_produto),
  descricao_produto = VALUES(descricao_produto),
  preco             = VALUES(preco),
  estoque           = VALUES(estoque),
  id_categoria      = VALUES(id_categoria);
