<?php
require_once './classes/manipulaUsuario.php';

$manipula = new manipulaUsuario();

$msg = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $acao = $_POST['acao'] ?? '';
    $id = $_POST['id'] ?? null;
    $nome = trim($_POST['nome'] ?? '');
    $usuario = trim($_POST['usuario'] ?? '');
    $senha = $_POST['senha'] ?? '';  

    if ($acao === 'incluir' && !empty($nome) && !empty($usuario) && !empty($senha)) {
        // Verifica se o usuario ja existe no banco
        $sql = "SELECT COUNT(*) FROM usuario WHERE Usuario = :usuario";
        $stmt = (new conexaoBanco())->conectar()->prepare($sql);
        $stmt->bindParam(':usuario', $usuario);
        $stmt->execute();
        $count = $stmt->fetchColumn();

        if ($count == 0) {
            // cadastroUsuario
            if ($manipula->cadastroUsuario($nome, $usuario, $senha)) {
                $msg = "<div class='alert alert-success'>Usuário incluído com sucesso.</div>";
            } else {
                $msg = "<div class='alert alert-danger'>Erro ao incluir o usuário.</div>";
            }
        } else {
            $msg = "<div class='alert alert-warning'>Usuário já existe.</div>";
        }
    } elseif ($acao === 'editar' && !empty($nome) && !empty($usuario) && $id) {
        // atualizaUsuario
        if ($manipula->atualizaUsuario($id, $nome, $usuario, $senha)) {
            $msg = "<div class='alert alert-success'>Usuário atualizado com sucesso.</div>";
        } else {
            $msg = "<div class='alert alert-danger'>Erro ao atualizar o usuário.</div>";
        }
    } elseif ($acao === 'excluir' && $id) {
        // removeUsuario
        if ($manipula->removeUsuario($id)) {
            $msg = "<div class='alert alert-success'>Usuário excluído com sucesso.</div>";
        } else {
            $msg = "<div class='alert alert-danger'>Erro ao excluir o usuário.</div>";
        }
    } else {
        $msg = "<div class='alert alert-danger'>Preencha todos os campos corretamente.</div>";
    }
}

$usuarios = $manipula->listaUsuario();
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gerenciar Usuários</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script>
        function confirmarExclusao(form) {
            const confirmacao = confirm("Você tem certeza que deseja excluir este usuário?");
            if (confirmacao) {
                form.submit();
            }
        }
    </script>
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">Gerenciar Usuários</h2>
        
        <?php if (!empty($msg)) echo $msg; ?>

        <table class="table table-bordered mt-3">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Usuário</th>
                    <th>Ações</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($usuarios as $usuario): ?>
                <tr>
                    <td><?= $usuario['Id_Usuario'] ?></td>
                    <td><?= htmlspecialchars($usuario['Nome']) ?></td>
                    <td><?= htmlspecialchars($usuario['Usuario']) ?></td>
                    <td>
                        <!-- editar usuarios -->
                        <form method="post" style="display:inline;">
                            <input type="hidden" name="acao" value="editar">
                            <input type="hidden" name="id" value="<?= $usuario['Id_Usuario'] ?>">
                            <input type="text" name="nome" placeholder="Nome" required value="<?= $usuario['Nome'] ?>">
                            <input type="text" name="usuario" placeholder="Usuário" required value="<?= $usuario['Usuario'] ?>">
                            <input type="password" name="senha" placeholder="Senha">
                            <button class="btn btn-primary btn-sm">Editar</button>
                        </form>

                        <!-- excluir usuarios -->
                        <form method="post" style="display:inline;" onsubmit="event.preventDefault(); confirmarExclusao(this);">
                            <input type="hidden" name="acao" value="excluir">
                            <input type="hidden" name="id" value="<?= $usuario['Id_Usuario'] ?>">
                            <button class="btn btn-danger btn-sm">Excluir</button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>

        <!-- adicionar usuarios -->
        <h3 class="mt-5">Adicionar Novo Usuário</h3>
        <form method="post" autocomplete="off">
            <input type="hidden" name="acao" value="incluir">
            <div class="mb-3">
                <label for="nome" class="form-label">Nome</label>
                <input type="text" class="form-control" name="nome" id="nome" placeholder="Digite o nome do usuário" required>
            </div>
            <div class="mb-3">
                <label for="usuario" class="form-label">Usuário</label>
                <input type="text" class="form-control" name="usuario" id="usuario" placeholder="Digite o nome de usuário" required>
            </div>
            <div class="mb-3">
                <label for="senha" class="form-label">Senha</label>
                <input type="password" class="form-control" name="senha" id="senha" placeholder="Digite a senha" required>
            </div>
            <button type="submit" class="btn btn-success">Adicionar</button>
        </form>
    </div>
</body>
</html>
