// Função para obter os dados do carrinho a partir dos cookies
function getCartCount() {
    const cookieName = 'carrinho';
    const cookies = document.cookie.split(';');
    for (let i = 0; i < cookies.length; i++) {
        const cookie = cookies[i].trim();
        if (cookie.startsWith(`${cookieName}=`)) {
            const cart = JSON.parse(cookie.substring(cookieName.length + 1));
            return cart.reduce((total, item) => total + parseInt(item.quantidade, 10), 0);
        }
    }
    return 0;
}

// Atualiza o contador do carrinho
function updateCartCount() {
    const cartCountElement = document.getElementById('cart-count');
    if (cartCountElement) {
        const count = getCartCount();
        cartCountElement.textContent = count;
    }
}

// Atualiza o contador ao carregar a página
document.addEventListener('DOMContentLoaded', updateCartCount);
