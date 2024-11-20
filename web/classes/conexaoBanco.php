<?php
require_once "./dotenvLoader.php";

class conexaoBanco extends dotEnvCredentials
{
    // Setando atributos da base de dados
    private $conexao;

    // Método responsável por estabelecer a conexão com a base de dados
    public function conectar()
    {
        // Obtendo os dados do arquivo .env
        $this->load();
        $host = $this->getHost();
        $dbname = $this->getDbname();
        $username = $this->getUsername();
        $password = $this->getPassword();

        if ($this->conexao === null)
        {
            try
            {
                
                $this->conexao = new PDO("mysql:host={$host};dbname={$dbname}",
                $username,
                $password
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
