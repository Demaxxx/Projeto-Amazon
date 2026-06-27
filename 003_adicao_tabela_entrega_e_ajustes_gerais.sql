/*Adição: cpf, data_nascimento*/
CREATE TABLE cliente (
    id_cliente 			SERIAL PRIMARY KEY,
    nome_cliente 		VARCHAR(100) NOT NULL,
  	cpf 				VARCHAR(11) NOT NULL,
    email 				VARCHAR(100) UNIQUE NOT NULL,
  	data_nascimento 	VARCHAR(50) NOT NULL
);
/*INSERT INTO cliente VALUES (12, 'Erick', '12345678900', 'erickemail.com', '131331');*/
-------------------------------------------------------------------------------------------------------------------------------
/*Criei outra tabela específica para o endereco do cliente. OLHAR O QUARY! */
CREATE TABLE cliente_endereco(
	CEP					SERIAL PRIMARY KEY,
  	rua 				VARCHAR(50) NOT NULL,
  	num					INT NOT NULL,
  	complemento			VARCHAR(100) NOT NULL,
  	cidade				VARCHAR(50) NOT NULL,
	estado				VARCHAR(50) NOT NULL
);
/*INSERT INTO cliente_endereco VALUES (123499,'idcnw', 10, 'ajnaijan', 'iwocno', 'odakcmo');*/
-------------------------------------------------------------------------------------------------------------------------------
/*Adição: id_setor, setor, telefone*/
CREATE TABLE vendedor (
    id_vendedor 		SERIAL PRIMARY KEY,
  	id_setor			INT UNIQUE NOT NULL,
  	setor				VARCHAR(100) NOT NULL,
    nome 				VARCHAR(100) NOT NULL,
    email 				VARCHAR(100) UNIQUE NOT NULL,
  	telefone			VARCHAR(100) NOT NULL
);
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE produto (
    id_produto			SERIAL PRIMARY KEY,
    nome 				VARCHAR(100) NOT NULL,
    descricao 			TEXT,
    preco 				NUMERIC(10,2) NOT NULL,
    categoria 			VARCHAR(50),
    FK_id_vendedor 		INT NOT NULL,
  
    FOREIGN KEY (FK_id_vendedor) REFERENCES vendedor(id_vendedor) ON DELETE CASCADE
);
-------------------------------------------------------------------------------------------------------------------------------
/* Identifiquei todas as chaves estrangeiras só para ficar claro; Adição: preco, categoria e mais uma chave estrangeira; Adição: FK do id_vendedor*/
CREATE TABLE  pedido (
    FK_id_produto 		SERIAL NOT NULL,
 	Fk_id_cliente 		INT NOT NULL,
  	FK_id_vendedor		INT NOT NULL,
    data_pedido 		DATE NOT NULL,
  	preco 				NUMERIC(10,2) NOT NULL,
    categoria 			VARCHAR(50),
  	qntd				INT NOT NULL,
    
  
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE,
  	FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE,
  	FOREIGN KEY (FK_id_vendedor) REFERENCES vendedor(id_vendedor) ON DELETE CASCADE
);
-------------------------------------------------------------------------------------------------------------------------------
/*Removoção item_pedido; acredito que itemp_pedido não tem muita serventia, o pedido já possui todos os atributos nescessários*/
-------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE carrinho(
    id_carrinho 		SERIAL PRIMARY KEY,
  	FK_id_produto 		INT NOT NULL,
    FK_id_cliente 		INT NOT NULL,
  	num_itens			INT NOT NULL,
  	
  	FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE RESTRICT,
    FOREIGN KEY (FK_id_cliente) REFERENCES cliente(id_cliente) ON DELETE CASCADE
);
-------------------------------------------------------------------------------------------------------------------------------
/*Retirei o  [id_produto INT NOT NULL] pois não vi funcionalidade, acredito que o id do item já vale*/
CREATE TABLE item_carrinho(
    id_item 			SERIAL PRIMARY KEY,
    FK_id_carrinho 		INT NOT NULL,
    quantidade 			INT NOT NULL,
  
    FOREIGN KEY (FK_id_carrinho) REFERENCES carrinho(id_carrinho) ON DELETE CASCADE
);
-------------------------------------------------------------------------------------------------------------------------------
/*Adicionei uma nova tabela dedicada ao frete oficial da amazon*/
CREATE TABLE amazon_entrega(
	nome_motorista		VARCHAR(100),
  	id_motorista		INT NOT NULL,
  	cnh					INT NOT NULL,
  	placa_veiculo		INT NOT NULL,
  	num_produtos		INT NOT NULL,
  	FK_id_produto		INT NOT NULL,
  
  	FOREIGN KEY (FK_id_produto) REFERENCES produto(id_produto) ON DELETE CASCADE
);
-------------------------------------------------------------------------------------------------------------------------------
/*CREATE TABLE regiao_pedido(
	CEP 				SERIAL PRIMARY KEY,
	);
*/



SELECT * FROM cliente;
-------------------------------------------------------------------------------------------------------------------------------
/*Este select mostra alguns dados específicos da tabela anterior sem o uso de FKs(achei que seria mais prático). Pelo que eu me lembre 
e que vale ressalar, o professor, em uma das aulas, pediu que nós evitássemos o uso de '*' nas Selects */
SELECT nome_cliente, id_cliente, CEP, rua, complemento, cidade, estado FROM cliente_endereco, cliente;	
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM vendedor;
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM produto;
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM pedido;
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM carrinho;
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM item_carrinho;
-------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM amazon_entrega;
-------------------------------------------------------------------------------------------------------------------------------


