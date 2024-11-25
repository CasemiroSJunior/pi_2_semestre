<?php

class conexaoBanco
{
    // Setando atributos da base de dados
    private $host = "localhost";
    private $dbname = "banco";
    private $username = "root";
    private $password = "";
    private $conexao;

    // Método responsável por estabelecer a conexão com a base de dados
    public function conectar()
    {
        if ($this->conexao === null)
        {
            try
            {
                $this->conexao = new PDO("mysql:host={$this->host};dbname={$this->dbname}",
                $this->username,
                $this->password
                );
            }
            catch (PDOException $e)
            {
                echo "Erro na conexão: " . $e->getMessage();
                exit; 
            }
        }
        return $this->conexao; 
    }
}
?>
