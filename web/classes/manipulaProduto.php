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
        $sql = "INSERT INTO produto (Nome, Preco, Disponivel, ID_Categoria) VALUES (:nome, :preco, :disponivel, :categoria)";
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
        $sql = "INSERT INTO Produto_Ingrediente (id_produto, id_ingrediente) VALUES (:id_produto, :id_ingrediente)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        $stmt->bindParam(':id_ingrediente', $id_ingrediente);
        return $stmt->execute();
    }

    public function atualizarStatusProduto($id_produto)
    {
    $sql = "
    SELECT COUNT(*) AS totalIndisponiveis
    FROM Produto_Ingrediente pi
    INNER JOIN Ingrediente i ON pi.Id_Ingrediente = i.Id_Ingrediente
    WHERE pi.Id_Produto = :idProduto AND i.Disponivel = 0
    ";

    $stmt = $pdo->prepare($sql);
    $stmt->bindParam(':idProduto', $id_produto, PDO::PARAM_INT);
    $stmt->execute();

    $indisponiveis = $stmt->fetchColumn();

    // Define a disponibilidade do produto baseado nos ingredientes
    $disponivel = ($indisponiveis == 0) ? 1 : 0;

    $sqlUpdate = "
    UPDATE Produto
    SET Disponivel = :disponivel
    WHERE Id_Produto = :idProduto
    ";

    $stmt = $pdo->prepare($sqlUpdate);
    $stmt->bindParam(':disponivel', $disponivel, PDO::PARAM_INT);
    $stmt->bindParam(':idProduto', $id_produto, PDO::PARAM_INT);

    return $stmt->execute();
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
        $sql = "SELECT p.Nome, p.Descricao, p.Preco, p.Id_Produto, c.NOME AS Categoria
        FROM Produto p
        INNER JOIN Categoria c ON p.Id_Categoria = c.ID_CATEGORIA";
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
