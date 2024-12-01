
<?php
require './classes/autenticacao.php';
$validador = new autenticacaoLogin();
$validador->verificaLogado();
$content = 'ingredientesContent.php';
include './components/layout.php';
?>