<?php

require "./vendor/autoload.php";

class dotEnvCredentials{
    public function load(){
        $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
        $dotenv->load();
    }

    public function getHost(){
        return $_ENV['host'];
    }

    public function getDbname(){
        return $_ENV['dbname'];
    }

    public function getUsername(){
        return $_ENV['username'];
    }

    public function getPassword(){
        return $_ENV['password'];
    }

}



?>