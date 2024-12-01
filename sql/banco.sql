-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05/11/2024 às 15:09
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.0.30

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

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GerarRelatorioProdutos` ()   BEGIN
    SELECT 
        p.Id_Produto as Codigo,
        p.Nome as Nome,  
        p.Descricao as Descricao,
        p.Preco as PrecoVenda
    FROM 
        produto p
    WHERE
        disponivel = 1;
END$$


CREATE DEFINER=`root`@`localhost` PROCEDURE `GerarRelatorioVendasPorEntregador` ()   BEGIN
    SELECT 
        e.Nome AS Nome_Entregador,
        COALESCE(COUNT(pi.Id_Item_Pedido), 0) AS Total_Vendas,  -- Conta o número total de itens pedidos, retornando 0 se não houver
        COALESCE(SUM(pi.Quantidade * pi.ValorUnitario), 0) AS Valor_Total  -- Soma do valor total, retornando 0 se não houver
    FROM 
        Entregador e
    LEFT JOIN 
        Pedido p ON e.Id_Entregador = p.Id_Entregador
    LEFT JOIN 
        Pedido_Item pi ON p.Id_Pedido = pi.Id_Pedido
    GROUP BY 
        e.Id_Entregador;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ObterTop10PizzasMaisVendidas` (IN `categoria_param` INT)   BEGIN
    SELECT 
        p.Nome AS Nome_Pizza,
        SUM(vi.Quantidade) AS Total_Vendas,
        SUM(vi.Quantidade * vi.ValorUnitario) AS Valor_Total
    FROM 
        Produto p
    JOIN 
        Pedido_Item vi ON p.Id_Produto = vi.Id_Produto
    JOIN 
        Pedido v ON vi.Id_Pedido = v.Id_Pedido
    WHERE 
        p.Id_Categoria = categoria_param  
    GROUP BY 
        p.Id_Produto
    ORDER BY 
        Total_Vendas DESC
    LIMIT 10;
END$$

DELIMITER ;

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
(3, 'Orégano', 1),
(4, 'Pepperoni', 1),
(5, 'Cebola', 0);

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
(8, 2, 2, 'Pizza de Chocolate', 'Cobertura de chocolate ao leite e granulado', 35.00, 1),
(9, 3, 4, 'Brownie', 'Brownie de chocolate com pedaços de nozes', 8.00, 3),
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
(1, 'Pizza Margherita', '2024-11-05', 30.00, 'Molho de tomate, mussarela e manjericão', 1, 1),
(2, 'Pizza de Chocolate', '2024-11-05', 35.00, 'Cobertura de chocolate ao leite e granulado', 1, 2),
(3, 'Refrigerante 2L', '2024-11-05', 10.00, 'Refrigerante de cola 2L', 1, 3),
(4, 'Brownie', '2024-11-05', 8.00, 'Brownie de chocolate com pedaços de nozes', 1, 4),
(5, 'Pizza Pepperoni', '2024-11-05', 40.00, 'Molho de tomate, mussarela e pepperoni', 0, 1);

-- --------------------------------------------------------

--
-- Estrutura para tabela `produto_ingrediente`
--

CREATE TABLE `produto_ingrediente` (
  `Id_produto` int(11) NOT NULL,
  `Id_ingrediente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  MODIFY `Id_Produto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `Id_Usuario` int(11) NOT NULL AUTO_INCREMENT;

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
  ADD CONSTRAINT `pedido_item_ibfk_2` FOREIGN KEY (`Id_Produto`) REFERENCES `produto` (`Id_Produto`);

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
  ADD CONSTRAINT `produto_ingrediente_ibfk_2` FOREIGN KEY (`Id_ingrediente`) REFERENCES `ingrediente` (`Id_ingrediente`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
