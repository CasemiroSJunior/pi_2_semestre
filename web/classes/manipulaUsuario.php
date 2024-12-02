<?php
require_once 'conexaoBanco.php';

class manipulaUsuario
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

    public function cadastroUsuario($nome, $usuario, $senha)
    {
        
        $sql = "insert into usuario (nome, usuario, senha) values (:nome, :usuario, :senha)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':usuario', $usuario);
        $stmt->bindParam(':senha', $senha);

        return $stmt->execute(); 
    }

    public function listaUsuario()
    {
        $sql = "select * from usuario";
        $stmt = $this->conexao->conectar()->query($sql);
        return $stmt->fetchAll();
    }

    public function atualizaUsuario($id, $nome, $usuario, $senha)
    {
        if ($senha) {
            $sql = "update usuario set nome = :nome, usuario = :usuario, senha = :senha where id_usuario = :id";
            $stmt = $this->conexao->conectar()->prepare($sql);
            $stmt->bindParam(':senha', $senha);
        } else {
            
            $sql = "update usuario set nome = :nome, usuario = :usuario where id_usuario = :id";
            $stmt = $this->conexao->conectar()->prepare($sql);
        }

        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':usuario', $usuario);

        return $stmt->execute();
    }

    public function removeUsuario($id)
    {
        $sql = "delete from usuario where id_usuario = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);

        return $stmt->execute(); 
    }
}
?>
