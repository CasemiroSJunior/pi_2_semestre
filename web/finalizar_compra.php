<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Dados do formulário
    $nome = htmlspecialchars($_POST['nome']);
    $endereco = htmlspecialchars($_POST['endereco']);
    $telefone = htmlspecialchars($_POST['telefone']);
    $forma_pagamento = htmlspecialchars($_POST['forma_pagamento']);

    // Recupera os itens do carrinho armazenados em cookies
    $carrinho = isset($_COOKIE['carrinho']) ? json_decode($_COOKIE['carrinho'], true) : [];

    // Inicia a mensagem com as informações do cliente
    $mensagem = "Olá, gostaria de finalizar a compra. Seguem os detalhes:\n\n";
    $mensagem .= "Nome: $nome\n";
    $mensagem .= "Endereço: $endereco\n";
    $mensagem .= "Telefone: $telefone\n";
    $mensagem .= "Forma de Pagamento: $forma_pagamento\n\n";

    // Adiciona os produtos escolhidos no carrinho
    $mensagem .= "Itens no carrinho:\n";
    $total = 0;  // Variável para armazenar o valor total da compra
    foreach ($carrinho as $item) {
        $itemTotal = $item['quantidade'] * $item['preco'];
        $total += $itemTotal;
        $mensagem .= "- {$item['nome']} | Quantidade: {$item['quantidade']} | Preço Unitário: R$ {$item['preco']} | Total: R$ {$itemTotal}\n";
    }

    // Adiciona o total geral da compra
    $mensagem .= "\nTotal da compra: R$ $total\n";

    $ddd_pais = "55";
    $ddd_estado = "015";
    $numero = "996131073";
    // Defina o número de WhatsApp aqui (apenas números, incluindo código do país)
    $numeroWhatsApp = $ddd_pais . $ddd_estado . $numero;

    // Substitui espaços e formata a URL para o WhatsApp
    $mensagem = urlencode($mensagem);
    $urlWhatsApp = "https://wa.me/$numeroWhatsApp?text=$mensagem";

    // Redireciona para o WhatsApp com a mensagem formatada
    header("Location: $urlWhatsApp");
    exit;
} else {
    echo "Método inválido.";
}
?>
