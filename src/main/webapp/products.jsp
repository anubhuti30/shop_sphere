<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ page import="util.ImageUrlUtil" %>
<%
List<Product> products = (List<Product>) request.getAttribute("products");
String error = (String) request.getAttribute("errorMessage");
String keyword = (String) request.getAttribute("keyword");
if (keyword == null) {
    keyword = request.getParameter("keyword");
}
if (keyword == null) {
    keyword = "";
}
String defaultImageUrl = ImageUrlUtil.resolve(request, "images/products/default.webp");
String customerName = (String) session.getAttribute("username");
String loginTime = (String) session.getAttribute("loginTime");
@SuppressWarnings("unchecked")
List<Product> recentlyViewed = (List<Product>) session.getAttribute("recentlyViewedProducts");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Products | ShopSphere</title>
<style>
    :root { --bg:#07111f; --panel:#0c1728; --panel-soft:#111f33; --surface:#fff; --text:#d7e1ef; --muted:#8ea2bd; --line:rgba(255,255,255,.08); --accent:#0ea5e9; --accent-2:#22c55e; --accent-3:#f97316; --accent-4:#facc15; }
    * { box-sizing:border-box; }
    html { scroll-behavior:smooth; }
    body {
        margin:0;
        font-family:"Segoe UI", Arial, sans-serif;
        color:var(--text);
        background:linear-gradient(180deg, #07111f 0%, #0a1324 100%);
        opacity:0;
        transition:opacity .18s ease;
    }
    body.is-ready { opacity:1; }
    a { color:inherit; text-decoration:none; }
    button, input { font:inherit; }
    .topbar {
        display:flex; justify-content:center; gap:18px; padding:10px 16px; background:rgba(255,255,255,.04); border-bottom:1px solid var(--line);
        color:#c8d5e6; font-size:12px; font-weight:700; flex-wrap:wrap;
    }
    .topbar span { color:var(--muted); }
    .topbar strong { color:var(--accent-4); }
    .navbar {
        position:sticky; top:0; z-index:20;
        display:flex; align-items:center; justify-content:space-between; gap:18px;
        padding:18px 5%; backdrop-filter:blur(18px);
        background:rgba(7,17,31,.86); border-bottom:1px solid var(--line);
    }
    .brand { display:inline-flex; align-items:center; gap:10px; font-size:28px; font-weight:900; color:#fff; }
    .mark {
        width:36px; height:36px; border-radius:10px; display:grid; place-items:center;
        background:linear-gradient(135deg, var(--accent-2), var(--accent)); color:#fff;
    }
    .nav-links { display:flex; gap:6px; list-style:none; margin:0; padding:0; flex-wrap:wrap; }
    .nav-links a {
        display:inline-flex; align-items:center; min-height:40px; padding:0 14px; border-radius:999px;
        color:#cbd6e4; font-size:13px; font-weight:800;
    }
    .nav-links a:hover { background:rgba(255,255,255,.06); color:#fff; }
    .nav-actions { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
    .search-form {
        display:flex; align-items:center; gap:8px; padding:6px; border-radius:999px; background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.08);
    }
    .search-form input {
        width:min(28vw, 300px); min-height:36px; padding:0 14px; border:0; outline:0; background:transparent; color:#fff;
    }
    .search-form input::placeholder { color:#96a7bc; }
    .search-form button,
    .btn,
    .auth-link,
    .cart-button {
        display:inline-flex; align-items:center; justify-content:center; min-height:42px; padding:0 16px; border-radius:999px; border:0; cursor:pointer;
        font-weight:900; transition:transform .2s, box-shadow .2s, background .2s, color .2s;
    }
    .search-form button, .btn-primary, .cart-button { background:linear-gradient(135deg, var(--accent), var(--accent-2)); color:#fff; box-shadow:0 12px 28px rgba(14,165,233,.22); }
    .auth-link, .btn-secondary { background:rgba(255,255,255,.06); color:#fff; border:1px solid rgba(255,255,255,.08); }
    .search-form button:hover, .btn:hover, .auth-link:hover, .cart-button:hover { transform:translateY(-2px); }
    .section, .hero { width:min(1280px, calc(100% - 32px)); margin:0 auto; }
    .hero {
        display:grid; grid-template-columns:1.05fr .95fr; gap:24px; align-items:center; padding:28px 0 18px;
    }
    .eyebrow {
        display:inline-flex; align-items:center; min-height:34px; padding:0 12px; border-radius:999px;
        background:rgba(14,165,233,.12); color:#8bdcff; font-size:12px; font-weight:900; letter-spacing:.12em; text-transform:uppercase;
    }
    .hero h1 { margin:14px 0 0; font-size:clamp(38px, 5vw, 62px); line-height:.95; color:#fff; }
    .hero p { margin:18px 0 0; color:#bfd0e4; line-height:1.7; max-width:60ch; }
    .hero-actions { display:flex; gap:12px; flex-wrap:wrap; margin-top:22px; }
    .hero-card {
        min-height:260px; border-radius:24px; overflow:hidden; border:1px solid var(--line); box-shadow:0 24px 60px rgba(0,0,0,.2);
        background:
            linear-gradient(180deg, rgba(7,17,31,.06), rgba(7,17,31,.82)),
            url("images/products/01-iphone-15.webp") center/cover;
    }
    .hero-card .overlay {
        display:flex; flex-direction:column; justify-content:flex-end; min-height:260px; padding:18px; color:#fff;
        background:linear-gradient(180deg, rgba(7,17,31,.05), rgba(7,17,31,.6));
    }
    .hero-card strong { font-size:24px; }
    .hero-card p { margin:8px 0 0; color:#d0dded; }
    .section-head {
        display:flex; justify-content:space-between; align-items:end; gap:16px; margin:20px 0 16px;
    }
    .section-head h2 { margin:0; color:#fff; font-size:30px; }
    .section-head p { margin:6px 0 0; color:var(--muted); }
    .summary-bar {
        display:flex; gap:10px; flex-wrap:wrap; margin:0 0 16px;
    }
    .summary-chip {
        display:inline-flex; align-items:center; min-height:34px; padding:0 12px; border-radius:999px; background:rgba(255,255,255,.06);
        border:1px solid rgba(255,255,255,.08); color:#fff; font-size:12px; font-weight:800;
    }
    .catalog {
        display:grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap:18px;
        padding-bottom:38px;
    }
    .card {
        display:flex; flex-direction:column; gap:12px; padding:14px; border-radius:18px; background:rgba(255,255,255,.05); border:1px solid var(--line);
        transition:transform .2s, border-color .2s, background .2s;
    }
    .card:hover { transform:translateY(-4px); background:rgba(255,255,255,.08); border-color:rgba(14,165,233,.22); }
    .card img { width:100%; aspect-ratio:1/1; object-fit:cover; border-radius:14px; background:#0b1423; }
    .card h2, .card h3 { margin:0; color:#fff; font-size:18px; }
    .description { margin:0; color:#bfd0e4; line-height:1.6; min-height:48px; }
    .price { margin:0; color:#fff; font-size:18px; font-weight:900; }
    .stock { margin:0; color:var(--muted); font-size:13px; }
    .card-actions { display:flex; gap:10px; flex-wrap:wrap; margin-top:auto; }
    .card-actions .btn { flex:1; }
    .empty-message {
        grid-column:1 / -1; text-align:center; color:var(--muted); padding:34px 18px; border-radius:18px; background:rgba(255,255,255,.04); border:1px solid var(--line);
    }
    .details-modal {
        position:fixed; inset:0; display:none; align-items:center; justify-content:center; background:rgba(0,0,0,.5); padding:20px; z-index:30;
    }
    .details-modal.open { display:flex; }
    .details-dialog {
        width:min(780px, 100%); max-height:90vh; overflow:auto; padding:22px; border-radius:22px; background:#0c1728; border:1px solid var(--line); box-shadow:0 28px 70px rgba(0,0,0,.35);
    }
    .details-close {
        position:sticky; top:0; float:right; width:38px; height:38px; border:0; border-radius:50%; cursor:pointer; background:rgba(255,255,255,.08); color:#fff; font-size:22px;
    }
    .details-dialog img { width:100%; max-height:360px; object-fit:cover; border-radius:18px; margin-bottom:16px; }
    .details-dialog h1 { color:#fff; margin:0 0 8px; font-size:34px; }
    .details-dialog p { color:#bfd0e4; line-height:1.7; }
    .error { color:#ffb4b4; }
    .sidebar-promo {
        width:min(1280px, calc(100% - 32px)); margin:0 auto 30px; padding:22px; border-radius:22px; background:linear-gradient(135deg, rgba(14,165,233,.18), rgba(34,197,94,.12)); border:1px solid rgba(255,255,255,.08);
        display:flex; justify-content:space-between; align-items:center; gap:16px; flex-wrap:wrap;
    }
    .sidebar-promo strong { color:#fff; font-size:24px; }
    .footer {
        width:min(1280px, calc(100% - 32px)); margin:0 auto 26px; padding-top:18px; border-top:1px solid var(--line); color:var(--muted); font-size:13px;
        display:flex; justify-content:space-between; gap:16px; flex-wrap:wrap;
    }
    .session-strip {
        width:min(1280px, calc(100% - 32px));
        margin:18px auto 0;
        display:grid;
        grid-template-columns:repeat(3, minmax(0, 1fr));
        gap:12px;
    }
    .session-card {
        padding:16px;
        border-radius:18px;
        background:rgba(255,255,255,.05);
        border:1px solid var(--line);
    }
    .session-card .label {
        color:var(--muted);
        font-size:12px;
        font-weight:900;
        letter-spacing:.12em;
        text-transform:uppercase;
    }
    .session-card .value {
        margin-top:8px;
        color:#fff;
        font-size:16px;
        font-weight:900;
        line-height:1.4;
    }
    .session-card .sub {
        margin-top:6px;
        color:#bfd0e4;
        font-size:13px;
        line-height:1.6;
    }
    .viewed-strip {
        width:min(1280px, calc(100% - 32px));
        margin:18px auto 0;
        padding:18px;
        border-radius:22px;
        border:1px solid var(--line);
        background:rgba(10,19,35,.9);
    }
    .viewed-strip h3 {
        margin:0 0 14px;
        color:#fff;
        font-size:22px;
    }
    .viewed-row {
        display:grid;
        grid-template-columns:repeat(4, minmax(0, 1fr));
        gap:12px;
    }
    .viewed-item {
        display:flex;
        gap:12px;
        align-items:center;
        padding:10px;
        border-radius:16px;
        background:rgba(255,255,255,.04);
        border:1px solid rgba(255,255,255,.06);
    }
    .viewed-item img {
        width:56px;
        height:56px;
        border-radius:12px;
        object-fit:cover;
        background:#0b1423;
        flex-shrink:0;
    }
    .viewed-item strong { display:block; color:#fff; font-size:14px; line-height:1.3; }
    .viewed-item span { display:block; margin-top:3px; color:var(--muted); font-size:12px; }
    .session-actions {
        display:flex;
        gap:10px;
        flex-wrap:wrap;
        margin-top:8px;
    }
    @media (max-width: 1120px) { .hero { grid-template-columns:1fr; } .catalog { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
    @media (max-width: 760px) {
        .navbar { padding:14px 4%; }
        .nav-links { display:none; }
        .search-form input { width:42vw; }
        .catalog { grid-template-columns:1fr; }
        .section-head { flex-direction:column; align-items:flex-start; }
    }
</style>
</head>
<body>
<div class="topbar">
    <span>Free shipping over <strong>&#8377;999</strong></span>
    <span>Fast dispatch across major cities</span>
    <span>Easy returns within 30 days</span>
</div>

<nav class="navbar">
    <a class="brand" href="index.html"><span class="mark">S</span><span>ShopSphere</span></a>
    <ul class="nav-links">
        <li><a href="index.html">Home</a></li>
        <li><a class="active" href="ProductServlet">Shop</a></li>
        <li><a href="index.html#about">About</a></li>
        <li><a href="CartServlet">Cart</a></li>
    </ul>
    <div class="nav-actions">
        <form class="search-form" id="searchForm" action="<%= request.getContextPath() %>/ProductServlet" method="get">
            <input type="text" id="searchInput" name="keyword" value="<%= keyword %>" placeholder="Search products..." autocomplete="off">
            <button type="submit">Search</button>
        </form>
        <%
            if (customerName != null) {
        %>
        <a class="auth-link" href="LogoutServlet">Logout</a>
        <a class="cart-button" href="CartServlet">Cart</a>
        <%
            } else {
        %>
        <a class="auth-link" href="u_login.html">Login</a>
        <a class="auth-link" href="u_register.html">Register</a>
        <a class="auth-link" href="login.jsp">Admin</a>
        <%
            }
        %>
    </div>
</nav>

<section class="session-strip">
    <div class="session-card">
        <div class="label">Session</div>
        <div class="value"><%= customerName != null ? customerName : "Guest" %></div>
        <div class="sub"><%= customerName != null ? "Signed in customer session" : "Browse and sign in to keep your cart" %></div>
    </div>
    <div class="session-card">
        <div class="label">Login time</div>
        <div class="value"><%= loginTime != null ? loginTime : "Not signed in" %></div>
        <div class="sub">Session state is preserved until logout or expiry.</div>
    </div>
    <div class="session-card">
        <div class="label">Quick actions</div>
        <div class="session-actions">
            <a class="btn btn-secondary" href="ProductServlet">Shop now</a>
            <a class="btn btn-primary" href="CartServlet">Open cart</a>
        </div>
    </div>
</section>

<section class="hero">
    <div>
        <div class="eyebrow">Catalog</div>
        <h1>Browse the full ShopSphere product lineup.</h1>
        <p>
            Search by category, compare prices, and open product details without leaving the catalog.
        </p>
        <div class="hero-actions">
            <a class="btn btn-primary" href="#catalog">Browse catalog</a>
            <a class="btn btn-secondary" href="ProductServlet">Reset search</a>
        </div>
    </div>
    <div class="hero-card">
        <div class="overlay">
            <div class="eyebrow">Featured category</div>
            <strong>Fast-moving electronics</strong>
            <p>Products optimized for quick shopping and clear comparison.</p>
        </div>
    </div>
</section>

<section class="section" id="catalog">
    <div class="section-head">
        <div>
            <div class="eyebrow">Shop</div>
            <h2>Products</h2>
            <p>Live search updates the catalog as you type.</p>
        </div>
        <div class="summary-chip"><%= products != null ? products.size() : 0 %> items</div>
    </div>

    <div class="summary-bar">
        <span class="summary-chip">Phones</span>
        <span class="summary-chip">Audio</span>
        <span class="summary-chip">Fashion</span>
        <span class="summary-chip">Home</span>
        <span class="summary-chip">Gaming</span>
    </div>

    <div class="catalog" id="productGrid">
        <%
        if (error != null) {
        %>
        <div class="empty-message"><%= error %></div>
        <%
        }
        if (products != null) {
            for (Product p : products) {
        %>
        <article class="card">
            <img src="<%= ImageUrlUtil.resolve(request, p.getImageUrl()) %>"
                 alt="<%= p.getProductName() %>"
                 onerror="this.onerror=null;this.src='<%= defaultImageUrl %>';">
            <h3><%= p.getProductName() %></h3>
            <p class="description"><%= p.getDescription() %></p>
            <p class="price">&#8377;<%= p.getPrice() %></p>
            <p class="stock">Stock: <%= p.getStock() %></p>
            <div class="card-actions">
                <a href="<%= request.getContextPath() %>/ProductDetailsServlet?id=<%= p.getProductId() %>" class="btn btn-secondary view-details-btn">View details</a>
                <a href="<%= request.getContextPath() %>/AddToCartServlet?id=<%= p.getProductId() %>" class="btn btn-primary">Add to cart</a>
            </div>
        </article>
        <%
            }
        }
        %>
    </div>
</section>

<section class="sidebar-promo">
    <div>
        <div class="eyebrow">Shopping tip</div>
        <strong>Use the product search to jump directly to the item you want.</strong>
    </div>
    <a class="btn btn-secondary" href="index.html#about">About ShopSphere</a>
</section>

<%
    if (recentlyViewed != null && !recentlyViewed.isEmpty()) {
%>
<section class="viewed-strip">
    <h3>Recently viewed</h3>
    <div class="viewed-row">
        <%
            for (Product viewed : recentlyViewed) {
        %>
        <a class="viewed-item" href="<%= request.getContextPath() %>/ProductDetailsServlet?id=<%= viewed.getProductId() %>">
            <img src="<%= ImageUrlUtil.resolve(request, viewed.getImageUrl()) %>" alt="<%= viewed.getProductName() %>">
            <div>
                <strong><%= viewed.getProductName() %></strong>
                <span>&#8377;<%= viewed.getPrice() %></span>
            </div>
        </a>
        <%
            }
        %>
    </div>
</section>
<%
    }
%>

<div class="details-modal" id="detailsModal">
    <div class="details-dialog">
        <button class="details-close" id="detailsClose" type="button">&times;</button>
        <div id="detailsContent"></div>
    </div>
</div>

<footer class="footer">
    <span><strong>ShopSphere</strong> product catalog</span>
    <span>Designed for fast browsing and clear checkout</span>
</footer>

<script>
(function () {
    document.body.classList.add("is-ready");
    const searchInput = document.getElementById("searchInput");
    const searchForm = document.getElementById("searchForm");
    const productGrid = document.getElementById("productGrid");
    const searchUrl = "<%= request.getContextPath() %>/SearchProductServlet";
    const detailsModal = document.getElementById("detailsModal");
    const detailsClose = document.getElementById("detailsClose");
    const detailsContent = document.getElementById("detailsContent");
    let searchTimer;

    function runLiveSearch() {
        fetch(searchUrl + "?keyword=" + encodeURIComponent(searchInput.value))
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Search request failed");
                }
                return response.text();
            })
            .then(function (html) {
                productGrid.innerHTML = html.trim()
                    ? html
                    : "<div class='empty-message'>No products found.</div>";
            })
            .catch(function () {
                productGrid.innerHTML = "<div class='empty-message'>Unable to search products.</div>";
            });
    }

    searchForm.addEventListener("submit", function (event) {
        event.preventDefault();
        runLiveSearch();
    });

    searchInput.addEventListener("input", function () {
        clearTimeout(searchTimer);
        searchTimer = setTimeout(function () {
            runLiveSearch();
        }, 250);
    });

    if (searchInput.value.trim()) {
        runLiveSearch();
    }

    productGrid.addEventListener("click", function (event) {
        const detailsLink = event.target.closest(".view-details-btn");
        if (!detailsLink) {
            return;
        }
        event.preventDefault();
        detailsContent.innerHTML = "<div class='empty-message'>Loading product details...</div>";
        detailsModal.classList.add("open");

        fetch(detailsLink.href + "&ajax=true", {
            headers: { "X-Requested-With": "XMLHttpRequest" }
        })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Details request failed");
                }
                return response.text();
            })
            .then(function (html) {
                detailsContent.innerHTML = html;
            })
            .catch(function () {
                detailsContent.innerHTML = "<div class='error'>Unable to load product details.</div>";
            });
    });

    detailsClose.addEventListener("click", function () {
        detailsModal.classList.remove("open");
    });

    detailsModal.addEventListener("click", function (event) {
        if (event.target === detailsModal) {
            detailsModal.classList.remove("open");
        }
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
