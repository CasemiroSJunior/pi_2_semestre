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
  `id_categoria` int(11) NOT NULL,
  `nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `categoria`
--

INSERT INTO `categoria` (`id_categoria`, `nome`) VALUES
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
  `id_entregador` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `dataCriacao` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `entregador`
--

INSERT INTO `entregador` (`id_entregador`, `nome`, `telefone`, `dataCriacao`) VALUES
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
  `id_frete` int(11) NOT NULL,
  `distanciaKm` decimal(5,2) NOT NULL,
  `preco` decimal(10,4) NOT NULL,
  `dataCriacao` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `frete`
--

INSERT INTO `frete` (`id_frete`, `distanciaKm`, `preco`, `dataCriacao`) VALUES
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
  `id_ingrediente` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `disponivel` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `ingrediente`
--

INSERT INTO `ingrediente` (`id_ingrediente`, `nome`, `disponivel`) VALUES
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
  `id_pagamento` int(11) NOT NULL,
  `descricao` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pagamento`
--

INSERT INTO `pagamento` (`id_pagamento`, `descricao`) VALUES
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
  `id_pedido` int(11) NOT NULL,
  `id_entregador` int(11) DEFAULT NULL,
  `id_frete` int(11) NOT NULL,
  `id_pagamento` int(11) NOT NULL,
  `dataVenda` date DEFAULT curdate(),
  `valorFrete` decimal(10,2) NOT NULL DEFAULT 0.00,
  `entrega` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedido`
--

INSERT INTO `pedido` (`id_pedido`, `id_entregador`, `id_frete`, `id_pagamento`, `dataVenda`, `valorFrete`, `entrega`) VALUES
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
  `id_item_pedido` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_produto` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `valorUnitario` decimal(10,2) NOT NULL,
  `quantidade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedido_item`
--

INSERT INTO `pedido_item` (`id_item_pedido`, `id_pedido`, `id_produto`, `nome`, `descricao`, `valorUnitario`, `quantidade`) VALUES
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
  `id_produto` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `dataCriacao` date DEFAULT curdate(),
  `preco` decimal(10,2) NOT NULL,
  `descricao` text DEFAULT NULL,
  `disponivel` tinyint(1) DEFAULT 1,
  `id_categoria` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produto`
--

INSERT INTO `produto` (`id_produto`, `nome`, `dataCriacao`, `preco`, `descricao`, `disponivel`, `id_categoria`) VALUES
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
  `id_produto` int(11) NOT NULL,
  `id_ingrediente` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `produto_ingrediente`
--
DELIMITER $$
CREATE TRIGGER `AtualizaDescricaoProduto_After_Delete` AFTER DELETE ON `produto_ingrediente` FOR EACH ROW BEGIN
    DECLARE ingredientes TEXT;
    
    SELECT COALESCE(GROUP_CONCAT(i.nome SEPARATOR ', '), '') INTO ingredientes
    FROM produto_ingrediente pi
    JOIN ingrediente i ON pi.id_ingrediente = i.id_ingrediente
    WHERE pi.id_produto = OLD.id_produto;
    
    UPDATE produto
    SET descricao = ingredientes
    WHERE id_produto = OLD.id_produto;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `AtualizaDescricaoProduto_After_Insert` AFTER INSERT ON `produto_ingrediente` FOR EACH ROW BEGIN
    DECLARE ingredientes TEXT;
    
    SELECT COALESCE(GROUP_CONCAT(i.Nome SEPARATOR ', '), '') INTO ingredientes
    FROM produto_ingrediente pi
    JOIN ingrediente i ON pi.id_ingrediente = i.id_ingrediente
    WHERE pi.id_produto = NEW.id_produto;
    
    UPDATE produto
    SET descricao = ingredientes
    WHERE id_produto = NEW.id_produto;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `usuario` varchar(50) NOT NULL,
  `senha` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`id_categoria`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Índices de tabela `entregador`
--
ALTER TABLE `entregador`
  ADD PRIMARY KEY (`id_entregador`);

--
-- Índices de tabela `frete`
--
ALTER TABLE `frete`
  ADD PRIMARY KEY (`id_frete`);

--
-- Índices de tabela `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD PRIMARY KEY (`id_ingrediente`);

--
-- Índices de tabela `pagamento`
--
ALTER TABLE `pagamento`
  ADD PRIMARY KEY (`id_pagamento`);

--
-- Índices de tabela `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `id_dntregador` (`id_entregador`),
  ADD KEY `id_frete` (`id_frete`),
  ADD KEY `id_pagamento` (`id_pagamento`);

--
-- Índices de tabela `pedido_item`
--
ALTER TABLE `pedido_item`
  ADD PRIMARY KEY (`id_item_pedido`),
  ADD KEY `id_pedido` (`id_pedido`),
  ADD KEY `id_produto` (`id_produto`);

--
-- Índices de tabela `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`id_produto`),
  ADD KEY `id_categoria` (`id_categoria`);

--
-- Índices de tabela `produto_ingrediente`
--
ALTER TABLE `produto_ingrediente`
  ADD PRIMARY KEY (`id_produto`,`id_ingrediente`),
  ADD KEY `id_ingrediente` (`id_ingrediente`);

--
-- Índices de tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `categoria`
--
ALTER TABLE `categoria`
  MODIFY `id_Categoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `entregador`
--
ALTER TABLE `entregador`
  MODIFY `id_entregador` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `frete`
--
ALTER TABLE `frete`
  MODIFY `id_frete` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `ingrediente`
--
ALTER TABLE `ingrediente`
  MODIFY `id_ingrediente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `pedido`
--
ALTER TABLE `pedido`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `pedido_item`
--
ALTER TABLE `pedido_item`
  MODIFY `id_item_pedido` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `produto`
--
ALTER TABLE `produto`
  MODIFY `id_produto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_Usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`id_entregador`) REFERENCES `entregador` (`id_entregador`),
  ADD CONSTRAINT `pedido_ibfk_2` FOREIGN KEY (`id_frete`) REFERENCES `frete` (`id_frete`),
  ADD CONSTRAINT `pedido_ibfk_3` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamento` (`id_pagamento`);

--
-- Restrições para tabelas `pedido_item`
--
ALTER TABLE `pedido_item`
  ADD CONSTRAINT `pedido_item_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id_pedido`),
  ADD CONSTRAINT `pedido_item_ibfk_2` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`);

--
-- Restrições para tabelas `produto`
--
ALTER TABLE `produto`
  ADD CONSTRAINT `produto_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`);

--
-- Restrições para tabelas `produto_ingrediente`
--
ALTER TABLE `produto_ingrediente`
  ADD CONSTRAINT `produto_ingrediente_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produto` (`id_produto`),
  ADD CONSTRAINT `produto_ingrediente_ibfk_2` FOREIGN KEY (`id_ingrediente`) REFERENCES `ingrediente` (`id_ingrediente`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
