<?php
require_once './classes/conexaoBanco.php';

$conexao = new conexaoBanco();
$db = $conexao->conectar();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['acao']) && $_POST['acao'] === 'incluir') {
        $nome = $_POST['nome'];
        $usuario = $_POST['usuario'];
        $senha = $_POST['senha'];

        
        $sql = "SELECT COUNT(*) FROM Usuario WHERE Usuario = :usuario";
        $stmt = $db->prepare($sql);
        $stmt->bindParam(':usuario', $usuario);
        $stmt->execute();
        $existe = $stmt->fetchColumn();

        if ($existe > 0) {
            echo "<div class='alert alert-danger'>O nome de usuário já existe. Escolha outro.</div>";
        } else {
            
            $sql = "INSERT INTO Usuario (Nome, Usuario, Senha) VALUES (:nome, :usuario, :senha)";
            $stmt = $db->prepare($sql);
            $stmt->bindParam(':nome', $nome);
            $stmt->bindParam(':usuario', $usuario);
            $stmt->bindParam(':senha', $senha);
            $stmt->execute();
            echo "<div class='alert alert-success'>Usuário incluído com sucesso.</div>";
        }
    }

    if (isset($_POST['acao']) && $_POST['acao'] === 'editar') {
        $id = $_POST['id'];
        $nome = $_POST['nome'];
        $usuario = $_POST['usuario'];
        $senha = $_POST['senha'];

        
        $sql = "SELECT COUNT(*) FROM Usuario WHERE Usuario = :usuario AND Id_Usuario != :id";
        $stmt = $db->prepare($sql);
        $stmt->bindParam(':usuario', $usuario);
        $stmt->bindParam(':id', $id);
        $stmt->execute();
        $existe = $stmt->fetchColumn();

        if ($existe > 0) {
            echo "<div class='alert alert-danger'>O nome de usuário já existe. Escolha outro.</div>";
        } else {
            
            $sql = "UPDATE Usuario SET Nome = :nome, Usuario = :usuario, Senha = :senha WHERE Id_Usuario = :id";
            $stmt = $db->prepare($sql);
            $stmt->bindParam(':id', $id);
            $stmt->bindParam(':nome', $nome);
            $stmt->bindParam(':usuario', $usuario);
            $stmt->bindParam(':senha', $senha);
            $stmt->execute();
            echo "<div class='alert alert-success'>Usuário atualizado com sucesso.</div>";
        }
    }

    if (isset($_POST['acao']) && $_POST['acao'] === 'excluir') {
        $id = $_POST['id'];
        $sql = "DELETE FROM Usuario WHERE Id_Usuario = :id";
        $stmt = $db->prepare($sql);
        $stmt->bindParam(':id', $id);
        $stmt->execute();
    }
}


$sql = "SELECT Id_Usuario, Nome, Usuario, Senha FROM Usuario";
$stmt = $db->query($sql);
$usuarios = $stmt->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista de Usuários</title>
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
        <h2 class="text-center">Lista de Usuários</h2>
        <table class="table table-bordered mt-3">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nome</th>
                    <th>Usuário</th>
                    <th>Senha</th>
                    <th>Alterar Dados</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($usuarios as $usuario): ?>
                <tr>
                    <td><?= $usuario['Id_Usuario'] ?></td>
                    <td><?= htmlspecialchars($usuario['Nome']) ?></td>
                    <td><?= htmlspecialchars($usuario['Usuario']) ?></td>
                    <td>********</td> 
                    <td>
                    
                        <form method="post" style="display:inline;">
                            <input type="hidden" name="acao" value="editar">
                            <input type="hidden" name="id" value="<?= $usuario['Id_Usuario'] ?>">
                            <input type="text" name="nome" placeholder="Nome" required value="<?= $usuario['Nome'] ?>">
                            <input type="text" name="usuario" placeholder="Usuário" required value="<?= $usuario['Usuario'] ?>">
                            <input type="password" name="senha" placeholder="Senha">
                            <button class="btn btn-primary btn-sm">Editar</button>
                        </form>
                        
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

        <h3 class="mt-5">Incluir Novo Usuário</h3>
        <form method="post">
            <input type="hidden" name="acao" value="incluir">
            <div class="mb-3">
                <label for="nome" class="form-label">Nome</label>
                <input type="text" class="form-control" name="nome" id="nome" placeholder="Digite o nome completo" required>
            </div>
            <div class="mb-3">
                <label for="usuario" class="form-label">Usuário</label>
                <input type="text" class="form-control" name="usuario" id="usuario" placeholder="Digite o nome de usuário" required>
            </div>
            <div class="mb-3">
                <label for="senha" class="form-label">Senha</label>
                <input type="password" class="form-control" name="senha" id="senha" placeholder="Digite a senha" required>
            </div>
            <button type="submit" class="btn btn-success">Incluir</button>
        </form>
    </div>
</body>
</html>
