<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Venda</title>
    <link href="./css/sidebar.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.6.0/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>

<body>
    <!-- DesktopNav verifica se a resolução do usuário é menor que 768 ou maior, se maior renderiza com a sidebar do dekstop, se menor com o do mobile -->
    <div class="container-fluid desktopNav">
        <div class="row">
            <div class="col-md-3">
                <?php include './components/sidebarDesktop.php'; ?>
            </div>
            <!-- Renderiza o conteúdo da página selecionada -->
            <div class="col-md-9">
                <main role="main" class="pt-3">
                    <?php include $content; ?>
                </main>
            </div>
        </div>
    </div>
    <div class="mobileNav">
        <div>
            <div>
                <div class="p-2">
                    <?php include './components/sidebarMobile.php'; ?>
                </div>

                <div>
                    <main role="main" class="pt-3">
                        <?php include $content; ?>
                    </main>
                </div>
            </div>
        </div>
    </div>
</body>

</html>