<?php
require_once './classes/manipulaIngrediente.php';

$manipula = new manipulaIngrediente();

$msg = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $acao = $_POST['acao'] ?? '';
    $id = $_POST['id'] ?? null;
    $nome = trim($_POST['nome'] ?? '');
    $disponivel = isset($_POST['disponivel']) ? 1 : 0;

    if ($acao === 'incluir' && !empty($nome)) {
        // Verifica se o ingrediente já existe no banco
        $sql = "select count(*) from ingrediente where nome = :nome";
        $stmt = (new conexaoBanco())->conectar()->prepare($sql);
        $stmt->bindParam(':nome', $nome);
        $stmt->execute();
        $count = $stmt->fetchColumn();

        if ($count == 0) {
            // cadastroIngrediente
            if ($manipula->cadastroIngrediente($nome, $disponivel)) {
                $msg = "<div class='alert alert-success'>Ingrediente incluído com sucesso.</div>";
            } else {
                $msg = "<div class='alert alert-danger'>Erro ao incluir o ingrediente.</div>";
            }
        } else {
            $msg = "<div class='alert alert-warning'>Ingrediente já existe.</div>";
        }
    } elseif ($acao === 'editar' && !empty($nome) && $id) {
        // atualizaIngrediente
        if ($manipula->atualizaIngrediente($id, $nome, $disponivel)) {
            $msg = "<div class='alert alert-success'>Ingrediente atualizado com sucesso.</div>";
        } else {
            $msg = "<div class='alert alert-danger'>Erro ao atualizar o ingrediente.</div>";
        }
    } elseif ($acao === 'excluir' && $id) {
        // removeIngrediente
        if ($manipula->removeIngrediente($id)) {
            $msg = "<div class='alert alert-success'>Ingrediente excluído com sucesso.</div>";
        } else {
            $msg = "<div class='alert alert-danger'>Erro ao excluir o ingrediente.</div>";
        }
    } else {
        $msg = "<div class='alert alert-danger'>Preencha todos os campos corretamente.</div>";
    }
}

$ingredientes = $manipula->listaIngrediente();
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Ingredientes</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        function confirmarExclusao(form) {
            const confirmacao = confirm("Você tem certeza que deseja excluir este ingrediente?");
            if (confirmacao) {
                form.submit();
            }
        }
    </script>
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">Gerenciar Ingredientes</h2>
        
        <?php if (!empty($msg)) echo $msg; ?>

        <table class="table table-bordered mt-3">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Disponível</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($ingredientes as $ingrediente): ?>
                <tr>
                    <td><?= $ingrediente['Id_ingrediente'] ?></td>
                    <td><?= htmlspecialchars($ingrediente['Nome']) ?></td>
                    <td><?= $ingrediente['Disponivel'] ? 'Sim' : 'Não' ?></td>
                    <td>
                        <!-- editar ingredientes -->
                        <form method="post" style="display:inline;">
                            <input type="hidden" name="acao" value="editar">
                            <input type="hidden" name="id" value="<?= $ingrediente['Id_ingrediente'] ?>">
                            <input type="text" name="nome" placeholder="Nome" required value="<?= $ingrediente['Nome'] ?>">
                            <label>
                                <input type="checkbox" name="disponivel" <?= $ingrediente['Disponivel'] ? 'checked' : '' ?>> Disponível
                            </label>
                            <button class="btn btn-primary btn-sm">Editar</button>
                        </form>

                        <!-- excluir ingredientes -->
                        <form method="post" style="display:inline;" onsubmit="event.preventDefault(); confirmarExclusao(this);">
                            <input type="hidden" name="acao" value="excluir">
                            <input type="hidden" name="id" value="<?= $ingrediente['Id_ingrediente'] ?>">
                            <button class="btn btn-danger btn-sm">Excluir</button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <!-- adicionar ingredientes -->
        <h3 class="mt-5">Adicionar Novo Ingrediente</h3>
        <form method="post" autocomplete="off">
            <input type="hidden" name="acao" value="incluir">
            <div class="mb-3">
                <label for="nome" class="form-label">Nome</label>
                <input type="text" class="form-control" name="nome" id="nome" placeholder="Digite o nome do ingrediente" required>
            </div>
            <div class="mb-3">
                <label>
                    <input type="checkbox" name="disponivel"> Disponível
                </label>
            </div>
            <button type="submit" class="btn btn-success">Adicionar</button>
        </form>
    </div>
</body>
</html>
