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
        
        $sql = "INSERT INTO usuario (Nome, Usuario, Senha) VALUES (:nome, :usuario, :senha)";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':usuario', $usuario);
        $stmt->bindParam(':senha', $senha);

        return $stmt->execute(); 
    }

    public function listaUsuario()
    {
        $sql = "SELECT * FROM usuario";
        $stmt = $this->conexao->conectar()->query($sql);
        return $stmt->fetchAll();
    }

    public function atualizaUsuario($id, $nome, $usuario, $senha)
    {
        if ($senha) {
            $sql = "UPDATE usuario SET Nome = :nome, Usuario = :usuario, Senha = :senha WHERE Id_Usuario = :id";
            $stmt = $this->conexao->conectar()->prepare($sql);
            $stmt->bindParam(':senha', $senha);
        } else {
            
            $sql = "UPDATE usuario SET Nome = :nome, Usuario = :usuario WHERE Id_Usuario = :id";
            $stmt = $this->conexao->conectar()->prepare($sql);
        }

        $stmt->bindParam(':id', $id);
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':usuario', $usuario);

        return $stmt->execute();
    }

    public function removeUsuario($id)
    {
        $sql = "DELETE FROM usuario WHERE Id_Usuario = :id";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':id', $id);

        return $stmt->execute(); 
    }
}
?>
