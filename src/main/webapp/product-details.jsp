<%@ page import="model.Product" %>
<%@ page import="util.ImageUrlUtil" %>
<%
Product p = (Product) request.getAttribute("product");
String error = (String) request.getAttribute("errorMessage");
String defaultImageUrl = ImageUrlUtil.resolve(request, "images/products/default.webp");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Product Details | ShopSphere</title>
<style>
    :root { --bg:#07111f; --panel:#0c1728; --text:#d7e1ef; --muted:#8ea2bd; --line:rgba(255,255,255,.08); --accent:#0ea5e9; --accent-2:#22c55e; --accent-3:#f97316; }
    * { box-sizing:border-box; }
    body { margin:0; min-height:100vh; font-family:"Segoe UI", Arial, sans-serif; color:var(--text); background:linear-gradient(180deg, #07111f 0%, #0a1324 100%); }
    a { color:inherit; text-decoration:none; }
    .wrap { width:min(1180px, calc(100% - 32px)); margin:0 auto; padding:24px 0 36px; }
    .top {
        display:flex; justify-content:space-between; align-items:end; gap:16px; margin-bottom:18px; padding:20px 22px;
        border-radius:22px; border:1px solid var(--line); background:rgba(10,19,35,.9);
    }
    .top h1 { margin:0; font-size:32px; color:#fff; }
    .top p { margin:6px 0 0; color:var(--muted); }
    .btn {
        display:inline-flex; align-items:center; justify-content:center; min-height:46px; padding:0 16px; border-radius:14px; border:0; cursor:pointer; font-weight:900;
        transition:transform .2s;
    }
    .btn:hover { transform:translateY(-2px); }
    .btn-primary { background:linear-gradient(135deg, var(--accent), var(--accent-2)); color:#fff; }
    .btn-secondary { background:rgba(255,255,255,.06); color:#fff; border:1px solid var(--line); }
    .shell {
        display:grid; grid-template-columns: 1.05fr .95fr; gap:18px;
    }
    .media, .info {
        border-radius:24px; border:1px solid var(--line); background:rgba(10,19,35,.9); box-shadow:0 24px 60px rgba(0,0,0,.22);
        overflow:hidden;
    }
    .media { padding:18px; }
    .media img {
        width:100%; aspect-ratio: 1 / 1; object-fit:cover; border-radius:20px; background:#0b1423;
    }
    .info { padding:24px; }
    .eyebrow {
        display:inline-flex; align-items:center; min-height:34px; padding:0 12px; border-radius:999px; background:rgba(14,165,233,.12);
        color:#8bdcff; font-size:12px; font-weight:900; letter-spacing:.12em; text-transform:uppercase;
    }
    h2 { margin:14px 0 10px; font-size:36px; line-height:1; color:#fff; }
    .description { color:#bfd0e4; line-height:1.75; font-size:16px; }
    .stats { display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:12px; margin:18px 0; }
    .mini {
        padding:14px; border-radius:16px; background:rgba(255,255,255,.05); border:1px solid var(--line);
    }
    .mini strong { display:block; color:#fff; font-size:22px; }
    .mini span { color:var(--muted); font-size:12px; }
    .price {
        margin:18px 0 0;
        color:#fff;
        font-size:40px;
        font-weight:900;
    }
    .stock { margin:10px 0 0; color:#bfd0e4; }
    .actions { display:flex; gap:12px; flex-wrap:wrap; margin-top:22px; }
    .meta {
        display:grid; gap:10px; margin-top:24px; padding-top:18px; border-top:1px solid var(--line); color:#bfd0e4; line-height:1.7;
    }
    .meta strong { color:#fff; }
    .empty {
        padding:36px; border-radius:22px; background:rgba(10,19,35,.9); border:1px solid var(--line); text-align:center;
    }
    .empty h1 { margin:0; color:#fff; font-size:32px; }
    .empty p { color:var(--muted); line-height:1.7; }
    .error { color:#ffb4b4; }
    @media (max-width: 960px) { .shell { grid-template-columns:1fr; } .stats { grid-template-columns:1fr; } }
</style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div>
            <div class="eyebrow">Product detail</div>
            <h1>View item information</h1>
            <p>Open a product, compare the details, and add it to cart.</p>
        </div>
        <div class="actions">
            <a class="btn btn-secondary" href="ProductServlet">Back to products</a>
            <a class="btn btn-primary" href="CartServlet">Go to cart</a>
        </div>
    </div>

    <%
    if (error != null) {
    %>
    <div class="empty">
        <h1>Unable to load product</h1>
        <p class="error"><%= error %></p>
        <a class="btn btn-primary" href="<%= request.getContextPath() %>/ProductServlet">Back to products</a>
    </div>
    <%
    } else if (p != null) {
    %>
    <section class="shell">
        <div class="media">
            <img src="<%= ImageUrlUtil.resolve(request, p.getImageUrl()) %>"
                 alt="<%= p.getProductName() %>"
                 onerror="this.onerror=null;this.src='<%= defaultImageUrl %>';">
        </div>
        <div class="info">
            <div class="eyebrow">Featured product</div>
            <h2><%= p.getProductName() %></h2>
            <p class="description"><%= p.getDescription() %></p>
            <div class="stats">
                <div class="mini"><strong>&#8377;<%= p.getPrice() %></strong><span>Current price</span></div>
                <div class="mini"><strong><%= p.getStock() %></strong><span>Units available</span></div>
                <div class="mini"><strong>Fast</strong><span>Checkout ready</span></div>
            </div>
            <div class="price">&#8377;<%= p.getPrice() %></div>
            <p class="stock">Stock available: <%= p.getStock() %></p>
            <div class="actions">
                <a href="AddToCartServlet?id=<%= p.getProductId() %>" class="btn btn-primary">Add to cart</a>
                <a href="ProductServlet" class="btn btn-secondary">Continue shopping</a>
            </div>
            <div class="meta">
                <div><strong>Category:</strong> Product catalog item</div>
                <div><strong>Product ID:</strong> <%= p.getProductId() %></div>
                <div><strong>Store:</strong> ShopSphere</div>
            </div>
        </div>
    </section>
    <%
    }
    %>
</div>
</body>
</html>
