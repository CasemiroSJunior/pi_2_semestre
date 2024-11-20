<?php

function createAccordionCategory($category, $children, $categoryId){
    

    echo '
    <div class="accordion" id="collapse'.$categoryId.'">
        <div class="accordion-item">
            <h2 class="accordion-header" id="heading'.$categoryId.'i">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse'.$categoryId.'i" aria-expanded="false" aria-controls="collapse'.$categoryId.'i">
                    '.$category.'
                </button>
            </h2>
            <div id="collapse'.$categoryId.'i" class="accordion-collapse collapse" aria-labelledby="heading'.$categoryId.'" data-bs-parent="#collapse'.$categoryId.'">
                <div class="accordion-body">
                    <div class="row">';
    foreach($children as $child){
                echo '<div class="col-md-4">
                        <div class="card mb-4">
                            <div class="card-body">
                                <h5 class="card-title">'.$child['NOME'].'</h5>
                                <p class="card-text">'.$child['DESCRICAO'] . '<br>' . " R$ " .$child['PRECO'].'</p>
                                <a href="#" class="btn btn-primary">Adicionar ao carrinho</a>
                            </div>
                        </div>
                    </div>';
            
    }   
    echo '          </div>
                </div>
            </div>
        </div>';
}
?>