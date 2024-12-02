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
        $sql = "insert into produto (nome, preco, disponivel, id_categoria) values (:nome, :preco, :disponivel, :categoria)";
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
        $sql = "insert into produto_ingrediente (id_produto, id_ingrediente) values (:id_produto, :id_ingrediente)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        $stmt->bindParam(':id_ingrediente', $id_ingrediente);
        return $stmt->execute();
    }

    public function atualizarStatusProduto($id_produto)
    {
    $sql = "
    select count(*) as totalindisponiveis
    from produto_ingrediente pi
    inner join ingrediente i on pi.id_ingrediente = i.id_ingrediente
    where pi.id_produto = :idproduto and i.disponivel = 0
    ";

    $stmt = $this->conexao->conectar()->prepare($sql);
    $stmt->bindParam(':idProduto', $id_produto, PDO::PARAM_INT);
    $stmt->execute();

    $indisponiveis = $stmt->fetchColumn();

    // Define a disponibilidade do produto baseado nos ingredientes
    $disponivel = ($indisponiveis == 0) ? 1 : 0;

    $sqlUpdate = "
    update produto
    set disponivel = :disponivel
    where id_produto = :idproduto
    ";

    $stmt = $this->conexao->conectar()->prepare($sqlUpdate);
    $stmt->bindParam(':disponivel', $disponivel, PDO::PARAM_INT);
    $stmt->bindParam(':idProduto', $id_produto, PDO::PARAM_INT);

    return $stmt->execute();
    }

    public function produtoFalso($id_produto)
    {
        $sql = "update produto set status = 0 where id_produto = :id_produto";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        return $stmt->execute();
    }

    public function produtoVerdadeiro($id_produto)
    {
        $sql = "update produto set status = 1 where id_produto = :id_produto";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id_produto', $id_produto);
        return $stmt->execute();
    }

    public function listaProduto()
    {
        $sql = "select p.nome, p.descricao, p.preco, p.id_produto, c.nome as categoria
        from produto p
        inner join categoria c on p.id_categoria = c.id_categoria";
        $stmt = $this->conexao->conectar()->query($sql);
        return $stmt->fetchAll();
    }


    public function atualizaProduto($id, $nome, $preco)
    {
        $sql = "update produto set nome = :nome, preco = :preco where id_produto = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':preco', $preco);

        return $stmt->execute();
    }

    public function removeProduto($id)
    {
        $sql = "delete from produto where id_produto = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);
        
        return $stmt->execute(); 
    }
}
?>
