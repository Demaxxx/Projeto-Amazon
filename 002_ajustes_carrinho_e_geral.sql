CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    endereco VARCHAR(200)
);

CREATE TABLE vendedor (
    id_vendedor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco NUMERIC(10,2) NOT NULL,
    categoria VARCHAR(50),
    id_vendedor INT NOT NULL,
    FOREIGN KEY (id_vendedor) REFERENCES vendedor(id_vendedor) ON DELETE CASCADE
);

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    data_pedido DATE NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE item_pedido (
    id_item SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE RESTRICT
);

CREATE TABLE carrinho (
    id_carrinho SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE item_carrinho (
    id_item SERIAL PRIMARY KEY,
    id_carrinho INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    FOREIGN KEY (id_carrinho) REFERENCES carrinho(id_carrinho) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);



/* testes */


INSERT INTO cliente (nome, email, endereco) 
VALUES ('Edi', 'edi@gmail.com', 'Rua 1');

INSERT INTO vendedor (nome, email) 
VALUES ('Loja 1', 'loja1@gmail.com');

INSERT INTO produto (nome, descricao, preco, categoria, id_vendedor)
VALUES ('Notebook', 'Notebook Gamer', 4500.00, 'Eletronicos', 1);

INSERT INTO pedido (data_pedido, id_cliente)
VALUES ('2026-06-20', 1);

INSERT INTO item_pedido (id_pedido, id_produto, quantidade)
VALUES (1, 1, 2);

INSERT INTO carrinho (id_cliente)
VALUES (1);

INSERT INTO item_carrinho (id_carrinho, id_produto, quantidade)
VALUES (1, 1, 1);

SELECT * FROM cliente;
SELECT * FROM vendedor;
SELECT * FROM produto;
SELECT * FROM pedido;
SELECT * FROM item_pedido;
SELECT * FROM carrinho;
SELECT * FROM item_carrinho;

/* FK invalida */
/* 
INSERT INTO produto (nome, preco, id_vendedor)
VALUES ('Mouse', 100, 99); 
*/

/* on delete cascade */
/* 
DELETE FROM cliente WHERE id_cliente = 1; 
*/

/* on delete restrict */
/* 
DELETE FROM produto WHERE id_produto = 1; 
*/
