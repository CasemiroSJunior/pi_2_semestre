<?php
// Inicia a sessão para acessar os cookies
session_start();

// Recupera os itens do carrinho armazenados em cookies
$carrinho = isset($_COOKIE['carrinho']) ? json_decode($_COOKIE['carrinho'], true) : [];

// Verifica se há itens no carrinho
?>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>Carrinho de Compras</title>
</head>
<body>
<div class="container my-4">
    <h2 class="text-center mb-4">Carrinho de Compras</h2>
    <?php if (empty($carrinho)): ?>
        <div class="alert alert-warning text-center">
            Seu carrinho está vazio.
        </div>
    <?php else: ?>
        <div class="table-responsive">
            <table class="table table-striped table-bordered align-middle">
                <thead>
                    <tr>
                        <th>Produto</th>
                        <th>Preço Unitário</th>
                        <th>Quantidade</th>
                        <th>Total</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <?php 
                    $totalGeral = 0;
                    foreach ($carrinho as $index => $item): 
                        $totalItem = $item['preco'] * $item['quantidade'];
                        $totalGeral += $totalItem;
                    ?>
                        <tr>
                            <td><?= htmlspecialchars($item['nome']); ?></td>
                            <td>R$ <?= number_format($item['preco'], 2, ',', '.'); ?></td>
                            <td>
                            <form action="atualizar_carrinho.php" method="POST">
                                <input type="hidden" name="nome" value="<?= $item['nome']; ?>">
                                <input type="number" name="quantidade" value="<?= $item['quantidade']; ?>" min="1">
                                <button type="submit" class="btn btn-primary">Atualizar</button>
                            </form>
                            </td>
                            <td>R$ <?= number_format($totalItem, 2, ',', '.'); ?></td>
                            <td>
                            <form action="remover_item.php" method="POST">
                                <input type="hidden" name="nome" value="<?= $item['nome']; ?>">
                                <button type="submit" class="btn btn-danger">Remover</button>
                            </form>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" class="text-end fw-bold">Total Geral:</td>
                        <td colspan="2" class="fw-bold">R$ <?= number_format($totalGeral, 2, ',', '.'); ?></td>
                    </tr>
                </tfoot>
            </table>
        </div>
    <?php endif; ?>
    <div class="text-center mt-4">
        <a href="index.php" class="btn btn-secondary">Continuar Comprando</a>
        <a href="form_entrega.php" class="btn btn-success">Finalizar Compra</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
