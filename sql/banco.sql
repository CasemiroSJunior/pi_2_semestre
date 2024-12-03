-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 03/12/2024 às 00:44
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
(7, 'Farinha', 1),
(8, 'Tomate', 1),
(9, 'Cebola', 0),
(10, 'Calabresa', 1);

--
-- Acionadores `ingrediente`
--
DELIMITER $$
CREATE TRIGGER `AtualizaStatusProdutoUpdate` AFTER UPDATE ON `ingrediente` FOR EACH ROW BEGIN
    IF OLD.Disponivel != NEW.Disponivel THEN
        -- Atualiza o status do produto que usa o ingrediente para refletir o novo status
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
(8, 'Pizza Calabresa', '2024-12-02', 40.00, 'Farinha, Tomate, Cebola, Calabresa', 0, 1);

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
(8, 7, 1),
(8, 8, 1),
(8, 9, 1),
(8, 10, 1);

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
    -- Verifica se algum ingrediente associado ao produto tem Disponivel = 0
    DECLARE produto_disponivel TINYINT(1);

    -- Verifica se algum ingrediente do produto é indisponível (Disponivel = 0)
    SELECT IF(COUNT(*) > 0, 0, 1)
    INTO produto_disponivel
    FROM produto_ingrediente pi
    JOIN ingrediente i ON pi.Id_Ingrediente = i.Id_Ingrediente
    WHERE pi.Id_Produto = NEW.Id_Produto AND i.Disponivel = 0;

    -- Atualiza o campo Disponivel do produto
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
(3, 'teste', 'teste', 'teste');

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
  MODIFY `Id_ingrediente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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
  MODIFY `Id_Produto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `Id_Usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
