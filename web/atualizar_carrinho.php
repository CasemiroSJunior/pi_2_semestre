<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Nome do item enviado via formulário
    $nome = $_POST['nome'];
    $novaQuantidade = (int)$_POST['quantidade'];

    // Recupera o carrinho existente
    $carrinho = isset($_COOKIE['carrinho']) ? json_decode($_COOKIE['carrinho'], true) : [];

    // Atualiza a quantidade do item, se ele existir
    foreach ($carrinho as &$item) {
        if ($item['nome'] === $nome) {
            if ($novaQuantidade > 0) {
                $item['quantidade'] = $novaQuantidade;
            } else {
                // Remove o item se a quantidade for zerada
                $carrinho = array_filter($carrinho, fn($i) => $i['nome'] !== $nome);
            }
            break;
        }
    }

    // Atualiza o cookie do carrinho
    setcookie('carrinho', json_encode($carrinho), time() + (7 * 24 * 60 * 60), '/');

    // Redireciona de volta para o carrinho ou retorna uma resposta
    header('Location: carrinho.php');
    exit;
}
?>
