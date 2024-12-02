<?php

function createAccordionCategory($category, $children, $categoryId)
{
    echo '
    <div class="accordion" id="collapse' . $categoryId . '">
        <div class="accordion-item">
            <h2 class="accordion-header" id="heading' . $categoryId . 'i">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse' . $categoryId . 'i" aria-expanded="false" aria-controls="collapse' . $categoryId . 'i">
                    ' . htmlspecialchars($category) . '
                </button>
            </h2>
            <div id="collapse' . $categoryId . 'i" class="accordion-collapse collapse" aria-labelledby="heading' . $categoryId . '" data-bs-parent="#collapse' . $categoryId . '">
                <div class="accordion-body">
                    <div class="row">';
    foreach ($children as $child) {
        echo '<div class="col-md-4">
                <div class="card mb-4 shadow-sm">
                    <div class="card-body text-center">
                        <h5 class="card-title">' . htmlspecialchars($child['NOME']) . '</h5>
                        <p class="card-text text-muted">' . htmlspecialchars($child['DESCRICAO']) . '</p>
                        <p class="card-text fw-bold text-success">R$ ' . number_format($child['PRECO'], 2, ',', '.') . '</p>
                        
                        <!-- Formulário para adicionar ao carrinho -->
                        <form method="post" action="add_to_carrinho.php" class="d-flex justify-content-center align-items-center">
                            <input type="hidden" name="nome" value="' . htmlspecialchars($child['NOME']) . '">
                            <input type="hidden" name="preco" value="' . htmlspecialchars($child['PRECO']) . '">
                            
                            <input type="number" class="form-control form-control-sm me-2" name="quantidade" min="1" value="1" required style="width: 80px;">
                            <button type="submit" class="btn btn-outline-primary btn-sm">
                                <i class="bi bi-cart-plus"></i> Adicionar
                            </button>
                        </form>
                    </div>
                </div>
            </div>';
    }
    echo '          </div>
                </div>
            </div>
        </div>
    </div>';
}
?>
