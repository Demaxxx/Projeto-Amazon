-- 1. CLIENTE (Ajustado tipo da data e adicionado UNIQUE no CPF)
CREATE TABLE cliente (
    id_cliente        SERIAL PRIMARY KEY,
    nome_cliente      VARCHAR(100) NOT NULL,
    cpf               VARCHAR(11) UNIQUE NOT NULL,
    email             VARCHAR(100) UNIQUE NOT NULL,
    data_nascimento   DATE NOT NULL
);

-- 2. ENDEREÇO (Agora devidamente vinculado ao Cliente. CEP alterado para VARCHAR)
CREATE TABLE cliente_endereco (
    id_endereco       SERIAL PRIMARY KEY,
    id_cliente        INT NOT NULL,
    cep               VARCHAR(9) NOT NULL,
    rua               VARCHAR(50) NOT NULL,
    num               INT NOT NULL,
    complemento       VARCHAR(100), -- Removido NOT NULL pois nem todo lugar tem complemento
    cidade            VARCHAR(50) NOT NULL,
    estado            VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

-- 3. VENDEDOR (Removido o UNIQUE de id_setor para que mais vendedores possam atuar no mesmo setor)
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

-- 6. ITEM_PEDIDO Permite vários produtos no mesmo pedido
CREATE TABLE item_pedido (
    FK_id_pedido      INT NOT NULL,
    FK_id_produto     INT NOT NULL,
    quantidade        INT NOT NULL,
    preco_unitario    NUMERIC(10,2) NOT NULL, -- Importante: guarda o preço do produto no momento da compra
    PRIMARY KEY (FK_id_pedido, FK_id_produto),
    FOREIGN KEY (FK_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- 7. CARRINHO 
CREATE TABLE carrinho (
    id_carrinho       SERIAL PRIMARY KEY,
    FK_id_cliente     INT UNIQUE NOT NULL, -- UNIQUE garante que o cliente tenha apenas um carrinho ativo
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

-- 8. ITEM_CARRINHO 
CREATE TABLE item_carrinho (
    id_item           SERIAL PRIMARY KEY,
    FK_id_carrinho    INT NOT NULL,
    FK_id_produto     INT NOT NULL,
    quantidade        INT NOT NULL,
    FOREIGN KEY (FK_id_carrinho) REFERENCES carrinho(id_carrinho) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);


-- 9. PAGAMENTO (Vinculado ao PEDIDO por ID, corrigido erro da vírgula)
CREATE TABLE pagamento (
    id_pagamento      SERIAL PRIMARY KEY,
    FK_id_pedido      INT NOT NULL,
    forma_pagamento   VARCHAR(100),
    status_pagamento  BOOLEAN,
    valor_total       DECIMAL(10,2) NOT NULL,
  	data_pagamento    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_vencimento   DATE, -- Para boletos
    numero_transacao  VARCHAR(100) UNIQUE, -- Rastreabilidade
    motivo_recusa     VARCHAR(255), -- Se recusado
    FOREIGN KEY (FK_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);


-- 10. WISHLIST (NOVO)
CREATE TABLE wishlist(
 	id_wishlist       SERIAL PRIMARY KEY,
    FK_id_cliente     INT NOT NULL,
    FK_id_produto     INT NOT NULL,
    data_adicao       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(FK_id_cliente, FK_id_produto),
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);

-- 11. AVALIAÇÃO (NOVO)
CREATE TABLE avaliacao (
    id_avaliacao      SERIAL PRIMARY KEY,
    FK_id_cliente     INT NOT NULL,
    FK_id_produto     INT NOT NULL,
    FK_id_pedido      INT NOT NULL,
    avaliacao     	  INT NOT NULL CHECK (avaliacao >= 1 AND avaliacao <= 5),
    comentario        TEXT,
    data_avaliacao    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE,
    FOREIGN KEY (FK_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

-- 10. AMAZON_ENTREGA ajustada(adição de datas de saída e entrega e status)
CREATE TABLE amazon_entrega (
    id_entrega        SERIAL PRIMARY KEY,
    nome_motorista    VARCHAR(100),
    id_motorista      INT NOT NULL,
    cnh               VARCHAR(20) NOT NULL, 
    placa_veiculo     VARCHAR(10) NOT NULL,
    FK_id_pedido      INT NOT NULL,
  	data_saida		  DATE NOT NULL,
  	data_entrega      DATE NOT NULL,
  	status_entrega    VARCHAR(60) DEFAULT 'Pendente', --em_transito, entregue.
    FOREIGN KEY (FK_id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE
);

-- 13. ESTOQUE (NOVO)
CREATE TABLE estoque (
    id_estoque        SERIAL PRIMARY KEY,
    FK_id_produto     INT NOT NULL UNIQUE,
    quantidade        INT NOT NULL DEFAULT 0,
    localizacao       VARCHAR(100), -- Localização no armazém
    ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);






SELECT cliente.nome_cliente, cliente.id_cliente, cliente_endereco.cep
FROM cliente
JOIN cliente_endereco
ON cliente.id_cliente = cliente_endereco.id_cliente;

/* Forma como insere valores na variável ultima_atualizacao.
INSERT INTO estoque (ultima_atualizacao) VALUES (CURRENT_TIMESTAMP);
SELECT estoque.ultima_atualizacao FROM estoque;*/