<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List,model.Product,util.ImageUrlUtil" %>
<%
    List<Product> cartProducts = (List<Product>) request.getAttribute("cartProducts");
    Double grandTotalObj = (Double) request.getAttribute("grandTotal");
    double grandTotal = (grandTotalObj != null) ? grandTotalObj : 0.0;
    int itemCount = (cartProducts != null) ? cartProducts.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Cart | ShopSphere</title>
<style>
    :root { --bg:#07111f; --panel:#0c1728; --text:#d7e1ef; --muted:#8ea2bd; --line:rgba(255,255,255,.08); --accent:#0ea5e9; --accent-2:#22c55e; --accent-3:#f97316; }
    * { box-sizing:border-box; }
    html { scroll-behavior:smooth; }
    body {
        margin:0; min-height:100vh; font-family:"Segoe UI", Arial, sans-serif; color:var(--text);
        background:linear-gradient(180deg, #07111f 0%, #0a1324 100%);
        opacity:0; transition:opacity .18s ease;
    }
    body.is-ready { opacity:1; }
    a { color:inherit; text-decoration:none; }
    .topbar {
        display:flex; justify-content:center; gap:18px; padding:10px 16px; background:rgba(255,255,255,.04); border-bottom:1px solid var(--line);
        color:#c8d5e6; font-size:12px; font-weight:700; flex-wrap:wrap;
    }
    .navbar {
        display:flex; align-items:center; justify-content:space-between; gap:16px; padding:18px 5%; position:sticky; top:0; z-index:20;
        backdrop-filter:blur(18px); background:rgba(7,17,31,.86); border-bottom:1px solid var(--line);
    }
    .brand { display:inline-flex; align-items:center; gap:10px; font-size:28px; font-weight:900; color:#fff; }
    .mark { width:36px; height:36px; border-radius:10px; display:grid; place-items:center; background:linear-gradient(135deg, var(--accent-2), var(--accent)); }
    .links { display:flex; gap:8px; list-style:none; margin:0; padding:0; flex-wrap:wrap; }
    .links a { display:inline-flex; align-items:center; min-height:40px; padding:0 14px; border-radius:999px; color:#cbd6e4; font-weight:800; }
    .links a:hover { background:rgba(255,255,255,.06); color:#fff; }
    .btn {
        display:inline-flex; align-items:center; justify-content:center; min-height:42px; padding:0 16px; border-radius:999px; border:0; cursor:pointer; font-weight:900;
        transition:transform .2s;
    }
    .btn:hover { transform:translateY(-2px); }
    .btn-primary { background:linear-gradient(135deg, var(--accent), var(--accent-2)); color:#fff; }
    .btn-secondary { background:rgba(255,255,255,.06); color:#fff; border:1px solid var(--line); }
    .hero {
        width:min(1280px, calc(100% - 32px)); margin:22px auto 0; padding:26px; border-radius:24px; border:1px solid var(--line); background:rgba(10,19,35,.9);
        display:flex; justify-content:space-between; align-items:end; gap:16px; flex-wrap:wrap; box-shadow:0 24px 60px rgba(0,0,0,.22);
    }
    .hero h1 { margin:0; font-size:34px; color:#fff; }
    .hero p { margin:8px 0 0; color:var(--muted); line-height:1.7; }
    .badge { display:inline-flex; align-items:center; min-height:30px; padding:0 10px; border-radius:999px; background:rgba(14,165,233,.12); color:#8bdcff; font-size:12px; font-weight:900; }
    .layout { width:min(1280px, calc(100% - 32px)); margin:18px auto 36px; display:grid; grid-template-columns: 1fr 360px; gap:18px; }
    .panel { padding:0; border-radius:24px; border:1px solid var(--line); background:rgba(10,19,35,.9); box-shadow:0 24px 60px rgba(0,0,0,.22); overflow:hidden; }
    .panel-head { padding:22px; border-bottom:1px solid var(--line); display:flex; justify-content:space-between; align-items:end; gap:16px; }
    .panel-head h2 { margin:0; font-size:24px; color:#fff; }
    .panel-head p { margin:6px 0 0; color:var(--muted); }
    table { width:100%; border-collapse:collapse; }
    th, td { padding:18px 22px; border-bottom:1px solid rgba(255,255,255,.06); vertical-align:middle; }
    th { color:#b8c8da; font-size:12px; font-weight:900; letter-spacing:.12em; text-transform:uppercase; background:rgba(255,255,255,.03); }
    td { color:#e8f0fa; }
    tr:hover td { background:rgba(255,255,255,.03); }
    .product {
        display:flex; align-items:center; gap:14px;
    }
    .thumb { width:64px; height:64px; border-radius:14px; object-fit:cover; background:#0b1423; border:1px solid var(--line); }
    .name { font-weight:900; color:#fff; }
    .meta { margin-top:4px; color:var(--muted); font-size:12px; }
    .price, .subtotal { font-weight:900; color:#fff; }
    .qty-form { display:flex; align-items:center; gap:8px; justify-content:center; flex-wrap:wrap; }
    .qty-form input {
        width:78px; min-height:42px; padding:0 10px; border-radius:12px; border:1px solid rgba(255,255,255,.1); background:rgba(255,255,255,.04); color:#fff; text-align:center;
    }
    .qty-form input:focus { outline:none; border-color:rgba(14,165,233,.7); box-shadow:0 0 0 4px rgba(14,165,233,.14); }
    .remove { display:inline-flex; align-items:center; justify-content:center; min-height:42px; padding:0 14px; border-radius:14px; background:rgba(249,115,22,.12); border:1px solid rgba(249,115,22,.18); color:#ffb28a; font-weight:900; }
    .empty {
        padding:48px 22px; text-align:center; color:var(--muted);
    }
    .empty h3 { margin:0; font-size:26px; color:#fff; }
    .empty p { margin:10px 0 0; line-height:1.7; }
    .summary { display:grid; gap:14px; padding:22px; }
    .summary-card { padding:18px; border-radius:18px; background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.06); }
    .summary-card h3 { margin:0; color:#fff; font-size:22px; }
    .summary-row {
        display:flex; justify-content:space-between; gap:16px; padding:12px 0; border-bottom:1px solid rgba(255,255,255,.06); color:#dbe7f5;
    }
    .summary-row:last-child { border-bottom:0; }
    .total {
        margin-top:14px; padding-top:14px; border-top:1px solid rgba(255,255,255,.08); display:flex; justify-content:space-between; align-items:center;
        font-size:22px; font-weight:900; color:#fff;
    }
    .summary .btn { width:100%; margin-top:6px; }
    .promo {
        margin-top:14px; padding:18px; border-radius:18px; background:linear-gradient(135deg, rgba(14,165,233,.16), rgba(34,197,94,.12)); border:1px solid rgba(255,255,255,.08);
    }
    .promo p { margin:0; color:#d9e9f7; line-height:1.7; }
    .footer {
        width:min(1280px, calc(100% - 32px)); margin:0 auto 26px; padding-top:18px; border-top:1px solid var(--line); color:var(--muted); font-size:13px;
        display:flex; justify-content:space-between; gap:16px; flex-wrap:wrap;
    }
    @media (max-width: 1020px) { .layout { grid-template-columns:1fr; } }
    @media (max-width: 760px) {
        .navbar { padding:14px 4%; }
        .links { display:none; }
        .hero, .layout { width:min(100% - 16px, 1280px); }
        th:nth-child(3), td:nth-child(3), th:nth-child(4), td:nth-child(4) { display:none; }
    }
</style>
</head>
<body>
<div class="topbar">
    <span>Free shipping over <strong>&#8377;999</strong></span>
    <span>Easy returns within 30 days</span>
    <span>Secure checkout</span>
</div>

<nav class="navbar">
    <a class="brand" href="index.html"><span class="mark">S</span><span>ShopSphere</span></a>
    <ul class="links">
        <li><a href="index.html">Home</a></li>
        <li><a href="ProductServlet">Products</a></li>
        <li><a href="index.html#about">About</a></li>
    </ul>
    <div>
        <a class="btn btn-secondary" href="ProductServlet">Continue shopping</a>
    </div>
</nav>

<section class="hero">
    <div>
        <div class="badge">Secure cart</div>
        <h1>Your shopping bag</h1>
        <p><%= itemCount %> item<%= itemCount != 1 ? "s" : "" %> ready for review.</p>
    </div>
    <a class="btn btn-primary" href="InvoiceServlet">Checkout now</a>
</section>

<section class="layout">
    <div class="panel">
        <div class="panel-head">
            <div>
                <h2>Cart items</h2>
                <p>Update quantity or remove items before checkout.</p>
            </div>
            <div class="badge"><%= itemCount %> items</div>
        </div>

        <% if (cartProducts != null && !cartProducts.isEmpty()) { %>
        <table>
            <thead>
            <tr>
                <th>Product</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Subtotal</th>
                <th>Remove</th>
            </tr>
            </thead>
            <tbody>
            <% for (Product p : cartProducts) { %>
            <tr>
                <td>
                    <div class="product">
                        <img class="thumb" src="<%= ImageUrlUtil.resolve(request, p.getImageUrl()) %>" alt="<%= p.getProductName() %>">
                        <div>
                            <div class="name"><%= p.getProductName() %></div>
                            <div class="meta">SKU #<%= p.getProductId() %></div>
                        </div>
                    </div>
                </td>
                <td class="price">&#8377;<%= p.getPrice() %></td>
                <td>
                    <form class="qty-form" action="<%=request.getContextPath()%>/UpdateCartServlet" method="post">
                        <input type="hidden" name="id" value="<%= p.getProductId() %>">
                        <input type="number" name="quantity" value="<%= p.getQuantity() %>" min="1">
                        <button class="btn btn-secondary" type="submit">Update</button>
                    </form>
                </td>
                <td class="subtotal">&#8377;<%= p.getPrice() * p.getQuantity() %></td>
                <td><a class="remove" href="<%=request.getContextPath()%>/RemoveFromCartServlet?id=<%= p.getProductId() %>">Remove</a></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="empty">
            <h3>Your cart is empty</h3>
            <p>Browse the catalog and add products you want to buy.</p>
            <a class="btn btn-primary" href="ProductServlet">Browse products</a>
        </div>
        <% } %>
    </div>

    <aside class="summary">
        <div class="summary-card">
            <h3>Order summary</h3>
            <div class="summary-row"><span>Items</span><span><%= itemCount %></span></div>
            <div class="summary-row"><span>Shipping</span><span>Free</span></div>
            <div class="summary-row"><span>GST</span><span>Included</span></div>
            <div class="total"><span>Total</span><span>&#8377;<%= grandTotal %></span></div>
            <a class="btn btn-primary" href="InvoiceServlet">Proceed to checkout</a>
        </div>
        <div class="promo">
            <p>ShopSphere checkout keeps the next step simple with direct invoice generation and clear order totals.</p>
        </div>
    </aside>
</section>

<footer class="footer">
    <span><strong>ShopSphere</strong> cart and checkout flow</span>
    <span>Fast review, update, and payment handoff</span>
</footer>
<script>
(function () {
    document.body.classList.add("is-ready");
    document.querySelectorAll("form").forEach(function (form) {
        form.addEventListener("submit", function () {
            document.body.classList.remove("is-ready");
        });
    });
    document.addEventListener("click", function (event) {
        const link = event.target.closest("a[href]");
        if (!link || link.target || link.hasAttribute("download")) {
            return;
        }
        const url = new URL(link.href, window.location.href);
        if (url.origin !== window.location.origin || url.href === window.location.href) {
            return;
        }
        event.preventDefault();
        document.body.classList.remove("is-ready");
        window.setTimeout(function () {
            window.location.href = url.href;
        }, 140);
    });
})();
</script>
</body>
</html>
