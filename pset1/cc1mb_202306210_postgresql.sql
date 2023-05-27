--Turma CC1MB
--Aluno Lorenzo Simonassi
--PSET 1

--Apagar o banco de dados e usuário anteriores caso já existam

DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS lorenzo;

--Criar usuário capaz de criar um banco de dados e uma role possuindo uma senha
CREATE USER lorenzo CREATEDB CREATEROLE PASSWORD 'computacao@raiz';



--Criar banco de dados com as especificações pedidas
CREATE DATABASE uvv
    WITH OWNER = lorenzo
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    ALLOW_CONNECTIONS = true;
   
--Concede privilégios ao usuário lorenzo no banco de dados uvv
GRANT ALL PRIVILEGES ON DATABASE uvv TO lorenzo;

--Conecta ao banco de dados "uvv" com o usuário proprietário
\c 'dbname=uvv user=lorenzo password=computacao@raiz';

--Cria o esquema "lojas" 
CREATE SCHEMA lojas AUTHORIZATION lorenzo;

--Garante todos os privilégios ao usuário lorenzo a utilizar o esquema "lojas"
GRANT ALL PRIVILEGES ON SCHEMA lojas TO lorenzo;

--Definindo search path para lojas para o proprietário e usuário postgres
ALTER USER lorenzo SET SEARCH_PATH TO lojas, "$user", public;
				   SET SEARCH_PATH TO lojas, "$user", public;

--Criar tabela (produtos)
CREATE TABLE produtos (
                produto_id                      NUMERIC(38)     NOT NULL,
                nome                            VARCHAR(255)    NOT NULL,
                preco_unitario                  NUMERIC(10,2),
                detalhes                        BYTEA,
                imagem                          BYTEA,
                imagem_mime_type                VARCHAR(512),
                imagem_arquivo                  VARCHAR(512),
                imagem_charset                  VARCHAR(512),
                imagem_ultima_atualizacao       DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);

--Comentário referente a tabela (produtos)
COMMENT ON TABLE produtos IS 'Essa tabela armazena informações sobre os produtos disponíveis nas lojas. 
Ela contém dados como o nome, preço unitário, detalhes e arquivos de imagem associados a cada produto. É usada para manter o catálogo de produtos das lojas.
';


--Comentários referente as colunas da tabela (produtos)
COMMENT ON COLUMN produtos.produto_id                  IS 'Primary key da tabela (produtos), serve para identificar um produto.';
COMMENT ON COLUMN produtos.nome                	       IS 'Serve para identificar o nome de um produto.';
COMMENT ON COLUMN produtos.preco_unitario      	       IS 'Serve para identificar o preço unitário de um produto.';
COMMENT ON COLUMN produtos.detalhes           	       IS 'Serve para identificar os detalhes de um produto.';
COMMENT ON COLUMN produtos.imagem              	       IS 'Serve para identificar a imagem de um produto.';
COMMENT ON COLUMN produtos.imagem_mime_type   	       IS 'Serve para identificar a imagem_mime_type de um produto.';
COMMENT ON COLUMN produtos.imagem_arquivo      	       IS 'Serve para identificar o arquivo da imagem de um produto.';
COMMENT ON COLUMN produtos.imagem_charset      	       IS 'Serve para identificar a imagem_charset de um produto.';
COMMENT ON COLUMN produtos.imagem_ultima_atualizacao   IS 'Serve para identificar a ultima atualização da imagem de um produto.';

--Criar as CHECK CONSTRAINTS da tabela (produtos)
ALTER TABLE produtos ADD CONSTRAINT produtos_preco_unitario_nao_negativo CHECK (preco_unitario > 0);

ALTER TABLE produtos ADD CONSTRAINT produtos_produto_id_nao_negativo 	 CHECK (produto_id > 0);

ALTER TABLE produtos ADD CONSTRAINT imagem_preenchida			    CHECK ((imagem IS NOT NULL  AND imagem_mime_type IS NOT NULL
   																				                AND imagem_arquivo IS NOT NULL
    																				            AND imagem_charset IS NOT NULL
    																				            AND imagem_ultima_atualizacao IS NOT NULL)
    																				     
    															    OR (imagem IS  NULL         AND imagem_mime_type IS  NULL
   																				                AND imagem_arquivo IS  NULL
    																				        	AND imagem_charset IS  NULL
    																				        	AND imagem_ultima_atualizacao IS  NULL));




-- Criar a tabela (lojas)
CREATE TABLE lojas (
                loja_id                 NUMERIC(38)     NOT NULL,
                nome                    VARCHAR(255)    NOT NULL,
                endereco_web            VARCHAR(100),
                endereco_fisico         VARCHAR(512),
                latitude                NUMERIC,
                longitude               NUMERIC,
                logo                    BYTEA,
                logo_mime_type          VARCHAR(512),
                logo_arquivo            VARCHAR(512),
                logo_charset            VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);

--Comentário referente a tabela (lojas)
COMMENT ON TABLE lojas IS 'Essa tabela guarda os dados das lojas, como seus nomes, endereços físicos e endereços web. 
Também armazena informações sobre a localização geográfica das lojas e os arquivos de logotipo associados a cada uma delas.';


--Comentários referente as colunas da tabela (lojas)
COMMENT ON COLUMN lojas.loja_id      		      IS 'Primary key da tabela (lojas), serve para identificar uma loja.';
COMMENT ON COLUMN lojas.nome            	      IS 'Serve para identificar o nome da loja.';
COMMENT ON COLUMN lojas.endereco_web    		  IS 'Serve para identificar o endereço web da loja.';
COMMENT ON COLUMN lojas.endereco_fisico 		  IS 'Serve para identificar o endereço físico da loja.';
COMMENT ON COLUMN lojas.latitude        		  IS 'Serve para identifcar a latitude da loja.';
COMMENT ON COLUMN lojas.longitude       		  IS 'Serve para identificar a longitude da loja.';
COMMENT ON COLUMN lojas.logo            		  IS 'Serve para identificar a logo da loja.';
COMMENT ON COLUMN lojas.logo_mime_type  		  IS 'Serve para identificar a logo_mime_type da loja.';
COMMENT ON COLUMN lojas.logo_arquivo    		  IS 'Serve para identificar a logo_arquivo da loja.';
COMMENT ON COLUMN lojas.logo_charset    		  IS 'Serve para identificar a logo_charset da loja.';
COMMENT ON COLUMN lojas.logo_ultima_atualizacao   IS 'Serve para identificar a última atualização do logo da loja.';

--Criar as CHECK CONSTRAINTS da tabela (lojas)
ALTER TABLE lojas ADD CONSTRAINT lojas_loja_id_nao_negativo 	CHECK (loja_id > 0);

ALTER TABLE lojas ADD CONSTRAINT endereco_preenchido       		CHECK ((endereco_web IS NOT NULL) OR (endereco_fisico IS NOT NULL));

ALTER TABLE lojas ADD CONSTRAINT latitude_longitude_preenchido  CHECK ((latitude IS NOT NULL AND longitude IS NOT NULL) OR (latitude IS NULL AND longitude IS NULL));

ALTER TABLE lojas ADD CONSTRAINT logo_preenchida			    CHECK ((logo IS NOT NULL   AND logo_mime_type IS NOT NULL
   																				           AND logo_arquivo IS NOT NULL
    																				       AND logo_charset IS NOT NULL
    																				       AND logo_ultima_atualizacao IS NOT NULL)
    																				     
    															OR (logo IS  NULL          AND logo_mime_type IS  NULL
   																				           AND logo_arquivo IS  NULL
    																				       AND logo_charset IS  NULL
    																				       AND logo_ultima_atualizacao IS  NULL));


--Criar a tabela (estoques)
CREATE TABLE estoques (
                estoque_id     NUMERIC(38)     NOT NULL,
                loja_id        NUMERIC(38)     NOT NULL,
                produto_id     NUMERIC(38)     NOT NULL,
                quantidade     NUMERIC(38)     NOT NULL,
                CONSTRAINT estoque_id PRIMARY KEY (estoque_id)
);

--Comentário referente a tabela (estoques)
COMMENT ON TABLE estoques IS 'A tabela "estoques" é responsável por armazenar as informações sobre os estoques de produtos em cada loja. 
Ela registra a quantidade disponível de cada produto em cada loja e está relacionada às tabelas de lojas e produtos.';


--Comentários referente as colunas da tabela (estoques)
COMMENT ON COLUMN estoques.estoque_id 	IS 'Primary key da tabela (estoques), serve para identificar um estoque.';
COMMENT ON COLUMN estoques.loja_id    	IS 'Foreign key da tabela (estoques), serve para fazer relação com a tabela (lojas).';
COMMENT ON COLUMN estoques.produto_id 	IS 'Foreign key da tabela (estoques), serve para fazer relação com a tabela (produtos).';
COMMENT ON COLUMN estoques.quantidade   IS 'Serve para identificar a quantidade no estoque.';


--Criar as CHECK CONSTRAINTS da tabela (estoques)
ALTER TABLE estoques ADD CONSTRAINT estoques_estoque_id_nao_negativo  CHECK (estoque_id > 0);

ALTER TABLE estoques ADD CONSTRAINT estoques_loja_id_nao_negativo     CHECK (loja_id > 0);

ALTER TABLE estoques ADD CONSTRAINT estoques_produto_id_nao_negativo  CHECK (produto_id > 0);
 
ALTER TABLE estoques ADD CONSTRAINT estoques_quantidade_nao_negativo  CHECK (quantidade > 0);


--Criar a tabela (clientes)
CREATE TABLE clientes (
                cliente_id      NUMERIC(38)     NOT NULL,
                email           VARCHAR(255)    NOT NULL,
                nome            VARCHAR(255)    NOT NULL,
                telefone1       VARCHAR(20),
                telefone2       VARCHAR(20),
                telefone3       VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);

--Comentário referente a tabela (clientes)
COMMENT ON TABLE clientes IS 'Essa tabela armazena informações sobre os clientes, como seus nomes, endereços de e-mail e números de telefone. 
É usada para registrar os dados dos clientes que realizam pedidos nas lojas.';


--Comentários referente as colunas da tabela (clientes)
COMMENT ON COLUMN clientes.cliente_id    IS 'Primary key da tabela (clientes), serve para identificar um cliente.';
COMMENT ON COLUMN clientes.email         IS 'Email do cliente.';
COMMENT ON COLUMN clientes.nome          IS 'Nome do cliente.';
COMMENT ON COLUMN clientes.telefone1     IS 'Telefone 1 do cliente.';
COMMENT ON COLUMN clientes.telefone2     IS 'Telefone 2 do cliente.';
COMMENT ON COLUMN clientes.telefone3     IS 'Telefone 3 do cliente.';


--Criar as CHECK CONSTRAINTS da tabela (clientes)
ALTER TABLE clientes ADD CONSTRAINT clientes_cliente_id_nao_negativo CHECK (cliente_id > 0);


--Criar tabela (envios)
CREATE TABLE envios (
                envio_id            NUMERIC(38)         NOT NULL,
                loja_id             NUMERIC(38)         NOT NULL,
                cliente_id          NUMERIC(38)         NOT NULL,
                endereco_entrega    VARCHAR(512)        NOT NULL,
                status              VARCHAR(15)         NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);

--Comentário referente a tabela envios
COMMENT ON TABLE envios IS 'Nesta tabela são registrados os envios de produtos para os clientes. 
Ela contém informações como o endereço de entrega, o status do envio e as associações com as tabelas de lojas e clientes.';


--Comentários referente as colunas da tabela (envios)
COMMENT ON COLUMN envios.envio_id 	          IS 'Primary key da tabela (envios), serve para identificar um envio.';
COMMENT ON COLUMN envios.loja_id 			  IS 'Foreign Key da tabela (envios), serve para fazer relação com a tabela (lojas).';
COMMENT ON COLUMN envios.cliente_id 		  IS 'Foreign key da tabela (envios), serve para fazer relação com a tabela (clientes).';
COMMENT ON COLUMN envios.endereco_entrega     IS 'Serve para identificar um endereço de entrega.';
COMMENT ON COLUMN envios.status 			  IS 'Serve para visualizar o status do envio.';


--Criar as CHECK CONSTRAINTS da tabela (envios)
ALTER TABLE envios ADD CONSTRAINT envios_envio_id_nao_negativo 	 CHECK (envio_id > 0);

ALTER TABLE envios ADD CONSTRAINT envios_loja_id_nao_negativo 	 CHECK (loja_id > 0);

ALTER TABLE envios ADD CONSTRAINT envios_cliente_id_nao_negativo CHECK (cliente_id > 0);

ALTER TABLE envios ADD CONSTRAINT envios_status_envio_valido 	 CHECK (status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'));


--Criar a tabela (pedidos)
CREATE TABLE pedidos (
                pedido_id        NUMERIC(38)          NOT NULL,
                data_hora        TIMESTAMP            NOT NULL,
                cliente_id       NUMERIC(38)          NOT NULL,
                status           VARCHAR(15)          NOT NULL,
                loja_id          NUMERIC(38)          NOT NULL,
                CONSTRAINT pk_pedido_id PRIMARY KEY (pedido_id)
);

--Comentário referente a tabela (pedidos)
COMMENT ON TABLE pedidos IS 'Nesta tabela são registrados os pedidos feitos pelos clientes. 
Ela contém informações como a data e hora do pedido, o status do pedido e as associações com as tabelas de clientes, lojas e itens de pedido.';


--Comentários referente as colunas da tabela (pedidos)
COMMENT ON COLUMN pedidos.pedido_id 		IS 'Primary key da tabela (pedidos), responsável por identificar um pedido.';
COMMENT ON COLUMN pedidos.data_hora 		IS 'Serve para mostrar data e hora dos pedidos.';
COMMENT ON COLUMN pedidos.cliente_id 	    IS 'Foreign key da tabela (pedidos), serve para fazer relação com a tabela (clientes).';
COMMENT ON COLUMN pedidos.status 			IS 'Serve para ver os status do pedido.';
COMMENT ON COLUMN pedidos.loja_id 			IS 'Foreign key da tabela (pedidos), serve para fazer relação com a tabela (lojas).';


--Criar as CHECK CONSTRAINTS da tabela (pedidos)
ALTER TABLE pedidos ADD CONSTRAINT pedidos_pedido_id_nao_negativo  CHECK (pedido_id > 0);

ALTER TABLE pedidos ADD CONSTRAINT pedidos_cliente_id_nao_negativo CHECK (cliente_id > 0);

ALTER TABLE pedidos ADD CONSTRAINT pedidos_status_pedido_valido    CHECK (status IN ('CANCELADO','COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'));

ALTER TABLE pedidos ADD CONSTRAINT pedidos_loja_id_nao_negativo    CHECK (loja_id > 0);


--Criar a tabela (pedidos_itens)
CREATE TABLE pedidos_itens (
                pedido_id          NUMERIC(38)      NOT NULL,
                produto_id     	   NUMERIC(38)      NOT NULL,
                numero_da_linha    NUMERIC(38)      NOT NULL,
                preco_unitario     NUMERIC(10,2)    NOT NULL,
                quantidade         NUMERIC(38)      NOT NULL,
                envio_id           NUMERIC(38),
                CONSTRAINT pedido_id PRIMARY KEY (pedido_id, produto_id)
);

--Comentário referente a tabela (pedidos_itens)
COMMENT ON TABLE pedidos_itens IS 'A tabela "pedidos_itens" registra os itens individuais de cada pedido realizado pelos clientes.
Ela contém informações como o número da linha, o preço unitário, a quantidade e as associações com as tabelas de pedidos, produtos e envios.';


--Comentários referente as colunas da tabela (pedidos_itens)
COMMENT ON COLUMN pedidos_itens.pedido_id 		  IS 'Primary foreign key da tabela (pedidos_itens), serve para fazer uma relação com a tabela (pedidos).';
COMMENT ON COLUMN pedidos_itens.produto_id 	      IS 'Primary foreign key da tabela (pedidos_itens), serve para fazer uma relação com a tabela (produtos).';
COMMENT ON COLUMN pedidos_itens.numero_da_linha   IS 'Serve para identificar o numero_da_linha dos itens pedidos.';
COMMENT ON COLUMN pedidos_itens.preco_unitario    IS 'Serve para identificar o preço unitário dos itens pedidos.';
COMMENT ON COLUMN pedidos_itens.quantidade 	      IS 'Serve para identificar a quantidade de itens pedidos.';
COMMENT ON COLUMN pedidos_itens.envio_id 		  IS 'Foreign key da tabela (pedidos_itens), serve para fazer uma relação com a tabela (envios).';


--Criar as CHECK CONSTRAINTS da tabela (pedidos_itens)
ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_itens_pedido_id_nao_negativo 		CHECK (pedido_id > 0);

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_itens_produto_id_nao_negativo 		CHECK (produto_id > 0);

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_itens_preco_unitario_nao_negativo 	CHECK (preco_unitario > 0);

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_itens_quantidade_nao_negativo 		CHECK (quantidade > 0);

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_itens_envio_id_nao_negativo 		CHECK (envio_id > 0);


--Criar as RELAÇÕES
ALTER TABLE estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;











