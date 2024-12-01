<?php
require './classes/autenticacao.php';

$validador = new autenticacaoLogin();
$validador->verificaLogado();
?>