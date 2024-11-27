<?php
require_once './classes/autenticacao.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') 
{
    $username = $_POST['username'];
    $password = $_POST['password'];
    $autenticacao = new autenticacaoLogin();
    $autenticacao->verificaLogin($username, $password);
}
?>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página de Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link href="./css/style.css" rel="stylesheet">
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        @media (max-width: 768px) {
            .image-section {
                display: block;
            }
        }
        
    </style>
</head>

<body class="bodyDefault">
    <div class="container-fluid">
        <div class="row ">
            <div class="col-md-12 image-section" >
                <img src="./assets/Logo.png" class="img-fluid "  alt="Imagem de Fundo">
            </div>
            <div class="col-md-12 d-flex align-items-center justify-content-center">
                <div class="login-form">
                    <h2>Login</h2>
                    <form action="" method="POST">
                        <div class="form-group">
                            <label for="username">Usuário</label>
                            <input type="text" name="username" id="username" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="password">Senha</label>
                            <input type="password" name="password" id="password" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block mt-2">Entrar</button>
                    </form>
                </div>
            </div>


        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>

</html>