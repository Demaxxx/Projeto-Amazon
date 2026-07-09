-- 1. CLIENTE 
CREATE TABLE cliente (
    id_cliente        SERIAL PRIMARY KEY,
    nome_cliente      VARCHAR(100) NOT NULL,
    cpf               VARCHAR(11) UNIQUE NOT NULL,
    email             VARCHAR(100) UNIQUE NOT NULL,
    data_nascimento   DATE NOT NULL
);

-- 2. ENDEREÇO 
CREATE TABLE cliente_endereco (
    id_endereco       SERIAL PRIMARY KEY,
    id_cliente        INT NOT NULL,
    cep               VARCHAR(9) NOT NULL,
    rua               VARCHAR(50) NOT NULL,
    num               INT NOT NULL,
    complemento       VARCHAR(100), 
    cidade            VARCHAR(50) NOT NULL,
    estado            VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

-- 3. VENDEDOR 
CREATE TABLE vendedor (
    id_vendedor       SERIAL PRIMARY KEY,
    id_setor          INT NOT NULL,
    setor             VARCHAR(100) NOT NULL,
    nome              VARCHAR(100) NOT NULL,
    email             VARCHAR(100) UNIQUE NOT NULL,
    telefone          VARCHAR(100) NOT NULL
);

-- 4. PRODUTO
CREATE TABLE produto (
    id_produto        SERIAL PRIMARY KEY,
    nome              VARCHAR(100) NOT NULL,
    descricao         TEXT,
    preco             NUMERIC(10,2) NOT NULL,
    categoria         VARCHAR(50),
    FK_id_vendedor    INT NOT NULL,
    FOREIGN KEY (FK_id_vendedor) REFERENCES vendedor(id_vendedor) ON DELETE CASCADE
);

-- 5. PEDIDO 
CREATE TABLE pedido (
    id_pedido         SERIAL PRIMARY KEY,
    FK_id_cliente     INT NOT NULL,
    data_pedido       DATE NOT NULL,
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

-- 6. ITEM_PEDIDO 
CREATE TABLE item_pedido (
    FK_id_pedido      INT NOT NULL,
    FK_id_produto     INT NOT NULL,
    quantidade        INT NOT NULL,
    preco_unitario    NUMERIC(10,2) NOT NULL, 
    PRIMARY KEY (FK_id_pedido, FK_id_produto),
    FOREIGN KEY (FK_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- 7. CARRINHO 
CREATE TABLE carrinho (
    id_carrinho       SERIAL PRIMARY KEY,
    FK_id_cliente     INT UNIQUE NOT NULL, 
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

-- 8. ITEM_CARRINHO 
CREATE TABLE item_carrinho (
    id_item           SERIAL PRIMARY KEY,
    id_carrinho       INT REFERENCES carrinho(id_carrinho) ON DELETE CASCADE,
    FK_id_produto     INT NOT NULL,
    quantidade        INT NOT NULL,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- 9. PAGAMENTO 
CREATE TABLE pagamento (
    id_pagamento      SERIAL PRIMARY KEY,
    FK_id_pedido      INT NOT NULL,
    forma_pagamento   VARCHAR(100),
    status_pagamento  BOOLEAN,
    valor_total       DECIMAL(10,2) NOT NULL,
    data_pagamento    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_vencimento   DATE, 
    numero_transacao  VARCHAR(100) UNIQUE, 
    motivo_recusa     VARCHAR(255), 
    FOREIGN KEY (FK_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

-- 10. WISHLIST 
CREATE TABLE wishlist(
    id_wishlist       SERIAL PRIMARY KEY,
    FK_id_cliente     INT NOT NULL,
    FK_id_produto     INT NOT NULL,
    data_adicao       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(FK_id_cliente, FK_id_produto),
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- 11. AVALIAÇÃO (Garante apenas uma avaliação por produto dentro daquele pedido)
CREATE TABLE avaliacao (
    id_avaliacao      SERIAL PRIMARY KEY,
    FK_id_cliente     INT NOT NULL,
    FK_id_produto     INT NOT NULL,
    FK_id_pedido      INT NOT NULL,
    avaliacao         INT NOT NULL CHECK (avaliacao >= 1 AND avaliacao <= 5),
    comentario        TEXT,
    data_avaliacao    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(FK_id_pedido, FK_id_produto), 
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

-- 12. AMAZON_ENTREGA
CREATE TABLE amazon_entrega (
    id_entrega        SERIAL PRIMARY KEY,
    nome_motorista    VARCHAR(100),
    id_motorista      INT NOT NULL,
    cnh               VARCHAR(20) NOT NULL, 
    placa_veiculo     VARCHAR(10) NOT NULL,
    FK_id_pedido      INT NOT NULL,
    data_saida        DATE, 
    data_entrega      DATE, 
    status_entrega    VARCHAR(60) DEFAULT 'Pendente', 
    FOREIGN KEY (FK_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

-- 13. ESTOQUE 
CREATE TABLE estoque (
    id_estoque         SERIAL PRIMARY KEY,
    FK_id_produto      INT NOT NULL UNIQUE,
    quantidade         INT NOT NULL DEFAULT 0,
    localizacao        VARCHAR(100), 
    ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- ======================================================================================
-- PARTE 2: INSERÇÃO DOS DADOS (POPULANDO O BANCO)
-- ======================================================================================

-- 1. CLIENTES (Originais 1-3 + Novos Usuários 4-8)
INSERT INTO cliente (nome_cliente, cpf, email, data_nascimento) VALUES 
('Alice Barros', '12345678901', 'alicebarros@email.com', '2004-03-10'),   -- ID 1
('Edimax Bastos', '98765432100', 'edimaxbastos@email.com', '2003-10-28'), -- ID 2
('Erick Wilson', '45678912344', 'erickwilson@email.com', '2002-11-02'),   -- ID 3
('Bruno Souza', '23456789012', 'brunosouza@email.com', '1998-05-20'),     -- ID 4
('Camila Lima', '34567890123', 'camilalima@email.com', '1993-09-14'),     -- ID 5
('Daniel Alves', '45678901234', 'danielalves@email.com', '2001-02-28'),   -- ID 6
('Fernanda Dias', '56789012345', 'fernandadias@email.com', '1985-12-05'),  -- ID 7
('Gabriel Cruz', '67890123456', 'gabrielcruz@email.com', '1997-07-19');    -- ID 8

-- 2. ENDEREÇOS (Dos 3 primeiros clientes)
INSERT INTO cliente_endereco (id_cliente, cep, rua, num, complemento, cidade, estado) VALUES 
(1, '01310-100', 'Avenida Paulista', 1000, 'Apto 51', 'São Paulo', 'SP'),
(2, '22021-001', 'Avenida Atlântica', 400, NULL, 'Rio de Janeiro', 'RJ'),
(3, '70002-900', 'Via S1 - Esplanada dos Ministérios', 10, 'Anexo 2', 'Brasília', 'DF');

-- 3. VENDEDORES
INSERT INTO vendedor (id_setor, setor, nome, email, telefone) VALUES 
(1, 'Eletrônicos', 'MegaEletro BR', 'vendas@megaeletro.com', '11988887777'),
(2, 'Livros e Papelaria', 'Livraria do Saber', 'contato@livrariasaber.com', '21977776666'),
(3, 'Casa e Cozinha', 'Lar Confortável', 'suporte@larconfort.com', '31966665555');

-- 4. PRODUTOS (IDs gerados de 1 a 5)
INSERT INTO produto (nome, descricao, preco, categoria, FK_id_vendedor) VALUES 
('Kindle Paperwhite', 'E-reader de 16GB com tela de 6.8 polegadas e iluminação embutida.', 799.00, 'Eletrônicos', 2),
('Smartphone Galaxy S24', 'Smartphone 256GB 5G com Inteligência Artificial integrada.', 4999.00, 'Eletrônicos', 1),
('Fones de Ouvido Bluetooth Pro', 'Fones intra-auriculares com cancelamento de ruído ativo.', 349.90, 'Eletrônicos', 1),
('Livro: Clean Code', 'Habilidades Práticas de Software Ágil por Robert C. Martin.', 95.00, 'Livros', 2),
('Cafeteira Elétrica Express', 'Cafeteira programável em aço inox com jarra de vidro.', 289.90, 'Cozinha', 3); -- ID 5

-- 5. ESTOQUE
INSERT INTO estoque (FK_id_produto, quantidade, localizacao) VALUES 
(1, 50, 'Galpão Principal - Prateleira A3'),
(2, 15, 'Cofre de Segurança - Setor E1'),
(3, 120, 'Galpão Principal - Prateleira A5'),
(4, 80, 'Corredor de Livros - Prateleira B2'),
(5, 35, 'Setor de Eletrodomésticos - Corredor C1');

-- 6. CARRINHO (Criando a estrutura de carrinho para os 8 clientes ativos)
INSERT INTO carrinho (FK_id_cliente) VALUES 
(1), (2), (3), (4), (5), (6), (7), (8);

-- 7. ITEM_CARRINHO (Itens salvos nas sacolas dos usuários)
-- Carrinho da Alice (1) e do Erick (3)
INSERT INTO item_carrinho (id_carrinho, FK_id_produto, quantidade) VALUES (1, 2, 1);
INSERT INTO item_carrinho (id_carrinho, FK_id_produto, quantidade) VALUES (3, 4, 1), (3, 5, 1);

-- Carrinhos dos 5 novos usuários (4 ao 8) namorando a Cafeteira (Produto 5)
INSERT INTO item_carrinho (id_carrinho, FK_id_produto, quantidade) VALUES 
(4, 5, 1), -- Bruno
(5, 5, 1), -- Camila
(6, 5, 1), -- Daniel
(7, 5, 1), -- Fernanda
(8, 5, 1); -- Gabriel

-- 8. PEDIDOS (Histórico de compras finalizadas)
INSERT INTO pedido (FK_id_cliente, data_pedido) VALUES 
(1, '2026-05-10'), -- Pedido 1 (Alice)
(1, '2026-06-01'), -- Pedido 2 (Alice)
(3, '2026-06-30'), -- Pedido 3 (Erick)
(2, '2026-06-15'), -- Pedido 4 (Edimax)
(2, '2026-07-01'); -- Pedido 5 (Edimax)

-- 9. ITEM_PEDIDO (Produtos associados aos pedidos realizados)
INSERT INTO item_pedido (FK_id_pedido, FK_id_produto, quantidade, preco_unitario) VALUES 
(1, 1, 1, 799.00),
(1, 3, 1, 349.90),
(2, 2, 1, 4999.00),
(3, 2, 1, 4999.00),
(4, 2, 1, 4999.00),
(5, 4, 1, 95.00);

-- 10. PAGAMENTO (Fluxo financeiro dos pedidos)
INSERT INTO pagamento (FK_id_pedido, forma_pagamento, status_pagamento, valor_total, numero_transacao) VALUES 
(1, 'Pix', TRUE, 1148.90, 'TX-PIX-1002938'), 
(2, 'Cartão de Crédito', TRUE, 4999.00, 'TX-CC-8472910'), 
(3, 'Cartão de Crédito', TRUE, 4999.00, 'TX-CC-8472911'), 
(4, 'Cartão de Crédito', TRUE, 4999.00, 'TX-CC-8472912');

INSERT INTO pagamento (FK_id_pedido, forma_pagamento, status_pagamento, valor_total, data_vencimento, numero_transacao) VALUES 
(5, 'Boleto Bancário', FALSE, 95.00, '2026-07-05', 'TX-BOL-9920112');

-- 11. WISHLIST
INSERT INTO wishlist (FK_id_cliente, FK_id_produto) VALUES 
(1, 4), 
(2, 5);

-- 12. AVALIAÇÃO
INSERT INTO avaliacao (FK_id_cliente, FK_id_produto, FK_id_pedido, avaliacao, comentario) VALUES 
(1, 1, 1, 5, 'Dispositivo fantástico para leitura! Bateria dura semanas.'), 
(2, 2, 2, 4, 'O celular é excelente e a IA ajuda muito, mas o carregamento esquenta um pouco.');

-- 13. AMAZON_ENTREGA (Status logístico dos envios)
INSERT INTO amazon_entrega (nome_motorista, id_motorista, cnh, placa_veiculo, FK_id_pedido, data_saida, data_entrega, status_entrega) VALUES 
('Carlos Silva', 101, '12345678900', 'ABC1D23', 1, '2026-05-11', '2026-05-14', 'Entregue'),
('Carlos Silva', 101, '12345678900', 'ABC1D23', 2, '2026-05-11', '2026-06-01', 'Entregue'),
('Carlos Silva', 101, '12345678900', 'ABC1D23', 3, '2026-07-01', '2026-07-05', 'Entregue'),
('Roberto Souza', 102, '98765432101', 'XYZ9G99', 4, '2026-06-16', NULL, 'Em trânsito');

INSERT INTO amazon_entrega (nome_motorista, id_motorista, cnh, placa_veiculo, FK_id_pedido, data_saida, data_entrega, status_entrega) VALUES 
(NULL, 0, 'N/A', 'N/A', 5, NULL, NULL, 'Pendente');

