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

    public function cadastroProduto($nome, $preco, $disponivel, $categoria)
    {
        $sql = "INSERT INTO produto (nome, preco, disponivel, id_categoria) VALUES (:nome, :preco, :disponivel, :categoria)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':preco', $preco);
        $stmt->bindParam(':disponivel', $disponivel);
        $stmt->bindParam(':categoria', $categoria);
        
        if ($stmt->execute()) {
            //A função lastInsertId, de acordo com a documentação do PHP, tem como objetivo retornar o valor da última linha inserida.
            //Estava com problemas na hora de tentar cadastrar utilizando o auto-incrementy do banco.
            return $this->conexao->conectar()->lastInsertId();
        } else {
            return false;
        }
    }

    public function adicionaIngredienteProduto($id_produto, $id_ingrediente)
    {
        $sql = "INSERT INTO produto_Ingrediente (id_produto, id_ingrediente) VALUES (:id_produto, :id_ingrediente)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        $stmt->bindParam(':id_ingrediente', $id_ingrediente);
        return $stmt->execute();
    }

    public function atualizarStatusProduto($id_produto)
    {
        $sql = "SELECT i.disponivel FROM produto_ingrediente pi INNER JOIN ingrediente i ON pi.id_ingrediente = i.id_ingrediente WHERE pi.id_produto = :id_produto";
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
        $sql = "UPDATE produto SET status = 0 WHERE id_produto = :id_produto";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        return $stmt->execute();
    }

    public function produtoVerdadeiro($id_produto)
    {
        $sql = "UPDATE produto SET status = 1 WHERE id_produto = :id_produto";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        return $stmt->execute();
    }

    public function listaProduto()
    {
        $sql = "SELECT nome, descricao, preco FROM produto";
        $stmt = $this->conexao->conectar()->query($sql);
        return $stmt->fetchAll();
    }

    public function atualizaProduto($id, $nome, $preco)
    {
        $sql = "UPDATE produto SET nome = :nome, preco = :preco WHERE id_produto = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':preco', $preco);

        return $stmt->execute();
    }

    public function removeProduto($id)
    {
        $sql = "DELETE FROM produto WHERE id_produto = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        
        return $stmt->execute(); 
    }
}
?>
