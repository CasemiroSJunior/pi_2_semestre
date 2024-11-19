<link href="./css/sidebar.css" rel="stylesheet">


    <script src="./scripts/svgLoader.js"></script>   
    <script>
        window.onload = function() {
            loadSVG('clipboard', 'svg-produtos');
            loadSVG('package', 'svg-ingredientes');
            loadSVG('user', 'svg-usuarios');
        }
    </script> 


<div class="d-flex flex-column flex-shrink-0 p-3 bg-body-tertiary desktopNav" style="width: 280px; height:100%; position: absolute;">
    <div class="row ">
        <div class="col-md-12 image-section">
            <img src="./assets/Logo.png" class="img-fluid " alt="Imagem de Fundo">
        </div>
        <div class="col-md-12 d-flex align-items-center justify-content-center">
            <span class="fs-4">A Italianinha Pizzaria</span>
        </div>
    </div>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
        <li>

            <a href="./produtos.php" class="nav-link link-body-emphasis " id="svg-produtos">
                Produtos
            </a>
        </li>
        <li>
            <a href="./ingredientes.php" class="nav-link link-body-emphasis " id="svg-ingredientes">
                Ingredientes
            </a>
        </li>
        <li>

            <a href="./usuarios.php" class="nav-link link-body-emphasis " id="svg-usuarios">
                Usuários
            </a>
        </li>
        <!-- <li>
            <a href="#" class="nav-link link-body-emphasis">
                <svg class="bi pe-none me-2" width="16" height="16">
                    <use xlink:href="#people-circle" />
                </svg>
                Pedidos
            </a>
        </li> -->
    </ul>
    <hr>
    <div class="dropdown">
        <a href="#" class="d-flex align-items-center link-body-emphasis text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
            <img src="https://github.com/mdo.png" alt="" width="32" height="32" class="rounded-circle me-2">
            <strong>mdo</strong>
        </a>
        <ul class="dropdown-menu text-small shadow">
            <li><a class="dropdown-item" href="#">Sair</a></li>
        </ul>
    </div>
</div>