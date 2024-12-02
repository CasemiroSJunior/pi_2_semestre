<?php
require_once 'components/accordion.php';
require_once './classes/produto.php';
?>
<!doctype html>
<html lang="pt-br" data-bs-theme="auto">

<head>
  <script src="../assets/js/color-modes.js"></script>
  <script src="/scripts/carrinhoCounter.js"></script>
  
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="">
  <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
  <meta name="generator" content="Hugo 0.122.0">
  <title>Blog Template · Bootstrap v5.3</title>

  <link rel="canonical" href="https://getbootstrap.com/docs/5.3/examples/blog/">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@docsearch/css@3">

  <link href="./css/bootstrap.min.css" rel="stylesheet">

  <style>
    .bd-placeholder-img {
      font-size: 1.125rem;
      text-anchor: middle;
      -webkit-user-select: none;
      -moz-user-select: none;
      user-select: none;
    }

    @media (min-width: 768px) {
      .bd-placeholder-img-lg {
        font-size: 3.5rem;
      }
    }

    .b-example-divider {
      width: 100%;
      height: 3rem;
      background-color: rgba(0, 0, 0, .1);
      border: solid rgba(0, 0, 0, .15);
      border-width: 1px 0;
      box-shadow: inset 0 .5em 1.5em rgba(0, 0, 0, .1), inset 0 .125em .5em rgba(0, 0, 0, .15);
    }

    .b-example-vr {
      flex-shrink: 0;
      width: 1.5rem;
      height: 100vh;
    }

    .bi {
      vertical-align: -.125em;
      fill: currentColor;
    }

    .nav-scroller {
      position: relative;
      z-index: 2;
      height: 2.75rem;
      overflow-y: hidden;
    }

    .nav-scroller .nav {
      display: flex;
      flex-wrap: nowrap;
      padding-bottom: 1rem;
      margin-top: -1px;
      overflow-x: auto;
      text-align: center;
      white-space: nowrap;
      -webkit-overflow-scrolling: touch;
    }

    .btn-bd-primary {
      --bd-violet-bg: #712cf9;
      --bd-violet-rgb: 112.520718, 44.062154, 249.437846;

      --bs-btn-font-weight: 600;
      --bs-btn-color: var(--bs-white);
      --bs-btn-bg: var(--bd-violet-bg);
      --bs-btn-border-color: var(--bd-violet-bg);
      --bs-btn-hover-color: var(--bs-white);
      --bs-btn-hover-bg: #6528e0;
      --bs-btn-hover-border-color: #6528e0;
      --bs-btn-focus-shadow-rgb: var(--bd-violet-rgb);
      --bs-btn-active-color: var(--bs-btn-hover-color);
      --bs-btn-active-bg: #5a23c8;
      --bs-btn-active-border-color: #5a23c8;
    }

    .bd-mode-toggle {
      z-index: 1500;
    }

    .bd-mode-toggle .dropdown-menu .active .bi {
      display: block !important;
    }

    @media (max-width: 767px) {
      .deviceSelector {
        width: 80%;
      }
    }

    @media (min-width: 768px) {
      .deviceSelector {
        width: 100%;
      }
    }
  </style>

  <link href="https://fonts.googleapis.com/css?family=Playfair&#43;Display:700,900&amp;display=swap" rel="stylesheet">
  <link href="blog.css" rel="stylesheet">
</head>

<body>


  <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
    <symbol id="aperture" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewBox="0 0 24 24">
      <circle cx="12" cy="12" r="10" />
      <path d="M14.31 8l5.74 9.94M9.69 8h11.48M7.38 12l5.74-9.94M9.69 16L3.95 6.06M14.31 16H2.83m13.79-4l-5.74 9.94" />
    </symbol>
    <symbol id="cart" viewBox="0 0 16 16">
      <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .49.598l-1 5a.5.5 0 0 1-.465.401l-9.397.472L4.415 11H13a.5.5 0 0 1 0 1H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5zM3.102 4l.84 4.479 9.144-.459L13.89 4H3.102zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4zm-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2zm7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2z" />
    </symbol>
    <symbol id="chevron-right" viewBox="0 0 16 16">
      <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z" />
    </symbol>
  </svg>

  <div class="container">
    <?php
    // Recupera o valor total dos itens no carrinho a partir do cookie
    $carrinho = isset($_COOKIE['carrinho']) ? json_decode($_COOKIE['carrinho'], true) : [];
    $totalItens = array_reduce($carrinho, function ($total, $item) {
      return $total + (int)$item['quantidade'];
    }, 0);
    ?>
    <header class="border-bottom lh-1 py-3">
      <div class="row flex-nowrap justify-content-between align-items-center">
        <!-- Logo -->
        <div class="col-4 pt-1">
          <a href="index.php" aria-label="Voltar para a página inicial">
            <img class="img-fluid" src="./assets/Logo.svg" alt="Logo da empresa">
          </a>
        </div>
        <!-- Botão do carrinho -->
        <div class="col-4 d-flex justify-content-end align-items-center">
          <a href="carrinho.php" class="btn btn-primary position-relative" aria-label="Abrir o carrinho">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" class="bi bi-cart" viewBox="0 0 16 16">
              <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5M3.102 4l1.313 7h8.17l1.313-7zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4m7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4m-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2m7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2" />
            </svg>
            <span class="position-absolute top-0 start-90 translate-middle badge rounded-pill bg-danger" id="cart-count">
              <?= $totalItens; ?>
              <span class="visually-hidden">Itens adicionados</span>
            </span>
          </a>
        </div>
      </div>
    </header>



  </div>

  <main class="container">
    <div class="text-center">

      <img class="rounded deviceSelector" src="./assets/Banner.svg" alt="...">
    </div>

    <div class="row mb-2">

    </div>

    <div class="row g-5 justify-content-center">
      <div class="col-md-8">
        <h3 class="pb-4 mb-4 fst-italic border-bottom">
          Produtos
        </h3>
        <?php
        //instanciando classe produto.
        $produto = new produto();
        //chamando o método obter categoria e reservando no categorias.
        $categorias = $produto->obtercategoria();
        //percorre o array categorias, onde cada item pertence a uma categoria da base de dados.
        //index guarda a posição do item dentro do array.
        //categoria armazena cada elemento de categorias, representando uma categoria especifica.
        foreach ($categorias as $index => $categoria) {
          //agora categoria e um array associativo e id_categoria é a chave que armazena o identificador unico de cada categoria.
          $categoriaid = $categoria['id_categoria'];
          //chama o método que obtem o produto de acordo com a categoria passada.
          $produtos = $produto->obterprodutoporcategoria($categoriaid);
          //chama a função responsavel por mostrar na página os itens separados por categoria.
          //index + 1 é pra não startar a partir de 0
          createaccordioncategory($categoria['nome'], $produtos, $index + 1);
        }
        ?>
      </div>
    </div>
    </div>
  </main>

  <footer class="py-5 text-center text-body-secondary bg-body-tertiary">
    <p>Produzido para um <a href="https://github.com/casemirosjunior/pi_2_semestre/">PROJETO ESCOLAR</a>.</p>
    <p class="mb-0">
      <a href="#">Voltar ao início</a>
    </p>
  </footer>
  <script src="../assets/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>