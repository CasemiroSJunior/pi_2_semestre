-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 02/12/2024 às 22:31
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `banco`
--
CREATE DATABASE IF NOT EXISTS `banco` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `banco`;

-- --------------------------------------------------------

--
-- Estrutura para tabela `categoria`
--

CREATE TABLE `categoria` (
  `Id_Categoria` int(11) NOT NULL,
  `Nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `categoria`
--

INSERT INTO `categoria` (`Id_Categoria`, `Nome`) VALUES
(3, 'Bebidas'),
(4, 'Doces'),
(2, 'Pizza Doce'),
(1, 'Pizza Salgada'),
(5, 'Promoção');

-- --------------------------------------------------------

--
-- Estrutura para tabela `entregador`
--

CREATE TABLE `entregador` (
  `Id_entregador` int(11) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Telefone` varchar(20) DEFAULT NULL,
  `DataCriacao` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `entregador`
--

INSERT INTO `entregador` (`Id_entregador`, `Nome`, `Telefone`, `DataCriacao`) VALUES
(1, 'João Silva', '11987654321', '2024-11-05'),
(2, 'Maria Oliveira', '11987651234', '2024-11-05'),
(3, 'Carlos Souza', '11987659876', '2024-11-05'),
(4, 'Ana Costa', '11987650987', '2024-11-05'),
(5, 'Pedro Santos', '11987653456', '2024-11-05');

-- --------------------------------------------------------

--
-- Estrutura para tabela `frete`
--

CREATE TABLE `frete` (
  `Id_frete` int(11) NOT NULL,
  `DistanciaKm` decimal(5,2) NOT NULL,
  `Preco` decimal(10,4) NOT NULL,
  `DataCriacao` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `frete`
--

INSERT INTO `frete` (`Id_frete`, `DistanciaKm`, `Preco`, `DataCriacao`) VALUES
(1, 5.00, 8.5000, '2024-11-05'),
(2, 10.00, 12.0000, '2024-11-05'),
(3, 15.00, 15.7500, '2024-11-05'),
(4, 20.00, 18.5000, '2024-11-05'),
(5, 25.00, 22.0000, '2024-11-05');

-- --------------------------------------------------------

--
-- Estrutura para tabela `ingrediente`
--

CREATE TABLE `ingrediente` (
  `Id_ingrediente` int(11) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Disponivel` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `ingrediente`
--

INSERT INTO `ingrediente` (`Id_ingrediente`, `Nome`, `Disponivel`) VALUES
(1, 'Mussarela', 1),
(2, 'Tomate', 1),
(3, 'Orégano', 1);

--
-- Acionadores `ingrediente`
--
DELIMITER $$
CREATE TRIGGER `AtualizaStatusProdutoUpdate` AFTER UPDATE ON `ingrediente` FOR EACH ROW BEGIN
    IF OLD.Disponivel != NEW.Disponivel THEN
        UPDATE produto
        SET Disponivel = NEW.Disponivel
        WHERE Id_Produto IN (
            SELECT Id_produto
            FROM produto_ingrediente
            WHERE Id_ingrediente = NEW.Id_ingrediente
        );
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pagamento`
--

CREATE TABLE `pagamento` (
  `Id_pagamento` int(11) NOT NULL,
  `Descricao` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pagamento`
--

INSERT INTO `pagamento` (`Id_pagamento`, `Descricao`) VALUES
(1, 'Dinheiro'),
(2, 'Cartão de Crédito'),
(3, 'Cartão de Débito'),
(4, 'Pix'),
(5, 'Vale Refeição');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedido`
--

CREATE TABLE `pedido` (
  `Id_Pedido` int(11) NOT NULL,
  `Id_Entregador` int(11) DEFAULT NULL,
  `Id_Frete` int(11) NOT NULL,
  `Id_Pagamento` int(11) NOT NULL,
  `DataVenda` date DEFAULT curdate(),
  `ValorFrete` decimal(10,2) NOT NULL DEFAULT 0.00,
  `Entrega` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedido`
--

INSERT INTO `pedido` (`Id_Pedido`, `Id_Entregador`, `Id_Frete`, `Id_Pagamento`, `DataVenda`, `ValorFrete`, `Entrega`) VALUES
(1, 1, 1, 1, '2024-11-05', 8.50, 0),
(2, 2, 2, 2, '2024-11-05', 12.00, 0),
(3, 1, 3, 3, '2024-11-05', 15.75, 0),
(4, 2, 4, 4, '2024-11-05', 18.50, 0),
(5, 1, 5, 5, '2024-11-05', 22.00, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedido_item`
--

CREATE TABLE `pedido_item` (
  `Id_Item_Pedido` int(11) NOT NULL,
  `Id_Pedido` int(11) NOT NULL,
  `Id_Produto` int(11) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Descricao` text DEFAULT NULL,
  `ValorUnitario` decimal(10,2) NOT NULL,
  `Quantidade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedido_item`
--

INSERT INTO `pedido_item` (`Id_Item_Pedido`, `Id_Pedido`, `Id_Produto`, `Nome`, `Descricao`, `ValorUnitario`, `Quantidade`) VALUES
(6, 1, 1, 'Pizza Margherita', 'Molho de tomate, mussarela e manjericão', 30.00, 1),
(7, 1, 3, 'Refrigerante 2L', 'Refrigerante de cola 2L', 10.00, 2),
(10, 4, 1, 'Pizza Margherita', 'Molho de tomate, mussarela e manjericão', 30.00, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto`
--

CREATE TABLE `produto` (
  `Id_Produto` int(11) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `DataCriacao` date DEFAULT curdate(),
  `Preco` decimal(10,2) NOT NULL,
  `Descricao` text DEFAULT NULL,
  `Disponivel` tinyint(1) DEFAULT 1,
  `Id_Categoria` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto`
--

INSERT INTO `produto` (`Id_Produto`, `Nome`, `DataCriacao`, `Preco`, `Descricao`, `Disponivel`, `Id_Categoria`) VALUES
(1, 'Pizza Margherita', '2024-11-05', 30.00, 'Mussarela, Tomate, Orégano', 1, 1),
(3, 'Refrigerante 2L', '2024-11-05', 10.00, 'Mussarela, Tomate, Orégano', 1, 3),
(5, 'Pizza Pepperoni', '2024-11-05', 40.00, 'Mussarela', 1, 1),
(7, 'Pizza Roca', '2024-12-02', 23.90, 'Pepperoni', 1, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto_ingrediente`
--

CREATE TABLE `produto_ingrediente` (
  `Id_produto` int(11) NOT NULL,
  `Id_ingrediente` int(11) NOT NULL,
  `Disponivel` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto_ingrediente`
--

INSERT INTO `produto_ingrediente` (`Id_produto`, `Id_ingrediente`, `Disponivel`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(3, 1, 1),
(3, 2, 1),
(3, 3, 1),
(5, 1, 1);

--
-- Acionadores `produto_ingrediente`
--
DELIMITER $$
CREATE TRIGGER `AtualizaDescricaoProduto_After_Delete` AFTER DELETE ON `produto_ingrediente` FOR EACH ROW BEGIN
    DECLARE ingredientes TEXT;
    
    SELECT COALESCE(GROUP_CONCAT(i.Nome SEPARATOR ', '), '') INTO ingredientes
    FROM Produto_Ingrediente pi
    JOIN Ingrediente i ON pi.Id_ingrediente = i.Id_ingrediente
    WHERE pi.Id_produto = OLD.Id_produto;
    
    UPDATE Produto
    SET Descricao = ingredientes
    WHERE Id_produto = OLD.Id_produto;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AtualizaDescricaoProduto_After_Insert` AFTER INSERT ON `produto_ingrediente` FOR EACH ROW BEGIN
    DECLARE ingredientes TEXT;
    
    SELECT COALESCE(GROUP_CONCAT(i.Nome SEPARATOR ', '), '') INTO ingredientes
    FROM Produto_Ingrediente pi
    JOIN Ingrediente i ON pi.Id_ingrediente = i.Id_ingrediente
    WHERE pi.Id_produto = NEW.Id_produto;
    
    UPDATE Produto
    SET Descricao = ingredientes
    WHERE Id_produto = NEW.Id_produto;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AtualizaStatusProduto` AFTER INSERT ON `produto_ingrediente` FOR EACH ROW BEGIN
    DECLARE produto_disponivel TINYINT(1);

    SELECT IF(COUNT(*) > 0, 0, 1)
    INTO produto_disponivel
    FROM produto_ingrediente pi
    JOIN ingrediente i ON pi.Id_Ingrediente = i.Id_Ingrediente
    WHERE pi.Id_Produto = NEW.Id_Produto AND i.Disponivel = 0;

    UPDATE produto
    SET Disponivel = produto_disponivel
    WHERE Id_Produto = NEW.Id_Produto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `Id_Usuario` int(11) NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Usuario` varchar(50) NOT NULL,
  `Senha` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`Id_Usuario`, `Nome`, `Usuario`, `Senha`) VALUES
(1, 'Rian', 'Rian', '123'),
(2, 'Carlos', 'Carlos', '1234');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`Id_Categoria`),
  ADD UNIQUE KEY `Nome` (`Nome`);

--
-- Índices de tabela `entregador`
--
ALTER TABLE `entregador`
  ADD PRIMARY KEY (`Id_entregador`);

--
-- Índices de tabela `frete`
--
ALTER TABLE `frete`
  ADD PRIMARY KEY (`Id_frete`);

--
-- Índices de tabela `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD PRIMARY KEY (`Id_ingrediente`);

--
-- Índices de tabela `pagamento`
--
ALTER TABLE `pagamento`
  ADD PRIMARY KEY (`Id_pagamento`);

--
-- Índices de tabela `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`Id_Pedido`),
  ADD KEY `Id_Entregador` (`Id_Entregador`),
  ADD KEY `Id_Frete` (`Id_Frete`),
  ADD KEY `Id_Pagamento` (`Id_Pagamento`);

--
-- Índices de tabela `pedido_item`
--
ALTER TABLE `pedido_item`
  ADD PRIMARY KEY (`Id_Item_Pedido`),
  ADD KEY `Id_Pedido` (`Id_Pedido`),
  ADD KEY `Id_Produto` (`Id_Produto`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`Id_Produto`),
  ADD KEY `Id_Categoria` (`Id_Categoria`);

--
-- Índices de tabela `produto_ingrediente`
--
ALTER TABLE `produto_ingrediente`
  ADD PRIMARY KEY (`Id_produto`,`Id_ingrediente`),
  ADD KEY `Id_ingrediente` (`Id_ingrediente`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`Id_Usuario`),
  ADD UNIQUE KEY `Usuario` (`Usuario`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `categoria`
--
ALTER TABLE `categoria`
  MODIFY `Id_Categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `entregador`
--
ALTER TABLE `entregador`
  MODIFY `Id_entregador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `frete`
--
ALTER TABLE `frete`
  MODIFY `Id_frete` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `ingrediente`
--
ALTER TABLE `ingrediente`
  MODIFY `Id_ingrediente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `pedido`
--
ALTER TABLE `pedido`
  MODIFY `Id_Pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `pedido_item`
--
ALTER TABLE `pedido_item`
  MODIFY `Id_Item_Pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `Id_Produto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `Id_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`Id_Entregador`) REFERENCES `entregador` (`Id_entregador`),
  ADD CONSTRAINT `pedido_ibfk_2` FOREIGN KEY (`Id_Frete`) REFERENCES `frete` (`Id_frete`),
  ADD CONSTRAINT `pedido_ibfk_3` FOREIGN KEY (`Id_Pagamento`) REFERENCES `pagamento` (`Id_pagamento`);

--
-- Restrições para tabelas `pedido_item`
--
ALTER TABLE `pedido_item`
  ADD CONSTRAINT `pedido_item_ibfk_1` FOREIGN KEY (`Id_Pedido`) REFERENCES `pedido` (`Id_Pedido`),
  ADD CONSTRAINT `pedido_item_ibfk_2` FOREIGN KEY (`Id_Produto`) REFERENCES `produto` (`Id_Produto`) ON DELETE CASCADE;

--
-- Restrições para tabelas `produto`
--
ALTER TABLE `produto`
  ADD CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`Id_Categoria`) REFERENCES `categoria` (`Id_Categoria`);

--
-- Restrições para tabelas `produto_ingrediente`
--
ALTER TABLE `produto_ingrediente`
  ADD CONSTRAINT `produto_ingrediente_ibfk_1` FOREIGN KEY (`Id_produto`) REFERENCES `produto` (`Id_Produto`),
  ADD CONSTRAINT `produto_ingrediente_ibfk_2` FOREIGN KEY (`Id_ingrediente`) REFERENCES `ingrediente` (`Id_ingrediente`) ON DELETE CASCADE;
--
-- Banco de dados: `farmacia`
--
CREATE DATABASE IF NOT EXISTS `farmacia` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `farmacia`;

-- --------------------------------------------------------

--
-- Estrutura para tabela `auditoria_vendas`
--

CREATE TABLE `auditoria_vendas` (
  `idregistro` int(11) NOT NULL,
  `idvenda` int(11) DEFAULT NULL,
  `nomevendedor` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `auditoria_vendas`
--

INSERT INTO `auditoria_vendas` (`idregistro`, `idvenda`, `nomevendedor`) VALUES
(1, 6, 'Pedro Costa'),
(2, 7, 'Luciana Pereira'),
(3, 8, 'Luciana Pereira');

-- --------------------------------------------------------

--
-- Estrutura para tabela `categoria`
--

CREATE TABLE `categoria` (
  `idcategoria` int(11) NOT NULL,
  `nomecategoria` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `categoria`
--

INSERT INTO `categoria` (`idcategoria`, `nomecategoria`) VALUES
(1, 'Medicamentos'),
(2, 'Suplementos'),
(3, 'Cosméticos'),
(4, 'Higiene e Beleza'),
(5, 'Produtos Naturais');

-- --------------------------------------------------------

--
-- Estrutura para tabela `clientes`
--

CREATE TABLE `clientes` (
  `idcliente` int(11) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `cpf` varchar(11) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefone` varchar(15) DEFAULT NULL,
  `endereco` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `clientes`
--

INSERT INTO `clientes` (`idcliente`, `nome`, `cpf`, `email`, `telefone`, `endereco`) VALUES
(1, 'José da Silva', '11122233344', 'jose@exemplo.com', '21912345678', 'Rua 1, 100, Rio de Janeiro'),
(2, 'Ana Maria Oliveira', '55566677788', 'ana@exemplo.com', '21923456789', 'Avenida 2, 200, São Paulo'),
(3, 'Carlos Alberto', '99988877766', 'carlos@exemplo.com', '21934567890', 'Rua 3, 300, Belo Horizonte');

-- --------------------------------------------------------

--
-- Estrutura para tabela `estoque`
--

CREATE TABLE `estoque` (
  `idmovimento` int(11) NOT NULL,
  `idproduto` int(11) DEFAULT NULL,
  `tipomovimento` enum('Entrada','Saída') DEFAULT NULL,
  `quantidade` int(11) DEFAULT NULL,
  `datamovimento` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `estoque`
--

INSERT INTO `estoque` (`idmovimento`, `idproduto`, `tipomovimento`, `quantidade`, `datamovimento`) VALUES
(1, 1, 'Saída', 1, '2024-11-28 20:13:10'),
(2, 3, 'Saída', 1, '2024-11-28 20:13:10'),
(3, 4, 'Saída', 2, '2024-11-28 20:13:10'),
(4, 2, 'Saída', 3, '2024-11-28 20:13:10'),
(5, 1, 'Entrada', 100, '2024-11-28 09:00:00'),
(6, 2, 'Entrada', 50, '2024-11-28 09:30:00'),
(7, 3, 'Entrada', 30, '2024-11-28 10:00:00'),
(8, 4, 'Saída', 5, '2024-11-28 11:00:00'),
(9, 5, 'Saída', 10, '2024-11-28 12:00:00'),
(10, 1, 'Saída', 3, '2024-11-28 20:19:29'),
(11, 2, 'Saída', 1, '2024-11-28 20:19:29'),
(12, 1, 'Saída', 2, '2024-11-28 20:19:29'),
(13, 2, 'Saída', 1, '2024-11-28 20:19:29');

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `estoque_atual`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `estoque_atual` (
`idproduto` int(11)
,`nome_produto` varchar(100)
,`quantidade_estoque` int(11)
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionario`
--

CREATE TABLE `funcionario` (
  `idfuncionario` int(11) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `cof` varchar(11) DEFAULT NULL,
  `cargo` varchar(50) DEFAULT NULL,
  `dataadmissao` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `funcionario`
--

INSERT INTO `funcionario` (`idfuncionario`, `nome`, `cof`, `cargo`, `dataadmissao`) VALUES
(1, 'Mariana Souza', '12345678901', 'Farmacêutica', '2020-06-15'),
(2, 'Pedro Costa', '23456789012', 'Vendedor', '2022-05-20'),
(3, 'Luciana Pereira', '34567890123', 'Atendente', '2023-01-10');

-- --------------------------------------------------------

--
-- Estrutura para tabela `itensvenda`
--

CREATE TABLE `itensvenda` (
  `iditemvenda` int(11) NOT NULL,
  `idvenda` int(11) DEFAULT NULL,
  `idproduto` int(11) DEFAULT NULL,
  `quantidade` int(11) DEFAULT NULL,
  `precounitario` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `itensvenda`
--

INSERT INTO `itensvenda` (`iditemvenda`, `idvenda`, `idproduto`, `quantidade`, `precounitario`) VALUES
(1, 1, 1, 1, 20.00),
(2, 1, 3, 1, 120.00),
(3, 2, 4, 2, 25.00),
(4, 3, 2, 3, 12.50),
(5, 1, 1, 3, 20.00),
(6, 1, 2, 1, 12.50),
(7, 2, 1, 2, 20.00),
(8, 2, 2, 1, 12.50);

--
-- Acionadores `itensvenda`
--
DELIMITER $$
CREATE TRIGGER `atualizaEstoque` AFTER INSERT ON `itensvenda` FOR EACH ROW BEGIN
    INSERT INTO estoque (idproduto, tipomovimento, quantidade, datamovimento)
    VALUES (NEW.idproduto, 'Saida', NEW.quantidade, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `atualizaValorVenda` AFTER UPDATE ON `itensvenda` FOR EACH ROW BEGIN
    DECLARE novo_valor DECIMAL(10, 2);

    SELECT SUM(precounitario * quantidade) INTO novo_valor
    FROM itensvenda
    WHERE idvenda = NEW.idvenda;

    UPDATE vendas
    SET valortotal = novo_valor
    WHERE idvenda = NEW.idvenda;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `produtomaisvendido`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `produtomaisvendido` (
`qtde` bigint(21)
,`nome` varchar(100)
);

-- --------------------------------------------------------

--
-- Estrutura para tabela `produtos`
--

CREATE TABLE `produtos` (
  `idproduto` int(11) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `descricao` text DEFAULT NULL,
  `precovenda` decimal(10,2) DEFAULT NULL,
  `estoqueminimo` int(11) DEFAULT NULL,
  `idcategoria` int(11) DEFAULT NULL,
  `estoqueatual` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produtos`
--

INSERT INTO `produtos` (`idproduto`, `nome`, `descricao`, `precovenda`, `estoqueminimo`, `idcategoria`, `estoqueatual`) VALUES
(1, 'Paracetamol', 'Medicamento analgésico e antitérmico', 20.00, 10, 1, 94),
(2, 'Aspirina', 'Medicamento analgésico e anti-inflamatório', 12.50, 15, 1, 45),
(3, 'Creatina', 'Suplemento para aumento de massa muscular', 120.00, 5, 2, 29),
(4, 'Shampoo Anticaspa', 'Shampoo para controle de caspa', 25.00, 20, 3, -7),
(5, 'Creme Hidratante', 'Creme para pele seca, 200g', 40.00, 8, 4, -10),
(6, 'Suco Detox', 'Suco natural para desintoxicação', 10.00, 30, 5, NULL);

--
-- Acionadores `produtos`
--
DELIMITER $$
CREATE TRIGGER `atualizaValorVendaItem` AFTER UPDATE ON `produtos` FOR EACH ROW BEGIN
    UPDATE itensvenda SET precounitario = NEW.precovenda
    WHERE idproduto = NEW.idproduto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL,
  `idfuncionario` int(11) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `senha` varchar(255) DEFAULT NULL,
  `tipousuario` enum('Administrador','Vendedor') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuario`
--

INSERT INTO `usuario` (`idusuario`, `idfuncionario`, `username`, `senha`, `tipousuario`) VALUES
(1, 1, 'mariana', 'senha123', 'Administrador'),
(2, 2, 'pedro', 'senha456', 'Vendedor'),
(3, 3, 'luciana', 'senha789', '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `vendas`
--

CREATE TABLE `vendas` (
  `idvenda` int(11) NOT NULL,
  `idcliente` int(11) DEFAULT NULL,
  `idfuncionario` int(11) DEFAULT NULL,
  `datavenda` datetime DEFAULT NULL,
  `valortotal` decimal(10,2) DEFAULT NULL,
  `nomevendedor` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `vendas`
--

INSERT INTO `vendas` (`idvenda`, `idcliente`, `idfuncionario`, `datavenda`, `valortotal`, `nomevendedor`) VALUES
(1, 1, 2, '2024-11-28 10:30:00', 212.50, NULL),
(2, 2, 3, '2024-11-28 11:00:00', 102.50, NULL),
(3, 3, 1, '2024-11-28 12:15:00', 37.50, NULL),
(6, 1, 2, '2024-11-28 10:30:00', 140.00, NULL),
(7, 2, 3, '2024-11-28 11:00:00', 120.00, NULL),
(8, 2, 3, '2024-11-28 11:00:00', 120.00, NULL);

--
-- Acionadores `vendas`
--
DELIMITER $$
CREATE TRIGGER `registraNomeVendedor` AFTER INSERT ON `vendas` FOR EACH ROW BEGIN
    DECLARE nome_vendedor VARCHAR(100);

    SELECT nome INTO nome_vendedor
    FROM funcionario
    WHERE idfuncionario = NEW.idfuncionario;

    INSERT INTO auditoria_vendas (idvenda, nomevendedor)
    VALUES (NEW.idvenda, nome_vendedor);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura stand-in para view `vendasdia`
-- (Veja abaixo para a visão atual)
--
CREATE TABLE `vendasdia` (
`idvenda` int(11)
,`idcliente` int(11)
,`idfuncionario` int(11)
,`datavenda` datetime
,`valortotal` decimal(10,2)
,`nomevendedor` varchar(100)
);

-- --------------------------------------------------------

--
-- Estrutura para view `estoque_atual`
--
DROP TABLE IF EXISTS `estoque_atual`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `estoque_atual`  AS SELECT `produtos`.`idproduto` AS `idproduto`, `produtos`.`nome` AS `nome_produto`, `produtos`.`estoqueatual` AS `quantidade_estoque` FROM `produtos` ;

-- --------------------------------------------------------

--
-- Estrutura para view `produtomaisvendido`
--
DROP TABLE IF EXISTS `produtomaisvendido`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `produtomaisvendido`  AS SELECT count(`vi`.`idproduto`) AS `qtde`, `p`.`nome` AS `nome` FROM (`itensvenda` `vi` join `produtos` `p` on(`p`.`idproduto` = `vi`.`idproduto`)) GROUP BY `vi`.`idproduto` ORDER BY count(`vi`.`idproduto`) DESC ;

-- --------------------------------------------------------

--
-- Estrutura para view `vendasdia`
--
DROP TABLE IF EXISTS `vendasdia`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vendasdia`  AS SELECT `vendas`.`idvenda` AS `idvenda`, `vendas`.`idcliente` AS `idcliente`, `vendas`.`idfuncionario` AS `idfuncionario`, `vendas`.`datavenda` AS `datavenda`, `vendas`.`valortotal` AS `valortotal`, `vendas`.`nomevendedor` AS `nomevendedor` FROM `vendas` WHERE cast(`vendas`.`datavenda` as date) = curdate() ;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `auditoria_vendas`
--
ALTER TABLE `auditoria_vendas`
  ADD PRIMARY KEY (`idregistro`),
  ADD KEY `idvenda` (`idvenda`);

--
-- Índices de tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`idcategoria`);

--
-- Índices de tabela `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`idcliente`),
  ADD UNIQUE KEY `cpf` (`cpf`);

--
-- Índices de tabela `estoque`
--
ALTER TABLE `estoque`
  ADD PRIMARY KEY (`idmovimento`),
  ADD KEY `idproduto` (`idproduto`);

--
-- Índices de tabela `funcionario`
--
ALTER TABLE `funcionario`
  ADD PRIMARY KEY (`idfuncionario`),
  ADD UNIQUE KEY `cof` (`cof`);

--
-- Índices de tabela `itensvenda`
--
ALTER TABLE `itensvenda`
  ADD PRIMARY KEY (`iditemvenda`),
  ADD KEY `idvenda` (`idvenda`),
  ADD KEY `idproduto` (`idproduto`);

--
-- Índices de tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`idproduto`),
  ADD KEY `idcategoria` (`idcategoria`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idusuario`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idfuncionario` (`idfuncionario`);

--
-- Índices de tabela `vendas`
--
ALTER TABLE `vendas`
  ADD PRIMARY KEY (`idvenda`),
  ADD KEY `idcliente` (`idcliente`),
  ADD KEY `idfuncionario` (`idfuncionario`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `auditoria_vendas`
--
ALTER TABLE `auditoria_vendas`
  MODIFY `idregistro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `categoria`
--
ALTER TABLE `categoria`
  MODIFY `idcategoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `clientes`
--
ALTER TABLE `clientes`
  MODIFY `idcliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `estoque`
--
ALTER TABLE `estoque`
  MODIFY `idmovimento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `funcionario`
--
ALTER TABLE `funcionario`
  MODIFY `idfuncionario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `itensvenda`
--
ALTER TABLE `itensvenda`
  MODIFY `iditemvenda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `idproduto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idusuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `vendas`
--
ALTER TABLE `vendas`
  MODIFY `idvenda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `auditoria_vendas`
--
ALTER TABLE `auditoria_vendas`
  ADD CONSTRAINT `auditoria_vendas_ibfk_1` FOREIGN KEY (`idvenda`) REFERENCES `vendas` (`idvenda`);

--
-- Restrições para tabelas `estoque`
--
ALTER TABLE `estoque`
  ADD CONSTRAINT `estoque_ibfk_1` FOREIGN KEY (`idproduto`) REFERENCES `produtos` (`idproduto`);

--
-- Restrições para tabelas `itensvenda`
--
ALTER TABLE `itensvenda`
  ADD CONSTRAINT `itensvenda_ibfk_1` FOREIGN KEY (`idvenda`) REFERENCES `vendas` (`idvenda`),
  ADD CONSTRAINT `itensvenda_ibfk_2` FOREIGN KEY (`idproduto`) REFERENCES `produtos` (`idproduto`);

--
-- Restrições para tabelas `produtos`
--
ALTER TABLE `produtos`
  ADD CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`idcategoria`) REFERENCES `categoria` (`idcategoria`);

--
-- Restrições para tabelas `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`idfuncionario`) REFERENCES `funcionario` (`idfuncionario`);

--
-- Restrições para tabelas `vendas`
--
ALTER TABLE `vendas`
  ADD CONSTRAINT `vendas_ibfk_1` FOREIGN KEY (`idcliente`) REFERENCES `clientes` (`idcliente`),
  ADD CONSTRAINT `vendas_ibfk_2` FOREIGN KEY (`idfuncionario`) REFERENCES `funcionario` (`idfuncionario`);
--
-- Banco de dados: `phpmyadmin`
--
CREATE DATABASE IF NOT EXISTS `phpmyadmin` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;
USE `phpmyadmin`;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__bookmark`
--

CREATE TABLE `pma__bookmark` (
  `id` int(10) UNSIGNED NOT NULL,
  `dbase` varchar(255) NOT NULL DEFAULT '',
  `user` varchar(255) NOT NULL DEFAULT '',
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `query` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Bookmarks';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__central_columns`
--

CREATE TABLE `pma__central_columns` (
  `db_name` varchar(64) NOT NULL,
  `col_name` varchar(64) NOT NULL,
  `col_type` varchar(64) NOT NULL,
  `col_length` text DEFAULT NULL,
  `col_collation` varchar(64) NOT NULL,
  `col_isNull` tinyint(1) NOT NULL,
  `col_extra` varchar(255) DEFAULT '',
  `col_default` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Central list of columns';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__column_info`
--

CREATE TABLE `pma__column_info` (
  `id` int(5) UNSIGNED NOT NULL,
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `column_name` varchar(64) NOT NULL DEFAULT '',
  `comment` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `mimetype` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `transformation` varchar(255) NOT NULL DEFAULT '',
  `transformation_options` varchar(255) NOT NULL DEFAULT '',
  `input_transformation` varchar(255) NOT NULL DEFAULT '',
  `input_transformation_options` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Column information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__designer_settings`
--

CREATE TABLE `pma__designer_settings` (
  `username` varchar(64) NOT NULL,
  `settings_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Settings related to Designer';

--
-- Despejando dados para a tabela `pma__designer_settings`
--

INSERT INTO `pma__designer_settings` (`username`, `settings_data`) VALUES
('root', '{\"angular_direct\":\"direct\",\"snap_to_grid\":\"off\",\"relation_lines\":\"true\"}');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__export_templates`
--

CREATE TABLE `pma__export_templates` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL,
  `export_type` varchar(10) NOT NULL,
  `template_name` varchar(64) NOT NULL,
  `template_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved export templates';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__favorite`
--

CREATE TABLE `pma__favorite` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Favorite tables';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__history`
--

CREATE TABLE `pma__history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db` varchar(64) NOT NULL DEFAULT '',
  `table` varchar(64) NOT NULL DEFAULT '',
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp(),
  `sqlquery` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='SQL history for phpMyAdmin';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__navigationhiding`
--

CREATE TABLE `pma__navigationhiding` (
  `username` varchar(64) NOT NULL,
  `item_name` varchar(64) NOT NULL,
  `item_type` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Hidden items of navigation tree';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__pdf_pages`
--

CREATE TABLE `pma__pdf_pages` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `page_nr` int(10) UNSIGNED NOT NULL,
  `page_descr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='PDF relation pages for phpMyAdmin';

--
-- Despejando dados para a tabela `pma__pdf_pages`
--

INSERT INTO `pma__pdf_pages` (`db_name`, `page_nr`, `page_descr`) VALUES
('farmacia', 1, 'Farmacia');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__recent`
--

CREATE TABLE `pma__recent` (
  `username` varchar(64) NOT NULL,
  `tables` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Recently accessed tables';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__relation`
--

CREATE TABLE `pma__relation` (
  `master_db` varchar(64) NOT NULL DEFAULT '',
  `master_table` varchar(64) NOT NULL DEFAULT '',
  `master_field` varchar(64) NOT NULL DEFAULT '',
  `foreign_db` varchar(64) NOT NULL DEFAULT '',
  `foreign_table` varchar(64) NOT NULL DEFAULT '',
  `foreign_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Relation table';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__savedsearches`
--

CREATE TABLE `pma__savedsearches` (
  `id` int(5) UNSIGNED NOT NULL,
  `username` varchar(64) NOT NULL DEFAULT '',
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `search_name` varchar(64) NOT NULL DEFAULT '',
  `search_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Saved searches';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__table_coords`
--

CREATE TABLE `pma__table_coords` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `pdf_page_number` int(11) NOT NULL DEFAULT 0,
  `x` float UNSIGNED NOT NULL DEFAULT 0,
  `y` float UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table coordinates for phpMyAdmin PDF output';

--
-- Despejando dados para a tabela `pma__table_coords`
--

INSERT INTO `pma__table_coords` (`db_name`, `table_name`, `pdf_page_number`, `x`, `y`) VALUES
('farmacia', 'categoria', 1, 455, 286),
('farmacia', 'clientes', 1, 131, 16),
('farmacia', 'estoque', 1, 865, 149),
('farmacia', 'funcionario', 1, 456, 411),
('farmacia', 'itensvenda', 1, 57, 232),
('farmacia', 'produtos', 1, 454, 26),
('farmacia', 'usuario', 1, 856, 394),
('farmacia', 'vendas', 1, 114, 434);

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__table_info`
--

CREATE TABLE `pma__table_info` (
  `db_name` varchar(64) NOT NULL DEFAULT '',
  `table_name` varchar(64) NOT NULL DEFAULT '',
  `display_field` varchar(64) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Table information for phpMyAdmin';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__table_uiprefs`
--

CREATE TABLE `pma__table_uiprefs` (
  `username` varchar(64) NOT NULL,
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `prefs` text NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Tables'' UI preferences';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__tracking`
--

CREATE TABLE `pma__tracking` (
  `db_name` varchar(64) NOT NULL,
  `table_name` varchar(64) NOT NULL,
  `version` int(10) UNSIGNED NOT NULL,
  `date_created` datetime NOT NULL,
  `date_updated` datetime NOT NULL,
  `schema_snapshot` text NOT NULL,
  `schema_sql` text DEFAULT NULL,
  `data_sql` longtext DEFAULT NULL,
  `tracking` set('UPDATE','REPLACE','INSERT','DELETE','TRUNCATE','CREATE DATABASE','ALTER DATABASE','DROP DATABASE','CREATE TABLE','ALTER TABLE','RENAME TABLE','DROP TABLE','CREATE INDEX','DROP INDEX','CREATE VIEW','ALTER VIEW','DROP VIEW') DEFAULT NULL,
  `tracking_active` int(1) UNSIGNED NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Database changes tracking for phpMyAdmin';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__userconfig`
--

CREATE TABLE `pma__userconfig` (
  `username` varchar(64) NOT NULL,
  `timevalue` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `config_data` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User preferences storage for phpMyAdmin';

--
-- Despejando dados para a tabela `pma__userconfig`
--

INSERT INTO `pma__userconfig` (`username`, `timevalue`, `config_data`) VALUES
('root', '2024-12-01 19:05:13', '{\"Console\\/Mode\":\"collapse\",\"lang\":\"pt_BR\"}');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__usergroups`
--

CREATE TABLE `pma__usergroups` (
  `usergroup` varchar(64) NOT NULL,
  `tab` varchar(64) NOT NULL,
  `allowed` enum('Y','N') NOT NULL DEFAULT 'N'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='User groups with configured menu items';

-- --------------------------------------------------------

--
-- Estrutura para tabela `pma__users`
--

CREATE TABLE `pma__users` (
  `username` varchar(64) NOT NULL,
  `usergroup` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='Users and their assignments to user groups';

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `pma__central_columns`
--
ALTER TABLE `pma__central_columns`
  ADD PRIMARY KEY (`db_name`,`col_name`);

--
-- Índices de tabela `pma__column_info`
--
ALTER TABLE `pma__column_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `db_name` (`db_name`,`table_name`,`column_name`);

--
-- Índices de tabela `pma__designer_settings`
--
ALTER TABLE `pma__designer_settings`
  ADD PRIMARY KEY (`username`);

--
-- Índices de tabela `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_user_type_template` (`username`,`export_type`,`template_name`);

--
-- Índices de tabela `pma__favorite`
--
ALTER TABLE `pma__favorite`
  ADD PRIMARY KEY (`username`);

--
-- Índices de tabela `pma__history`
--
ALTER TABLE `pma__history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`,`db`,`table`,`timevalue`);

--
-- Índices de tabela `pma__navigationhiding`
--
ALTER TABLE `pma__navigationhiding`
  ADD PRIMARY KEY (`username`,`item_name`,`item_type`,`db_name`,`table_name`);

--
-- Índices de tabela `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  ADD PRIMARY KEY (`page_nr`),
  ADD KEY `db_name` (`db_name`);

--
-- Índices de tabela `pma__recent`
--
ALTER TABLE `pma__recent`
  ADD PRIMARY KEY (`username`);

--
-- Índices de tabela `pma__relation`
--
ALTER TABLE `pma__relation`
  ADD PRIMARY KEY (`master_db`,`master_table`,`master_field`),
  ADD KEY `foreign_field` (`foreign_db`,`foreign_table`);

--
-- Índices de tabela `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `u_savedsearches_username_dbname` (`username`,`db_name`,`search_name`);

--
-- Índices de tabela `pma__table_coords`
--
ALTER TABLE `pma__table_coords`
  ADD PRIMARY KEY (`db_name`,`table_name`,`pdf_page_number`);

--
-- Índices de tabela `pma__table_info`
--
ALTER TABLE `pma__table_info`
  ADD PRIMARY KEY (`db_name`,`table_name`);

--
-- Índices de tabela `pma__table_uiprefs`
--
ALTER TABLE `pma__table_uiprefs`
  ADD PRIMARY KEY (`username`,`db_name`,`table_name`);

--
-- Índices de tabela `pma__tracking`
--
ALTER TABLE `pma__tracking`
  ADD PRIMARY KEY (`db_name`,`table_name`,`version`);

--
-- Índices de tabela `pma__userconfig`
--
ALTER TABLE `pma__userconfig`
  ADD PRIMARY KEY (`username`);

--
-- Índices de tabela `pma__usergroups`
--
ALTER TABLE `pma__usergroups`
  ADD PRIMARY KEY (`usergroup`,`tab`,`allowed`);

--
-- Índices de tabela `pma__users`
--
ALTER TABLE `pma__users`
  ADD PRIMARY KEY (`username`,`usergroup`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `pma__bookmark`
--
ALTER TABLE `pma__bookmark`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pma__column_info`
--
ALTER TABLE `pma__column_info`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pma__export_templates`
--
ALTER TABLE `pma__export_templates`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pma__history`
--
ALTER TABLE `pma__history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pma__pdf_pages`
--
ALTER TABLE `pma__pdf_pages`
  MODIFY `page_nr` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `pma__savedsearches`
--
ALTER TABLE `pma__savedsearches`
  MODIFY `id` int(5) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- Banco de dados: `test`
--
CREATE DATABASE IF NOT EXISTS `test` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `test`;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
