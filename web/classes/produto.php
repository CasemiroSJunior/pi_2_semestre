<?php
require_once 'conexaoBanco.php';

class Produto
{
    private $conexao;

    public function __construct()
    {
        $this->conexao = new ConexaoBanco();    
    }

    public function __destruct()
    {
        $this->conexao = null;
    }

    //Método que retorna a categoria dos produtos
    public function obterCategoria()
    {
        // Preparando a consulta da categoria
        $sql = "SELECT ID_CATEGORIA, NOME FROM CATEGORIA";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->execute();

        // Retornando todas as categorias
        return $stmt->fetchAll();
    }

    //Método que retorna os produtos por categoria
    public function obterProdutoPorCategoria($categoriaId) 
    {
        $sql = "SELECT NOME, DESCRICAO, PRECO FROM PRODUTO WHERE ID_CATEGORIA = :categoriaId";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':categoriaId', $categoriaId); 
        $stmt->execute();

        return $stmt->fetchAll();
    }
}
?>
