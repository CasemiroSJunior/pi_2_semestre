<?php
require_once 'conexaoBanco.php';
class manipulaProduto
{
    private $conexao;

    public function __construct()
    {
        $this->conexao = new conexaoBanco();
    }

    public function __destruct()
    {
        $this->conexao = null;
    }

    public function cadastroProduto($nome, $descricao, $preco, $disponivel)
    {
        $sql = "INSERT INTO produto (Nome, Descricao, Preco, Disponivel) VALUES (:nome, :descricao, :preco, 1)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':descricao', $descricao);
        $stmt->bindParam(':preco', $preco);

        return $stmt->execute(); 
    }

    public function adicionaIngredienteProduto($id_produto, $id_ingrediente)
    {
        $sql = "INSERT INTO Produto_Ingrediente (id_produto, id_ingrediente) VALUES (:id_produto, :id_ingrediente)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        $stmt->bindParam(':id_ingrediente', $id_ingrediente);
        return $stmt->execute();
    }

    public function atualizarStatusProduto($id_produto)
    {
        $sql = "SELECT i.disponivel FROM Produto_Ingrediente pi INNER JOIN Ingrediente i ON pi.id_ingrediente = i.id_ingrediente WHERE pi.id_produto = :id_produto";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        $stmt->execute();

        $ingredientes = $stmt->fetchAll();

        foreach ($ingredientes as $ingrediente) 
        {
            if ($ingrediente['disponivel'] == 0) 
            {
                $this->produtoFalso($id_produto);
                return;
            }
        }
        $this->produtoVerdadeiro($id_produto);
    }

    public function produtoFalso($id_produto)
    {
        $sql = "UPDATE Produto SET status = 0 WHERE id_produto = :id_produto";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        return $stmt->execute();
    }

    public function produtoVerdadeiro($id_produto)
    {
        $sql = "UPDATE Produto SET status = 1 WHERE id_produto = :id_produto";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        return $stmt->execute();
    }

    public function listaProduto()
    {
        $sql = "SELECT Nome, Descricao, Preco FROM Produto";
        $stmt = $this->conexao->conectar()->query($sql);
        return $stmt->fetchAll();
    }

    public function atualizaProduto($id, $nome, $preco)
    {
        $sql = "UPDATE Produto SET Nome = :nome, Preco = :preco WHERE Id_Produto = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':preco', $preco);

        return $stmt->execute();
    }

    public function removeProduto($id)
    {
        $sql = "DELETE FROM Produto WHERE Id_produto = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        
        return $stmt->execute(); 
    }
}
?>
