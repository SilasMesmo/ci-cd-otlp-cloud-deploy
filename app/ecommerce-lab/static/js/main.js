// API client for eCommerce operations

const api = {
    async getProducts() {
        const res = await fetch('/api/products');
        return res.json();
    },
    async getProduct(id) {
        const res = await fetch(`/api/products/${id}`);
        return res.json();
    },
    async getCart() {
        const res = await fetch('/api/cart');
        return res.json();
    },
    async addToCart(productId, quantity = 1) {
        const res = await fetch('/api/cart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ product_id: productId, quantity })
        });
        return res.json();
    },
    async removeFromCart(itemId) {
        await fetch(`/api/cart/${itemId}`, { method: 'DELETE' });
    },
    async checkout(customerName, customerEmail) {
        const res = await fetch('/api/checkout', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ customer_name: customerName, customer_email: customerEmail })
        });
        if (!res.ok) {
            const data = await res.json();
            throw new Error(data.detail || 'Checkout failed');
        }
        return res.json();
    },
    async getOrders() {
        const res = await fetch('/api/orders');
        return res.json();
    }
};

// UI Helpers
function showToast(message) {
    let toast = document.getElementById('toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'toast';
        toast.className = 'toast';
        document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.style.display = 'block';
    setTimeout(() => {
        toast.style.display = 'none';
    }, 3000);
}

// Global actions
async function handleAddToCart(productId) {
    try {
        await api.addToCart(productId);
        showToast('Produto adicionado ao carrinho!');
        updateCartCount();
    } catch (e) {
        alert('Erro ao adicionar ao carrinho');
    }
}

async function updateCartCount() {
    try {
        const cart = await api.getCart();
        const count = cart.reduce((acc, item) => acc + item.quantity, 0);
        const countEl = document.getElementById('cart-count');
        if (countEl) countEl.textContent = count;
    } catch (e) {
        console.error('Failed to update cart count', e);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    updateCartCount();
});
