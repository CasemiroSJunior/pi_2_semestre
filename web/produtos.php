
<?php
require './classes/autenticacao.php';
$validador = new autenticacaoLogin();
$validador->verificaLogado();
$content = 'produtosContent.php';
include './components/layout.php';
?>