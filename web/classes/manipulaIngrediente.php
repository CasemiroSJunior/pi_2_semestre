<?php
require_once 'conexaoBanco.php';
class manipulaIngrediente
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

    public function cadastroIngrediente($nome, $disponivel)
    {
        $sql = "INSERT INTO Ingrediente (Nome, Disponivel) VALUES (:nome, :disponivel)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':disponivel', $disponivel);

        return $stmt->execute(); 
    }

    public function listaIngrediente()
    {
        $sql = "SELECT * FROM Ingrediente";
        $stmt = $this->conexao->conectar()->query($sql);
        return $stmt->fetchAll();
    }

    public function atualizaIngrediente($id, $nome, $disponivel)
    {
        $sql = "UPDATE Ingrediente SET Nome = :nome, Disponivel = :disponivel WHERE Id_ingrediente = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':disponivel', $disponivel);

        return $stmt->execute();
    }

    public function removeIngrediente($id)
    {
        $sql = "DELETE FROM Ingrediente WHERE Id_ingrediente = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        
        return $stmt->execute(); 
    }
}
?>
