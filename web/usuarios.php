<?php
require './classes/autenticacao.php';
$validador = new autenticacaoLogin();
$validador->verificaLogado();
$content = 'usuariosContent.php';
include './components/layout.php';
?>