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
}    
?>    