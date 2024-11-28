<?php 
    require './classes/autenticacao.php';
    
    $auth = new autenticacaoLogin();

    $auth->logout();

?>