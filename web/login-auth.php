<?php 
    require './classes/autenticacao.php';

    $username = $_POST['username'];
    $password = $_POST['password'];

    $auth = new autenticacaoLogin();

    $auth->verificaLogin($username, $password);

?>