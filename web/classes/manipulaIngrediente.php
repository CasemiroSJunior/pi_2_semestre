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
        $sql = "insert into ingrediente (nome, disponivel) values (:nome, :disponivel)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':disponivel', $disponivel);

        return $stmt->execute(); 
    }

    public function listaIngrediente()
    {
        $sql = "select * from ingrediente";
        $stmt = $this->conexao->conectar()->query($sql);
        return $stmt->fetchAll();
    }

    public function atualizaIngrediente($id, $nome, $disponivel)
    {
        $sql = "update ingrediente set nome = :nome, disponivel = :disponivel where id_ingrediente = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':disponivel', $disponivel);

        return $stmt->execute();
    }

    public function removeIngrediente($id)
    {
        $sql = "delete from ingrediente where id_ingrediente = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        
        return $stmt->execute(); 
    }
}
?>
