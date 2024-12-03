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

    public function adicionaIngredienteProduto($id_produto, $id_ingrediente){
         $sql = "insert into produto_ingrediente (id_produto, id_ingrediente) values (:id_produto, :id_ingrediente)";
     try{
         $stmt = $this->conexao->conectar()->prepare($sql);
         $stmt->bindParam(':id_produto', $id_produto);
         $stmt->bindParam(':id_ingrediente', $id_ingrediente);
         return $stmt->execute();
     }catch (Exception $e) {
         echo '<script>alert("Ingrediente já cadastrado")</script>';
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
