<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página de Login</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .login-container {
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-form {
            max-width: 400px;
            width: 100%;
        }
        .image-section {
            background-image: url('sua-imagem.jpg'); /* Substitua 'sua-imagem.jpg' pelo caminho da sua imagem */
            background-size: cover;
            background-position: center;
            height: 100vh;
        }
    </style>
</head>
<body>

<div class="container-fluid">
    <div class="row login-container">
        <!-- Formulário de Login -->
        <div class="col-md-4 d-flex align-items-center">
            <div class="login-form">
                <h2>Login</h2>
                <form action="process_login.php" method="POST">
                    <div class="form-group">
                        <label for="username">Usuário</label>
                        <input type="text" name="username" id="username" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Senha</label>
                        <input type="password" name="password" id="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Entrar</button>
                </form>
            </div>
        </div>
        
        <!-- Seção de Imagem -->
        <div class="col-md-8 image-section" style="background-color: gray;">
            <img src="./assets/DALL_E-2024-11-09-18.20-removebg-preview.png" class="img-fluid" alt="Imagem de Fundo">
        </div>
    </div>
</div>

<!-- Bootstrap JS e dependências -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
