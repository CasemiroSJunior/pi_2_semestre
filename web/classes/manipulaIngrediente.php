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
        $sql = "INSERT INTO ingrediente (nome, disponivel) VALUES (:nome, :disponivel)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':disponivel', $disponivel);

        return $stmt->execute(); 
    }

    public function listaIngrediente()
    {
        $sql = "SELECT * FROM ingrediente";
        $stmt = $this->conexao->conectar()->query($sql);
        return $stmt->fetchAll();
    }

    public function atualizaIngrediente($id, $nome, $disponivel)
    {
        $sql = "UPDATE ingrediente SET nome = :nome, disponivel = :disponivel WHERE id_ingrediente = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':disponivel', $disponivel);

        return $stmt->execute();
    }

    public function removeIngrediente($id)
    {
        $sql = "DELETE FROM ingrediente WHERE id_ingrediente = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        
        return $stmt->execute(); 
    }
}
?>
