<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finalizar Compra</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <script>
        // Função para formatar o número de telefone
        function formatTelefone(event) {
            let input = event.target;
            let value = input.value.replace(/\D/g, ''); // Remove qualquer coisa que não seja número

            // Aplica o formato (XX) XXXXX-XXXX
            if (value.length <= 2) {
                value = value.replace(/^(\d{0,2})/, "($1");
            } else if (value.length <= 5) {
                value = value.replace(/^(\d{2})(\d{0,4})/, "($1) $2");
            } else if (value.length <= 10) {
                value = value.replace(/^(\d{2})(\d{4})(\d{0,4})/, "($1) $2-$3");
            } else {
                value = value.replace(/^(\d{2})(\d{4})(\d{4})/, "($1) $2-$3");
            }

            input.value = value;
        }
    </script>
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center mb-4">Finalizar Compra</h2>
        <form action="finalizar_compra.php" method="POST" class="needs-validation" novalidate>
            <div class="mb-3">
                <label for="nome" class="form-label">Nome Completo</label>
                <input type="text" name="nome" id="nome" class="form-control" required>
                <div class="invalid-feedback">Por favor, insira seu nome completo.</div>
            </div>

            <div class="mb-3">
                <label for="endereco" class="form-label">Endereço</label>
                <input type="text" name="endereco" id="endereco" class="form-control" required>
                <div class="invalid-feedback">Por favor, insira seu endereço.</div>
            </div>

            <div class="mb-3">
                <label for="telefone" class="form-label">Telefone de Contato</label>
                <input type="tel" name="telefone" id="telefone" class="form-control" placeholder="(XX) XXXXX-XXXX" required oninput="formatTelefone(event)">
                <div class="invalid-feedback">Por favor, insira um telefone válido no formato (XX) XXXXX-XXXX.</div>
            </div>

            <div class="mb-3">
                <label for="forma_pagamento" class="form-label">Forma de Pagamento</label>
                <select name="forma_pagamento" id="forma_pagamento" class="form-select" required>
                    <option value="">Selecione...</option>
                    <option value="Cartão de Crédito">Cartão de Crédito/ Cartão de Débito</option>
                    <option value="Pix">Pix</option>
                    <option value="Dinheiro">Dinheiro</option>
                </select>
                <div class="invalid-feedback">Por favor, selecione uma forma de pagamento.</div>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-success">Confirmar Compra</button>
            </div>
        </form>
    </div>

    <script>
        // Validação do Bootstrap
        (function () {
            'use strict'
            const forms = document.querySelectorAll('.needs-validation')
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html>
