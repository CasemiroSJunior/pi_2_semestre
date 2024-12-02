<?php
require_once 'conexaoBanco.php';
session_start();
class autenticacaoLogin
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

    //Funcao retorna true caso de certo, false caso de errado.
    public function login($username, $password)
    {
        //Criando consulta no banco de dados responsavel por pegar a senha de acordo com o usuario passado no forms.
        $sql = "select senha from usuario where usuario = :username";
        $stmt = $this->conexao->conectar()->prepare($sql);
        $stmt->bindParam(':username', $username);

        $stmt->execute();

        // Obtem a senha armazenada com base na coluna retornada
        $senhaArmazenada = $stmt->fetchColumn();

        //Verifica se o banco possuí registros de senha salvo
        //Se não existir quebra a execução
        if ($senhaArmazenada === false) 
        {
            return false;
        }

        if ($password === $senhaArmazenada) 
        { 
            //Login deu bom
            $_SESSION["logado"] = TRUE;
            $_SESSION["username"] = $username;
            return true;
        } 
        else 
        {
            //Senha errada
            return false;
        }
    }
    
    //Funcao responsavel por redirecionar o usuário caso o login tenha dado certo! Caso de errado um aviso é mostrado na tela
    public function verificaLogin($username, $password) 
    {
        if ($this->login($username, $password) === true) 
        {
            header('Location: menu.php');
        } 
        else 
        {   
            header('Location: login.php');
            echo '<script>
                alert("Usuário ou senha incorretos!");
            </script>';
        }
    }

    public function verificaLogado() 
    { 
        if ($_SESSION["logado"]) {
            return TRUE;
        }
        $this->logout();
    } 

    public function logout() 
    { 
        session_destroy();
        header("Location: login.php");
        exit();
    } 
}
