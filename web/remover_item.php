<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Nome do item enviado via formulário
    $nome = $_POST['nome'];

    // Recupera o carrinho existente
    $carrinho = isset($_COOKIE['carrinho']) ? json_decode($_COOKIE['carrinho'], true) : [];

    // Remove o item do carrinho
    $carrinho = array_filter($carrinho, fn($item) => $item['nome'] !== $nome);

    // Atualiza o cookie do carrinho
    setcookie('carrinho', json_encode($carrinho), time() + (7 * 24 * 60 * 60), '/');

    // Redireciona de volta para o carrinho ou retorna uma resposta
    header('Location: carrinho.php');
    exit;
}
?>
