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
        $sql = "select id_categoria, nome from categoria";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->execute();

        // Retornando todas as categorias
        return $stmt->fetchAll();
    }

    //Método que retorna os produtos por categoria
    public function obterProdutoPorCategoria($categoriaid) 
    {
        $sql = "select nome, descricao, preco from produto where id_categoria = :categoriaid";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindparam(':categoriaid', $categoriaid); 
        $stmt->execute();

        return $stmt->fetchAll();
    }
}
?>
