<?php
require './classes/autenticacao.php';
$validador = new autenticacaoLogin();
$validador->verificaLogado();

$content = './components/menuContent.php';
include './components/layout.php';
?>