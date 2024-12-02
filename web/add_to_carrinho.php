<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Dados do produto enviado via formulário
    $nome = $_POST['nome'];
    $preco = $_POST['preco'];
    $quantidade = (int)$_POST['quantidade'];

    // Recupera o carrinho existente
    $carrinho = isset($_COOKIE['carrinho']) ? json_decode($_COOKIE['carrinho'], true) : [];

    // Verifica se o item já existe no carrinho
    $itemExiste = false;
    foreach ($carrinho as &$item) {
        if ($item['nome'] === $nome) {
            // Atualiza a quantidade do item existente
            $item['quantidade'] += $quantidade;
            $itemExiste = true;
            break;
        }
    }

    // Se o item não existir, adiciona como novo
    if (!$itemExiste) {
        $carrinho[] = [
            'nome' => $nome,
            'preco' => $preco,
            'quantidade' => $quantidade,
        ];
    }

    // Atualiza o cookie do carrinho
    setcookie('carrinho', json_encode($carrinho), time() + (7 * 24 * 60 * 60), '/');

    // Redireciona de volta para a página ou retorna uma resposta
    header('Location: index.php'); // Ajuste conforme necessário
    exit;
}
?>