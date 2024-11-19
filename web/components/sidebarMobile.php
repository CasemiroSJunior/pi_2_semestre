<link href="./css/sidebar.css" rel="stylesheet">
<script src="./scripts/svgLoader.js"></script>
<script>
    window.onload = function() {
        loadSVG('clipboard', 'mob-svg-produtos');
        loadSVG('package', 'mob-svg-ingredientes');
        loadSVG('user', 'mob-svg-usuarios');
    }
</script>
<div id="mobileNav" class="mobileNav">
    <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
        <img src="./assets/Logo.png" class="img-fluid" style="width: 20%; height: 20%;" alt="Imagem de Fundo">
        <a class="navbar-brand" href="./index.php">A Italianinha Pizzaria</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <div>
                <p class="fs-4">Olá, <strong> Usuário </strong></p>
            </div>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" id="mob-svg-produtos" href="./produtos.php">Produtos</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="mob-svg-ingredientes" href="./ingredientes.php">Ingredientes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="mob-svg-usuarios" href="./usuarios.php">Usuários</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-danger text-white" href="./logout.php">Sair</a>
                </li>
            </ul>
        </div>
    </nav>
</div>