<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%
    List<Product> cartProducts = (List<Product>) request.getAttribute("cartProducts");
    Double grandTotalObj = (Double) request.getAttribute("grandTotal");
    double grandTotal = grandTotalObj != null ? grandTotalObj : 0.0;
    Object invoiceDate = request.getAttribute("invoiceDate");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Invoice | ShopSphere</title>
<style>
    :root { --bg:#07111f; --panel:#0c1728; --text:#d7e1ef; --muted:#8ea2bd; --line:rgba(255,255,255,.08); --accent:#0ea5e9; --accent-2:#22c55e; }
    * { box-sizing:border-box; }
    html { scroll-behavior:smooth; }
    body {
        margin:0; min-height:100vh; font-family:"Segoe UI", Arial, sans-serif; color:var(--text);
        background:linear-gradient(180deg, #07111f 0%, #0a1324 100%);
        opacity:0; transition:opacity .18s ease;
    }
    body.is-ready { opacity:1; }
    .wrap { width:min(1180px, calc(100% - 32px)); margin:0 auto; padding:24px 0 36px; }
    .top { padding:22px; border-radius:22px; border:1px solid var(--line); background:rgba(10,19,35,.9); box-shadow:0 24px 60px rgba(0,0,0,.22); }
    .top h1 { margin:0; color:#fff; font-size:34px; }
    .top p { margin:8px 0 0; color:var(--muted); line-height:1.7; }
    .badge { display:inline-flex; align-items:center; min-height:30px; padding:0 10px; border-radius:999px; background:rgba(14,165,233,.12); color:#8bdcff; font-size:12px; font-weight:900; }
    .layout { display:grid; grid-template-columns:1fr 330px; gap:18px; margin-top:18px; }
    .panel { border-radius:24px; border:1px solid var(--line); background:rgba(10,19,35,.9); overflow:hidden; box-shadow:0 24px 60px rgba(0,0,0,.22); }
    .panel-head { padding:20px 22px; border-bottom:1px solid var(--line); display:flex; justify-content:space-between; align-items:end; gap:16px; }
    .panel-head h2 { margin:0; color:#fff; font-size:24px; }
    .panel-head p { margin:6px 0 0; color:var(--muted); }
    table { width:100%; border-collapse:collapse; }
    th, td { padding:16px 22px; border-bottom:1px solid rgba(255,255,255,.06); text-align:left; }
    th { color:#b8c8da; font-size:12px; font-weight:900; letter-spacing:.12em; text-transform:uppercase; background:rgba(255,255,255,.03); }
    td { color:#e8f0fa; }
    .summary { padding:22px; }
    .summary-card { padding:18px; border-radius:18px; background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.06); }
    .summary-card h3 { margin:0; color:#fff; font-size:22px; }
    .row { display:flex; justify-content:space-between; gap:16px; padding:12px 0; border-bottom:1px solid rgba(255,255,255,.06); }
    .row:last-child { border-bottom:0; }
    .row span:last-child { color:#fff; font-weight:900; }
    .total { margin-top:14px; padding-top:14px; border-top:1px solid rgba(255,255,255,.08); display:flex; justify-content:space-between; font-size:22px; font-weight:900; color:#fff; }
    .btn {
        display:inline-flex; align-items:center; justify-content:center; min-height:46px; padding:0 16px; border-radius:14px; border:0; cursor:pointer; font-weight:900;
        text-decoration:none; transition:transform .2s;
    }
    .btn:hover { transform:translateY(-2px); }
    .btn-primary { background:linear-gradient(135deg, var(--accent), var(--accent-2)); color:#fff; }
    .meta { margin-top:14px; padding:18px; border-radius:18px; background:linear-gradient(135deg, rgba(14,165,233,.16), rgba(34,197,94,.12)); border:1px solid rgba(255,255,255,.08); }
    .meta p { margin:0; color:#d9e9f7; line-height:1.7; }
    .empty { padding:32px 22px; color:var(--muted); text-align:center; }
    .btn-stack { display:grid; gap:10px; margin-top:18px; }
    @media (max-width: 960px) { .layout { grid-template-columns:1fr; } }
</style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div class="badge">Invoice preview</div>
        <h1>Checkout invoice</h1>
        <p>Review the final cart breakdown before confirming the order.</p>
        <p><strong>Date:</strong> <%= invoiceDate %></p>
    </div>

    <div class="layout">
        <section class="panel">
            <div class="panel-head">
                <div>
                    <h2>Order items</h2>
                    <p>Product, quantity, and line totals.</p>
                </div>
                <div class="badge"><%= cartProducts != null ? cartProducts.size() : 0 %> items</div>
            </div>
            <table>
                <thead>
                <tr>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (cartProducts != null && !cartProducts.isEmpty()) {
                        for (Product p : cartProducts) {
                %>
                <tr>
                    <td><%= p.getProductName() %></td>
                    <td>&#8377;<%= p.getPrice() %></td>
                    <td><%= p.getQuantity() %></td>
                    <td>&#8377;<%= p.getPrice() * p.getQuantity() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4" class="empty">No products found.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </section>

        <aside class="summary">
            <div class="summary-card">
                <h3>Summary</h3>
            <div class="row"><span>Items</span><span><%= cartProducts != null ? cartProducts.size() : 0 %></span></div>
            <div class="row"><span>Shipping</span><span>Free</span></div>
            <div class="row"><span>GST</span><span>Included</span></div>
            <div class="total">
                <span>Total</span>
                <span><%= grandTotal > 0 ? "Rs " + String.format(java.util.Locale.US, "%.2f", grandTotal) : "Pending" %></span>
            </div>
            <div class="btn-stack">
                <a class="btn btn-primary" href="OrderConfirmationServlet">Confirm order</a>
                <a class="btn btn-secondary" href="InvoicePdfServlet">Download PDF</a>
            </div>
        </div>
        <div class="meta">
            <p>The invoice page keeps the total visible and moves directly into the order confirmation flow.</p>
        </div>
    </aside>
</div>
</div>
<script>
(function () {
    document.body.classList.add("is-ready");
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
