<?php
require_once './classes/manipulaProduto.php';
require_once './classes/manipulaIngrediente.php';
require_once './classes/produto.php';

$manipulaProduto = new manipulaProduto();
$manipulaIngrediente = new manipulaIngrediente();
$msg = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $acao = $_POST['acao'] ?? '';
    $id = $_POST['id'] ?? null;
    $nome = trim($_POST['nome'] ?? '');
    $preco = $_POST['preco'] ?? 0;
    $categoria = $_POST['categoria'] ?? null;
    $id_ingrediente = $_POST['id_ingrediente'] ?? null;
    $id_produto = $_POST['id_produto'] ?? null;
    $disponivel = $_POST['disponivel'] ?? 0;

    if ($acao === 'incluir' && !empty($nome) && $preco > 0 && $categoria) {
        // Verifica se o produto já existe no banco
        $sql = "select count(*) from produto where nome = :nome";
        $stmt = (new conexaoBanco())->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->execute();
        $count = $stmt->fetchColumn();
    
        if ($count == 0) {
            // Cadastro do produto
            if ($manipulaProduto->cadastroProduto($nome, $preco, $disponivel, $categoria)) {
                $msg = "<div class='alert alert-success'>Produto incluído com sucesso.</div>";
            } else {
                $msg = "<div class='alert alert-danger'>Erro ao incluir o produto.</div>";
            }
        } else {
            $msg = "<div class='alert alert-warning'>Produto já existe.</div>";
        }
    } elseif ($acao === 'editar' && !empty($nome) && $preco > 0 && $id) {
        if ($manipulaProduto->atualizaProduto($id, $nome, $preco)) {
            $msg = "<div class='alert alert-success'>Produto atualizado com sucesso.</div>";
        } else {
            $msg = "<div class='alert alert-danger'>Erro ao atualizar o produto.</div>";
        }
    } elseif ($acao === 'excluir' && $id) {
        try {
            // Exclui os registros da tabela de relacionamento
            $sql = "delete from produto_ingrediente where id_produto = :id_produto";
            $stmt = (new conexaoBanco())->conectar()->prepare($sql);
            $stmt->bindParam(':id_produto', $id);
            $stmt->execute();
            
            // Agora, exclui o produto
            if ($manipulaProduto->removeProduto($id)) {
                $msg = "<div class='alert alert-success'>Produto excluído com sucesso.</div>";
            } else {
                $msg = "<div class='alert alert-danger'>Erro ao excluir o produto.</div>";
            }
        } catch (PDOException $e) {
            $msg = "<div class='alert alert-danger'>Erro ao excluir produto: " . $e->getMessage() . "</div>";
        }
    } elseif ($acao === 'vincular_ingrediente' && $id_produto && $id_ingrediente) {
        if ($manipulaProduto->adicionaIngredienteProduto($id_produto, $id_ingrediente)) {
            $manipulaProduto->atualizarStatusProduto($id_produto);
            $msg = "<div class='alert alert-success'>Ingrediente vinculado ao produto com sucesso.</div>";
        } else {
            $msg = "<div class='alert alert-danger'>Erro ao vincular o ingrediente.</div>";
        }
    }
}

// Listagem de produtos e ingredientes
$produtos = $manipulaProduto->listaProduto();
$ingredientes = $manipulaIngrediente->listaIngrediente();
$categorias = (new Produto())->obterCategoria();
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Produtos</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">Gerenciar Produtos</h2>

        <?php if (!empty($msg)) echo $msg; ?>

        <!-- Tabela de produtos -->
        <table class="table table-bordered mt-3">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Preço</th>
                    <th>Ingredientes</th>
                    <th>Categoria</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($produtos as $produto): ?>
                <tr>
                    <td><?= $produto['id_produto'] ?></td>
                    <td><?= htmlspecialchars($produto['nome']) ?></td>
                    <td>R$ <?= number_format($produto['preco'], 2, ',', '.') ?></td>
                    <td>
                        <?php
                        // Buscar ingredientes associados a esse produto
                        $sql = "select i.nome, i.disponivel
                                from ingrediente i
                                join produto_ingrediente pi on pi.id_ingrediente = i.id_ingrediente
                                where pi.id_produto = ?";
                        $stmt = (new conexaoBanco())->conectar()->prepare($sql);
                        $stmt->execute([$produto['id_produto']]);
                        $ingredientesProduto = $stmt->fetchAll(PDO::FETCH_ASSOC);
                        
                        if ($ingredientesProduto) {
                            foreach ($ingredientesProduto as $ingrediente) {
                                echo htmlspecialchars($ingrediente['nome']) . " (Disponível: " . ($ingrediente['disponivel'] ? "Sim" : "Não") . ")<br>";
                            }
                        } else {
                            echo "Nenhum ingrediente vinculado.";
                        }
                        ?>
                    </td>
                    <td><?= htmlspecialchars($produto['categoria']) ?></td>
                    <td>
                        <!-- Formulário para editar produto -->
                        <form method="post" style="display:inline;">
                            <input type="hidden" name="acao" value="editar">
                            <input type="hidden" name="id" value="<?= $produto['id_produto'] ?>">
                            <input type="text" name="nome" placeholder="Nome" required value="<?= $produto['nome'] ?>">
                            <input type="number" name="preco" placeholder="Preço" required step="0.01" value="<?= $produto['preco'] ?>">
                            <button class="btn btn-primary btn-sm">Editar</button>
                        </form>

                        <!-- Formulário para excluir produto -->
                        <form method="post" style="display:inline;" onsubmit="return confirm('Deseja realmente excluir este produto?');">
                            <input type="hidden" name="acao" value="excluir">
                            <input type="hidden" name="id" value="<?= $produto['id_produto'] ?>">
                            <button class="btn btn-danger btn-sm">Excluir</button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <!-- Adicionar novo produto -->
        <h3 class="mt-5">Adicionar Novo Produto</h3>
        <form method="post" autocomplete="off">
            <input type="hidden" name="acao" value="incluir">
            <div class="mb-3">
                <label for="nome" class="form-label">Nome</label>
                <input type="text" class="form-control" name="nome" id="nome" placeholder="Digite o nome do produto" required>
            </div>
            <div class="mb-3">
                <label for="preco" class="form-label">Preço</label>
                <input type="number" class="form-control" name="preco" id="preco" placeholder="Digite o preço do produto" required step="0.01">
            </div>
            <div class="mb-3">
                <label for="categoria" class="form-label">Categoria</label>
                <select name="categoria" id="categoria" class="form-select" required>
                    <?php foreach ($categorias as $categoria): ?>
                        <option value="<?= $categoria['id_categoria'] ?>">
                            <?= htmlspecialchars($categoria['nome']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Adicionar</button>
        </form>

                <!-- Vincular ingredientes ao produto -->
                <h3 class="mt-5">Vincular Ingredientes ao Produto</h3>
        <form method="post" autocomplete="off">
            <input type="hidden" name="acao" value="vincular_ingrediente">
            <div class="mb-3">
                <label for="id_produto" class="form-label">Produto</label>
                <select name="id_produto" id="id_produto" class="form-select" required>
                    <?php foreach ($produtos as $produto): ?>
                        <option value="<?= $produto['id_produto'] ?>">
                            <?= htmlspecialchars($produto['nome']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <div class="mb-3">
                <label for="id_ingrediente" class="form-label">Ingrediente</label>
                <select name="id_ingrediente" id="id_ingrediente" class="form-select" required>
                    <?php foreach ($ingredientes as $ingrediente): ?>
                        <option value="<?= $ingrediente['Id_ingrediente'] ?>">
                            <?= htmlspecialchars($ingrediente['Nome']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Vincular Ingrediente</button>
        </form>

    </div>
</body>
</html>
