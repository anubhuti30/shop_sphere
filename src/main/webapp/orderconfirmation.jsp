<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%
List<Product> cartProducts = (List<Product>)request.getAttribute("cartProducts");
double grandTotal = (double)request.getAttribute("grandTotal");
String orderId = (String)request.getAttribute("orderId");
String orderDate = (String)request.getAttribute("orderDate");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation | ShopSphere</title>
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
        .wrap { width:min(1100px, calc(100% - 32px)); margin:0 auto; padding:24px 0 36px; }
        .panel { padding:24px; border-radius:24px; border:1px solid var(--line); background:rgba(10,19,35,.9); box-shadow:0 24px 60px rgba(0,0,0,.22); }
        .status {
            display:flex; align-items:center; gap:16px; padding:22px; border-radius:22px; background:linear-gradient(135deg, rgba(14,165,233,.16), rgba(34,197,94,.12));
            border:1px solid rgba(255,255,255,.08); margin-bottom:18px;
        }
        .mark {
            width:72px; height:72px; border-radius:22px; display:grid; place-items:center; background:rgba(34,197,94,.16); color:#8cffb8; font-size:28px; font-weight:900;
        }
        h1 { margin:0; font-size:34px; color:#fff; }
        p { margin:8px 0 0; color:#d9e9f7; line-height:1.7; }
        .grid { display:grid; grid-template-columns:1fr 330px; gap:18px; }
        .table-card, .summary { border-radius:24px; border:1px solid var(--line); background:rgba(10,19,35,.9); overflow:hidden; box-shadow:0 24px 60px rgba(0,0,0,.22); }
        .head { padding:20px 22px; border-bottom:1px solid var(--line); }
        .head h2 { margin:0; color:#fff; font-size:24px; }
        .head p { margin:6px 0 0; color:var(--muted); }
        table { width:100%; border-collapse:collapse; }
        th, td { padding:16px 22px; border-bottom:1px solid rgba(255,255,255,.06); text-align:left; }
        th { color:#b8c8da; font-size:12px; font-weight:900; letter-spacing:.12em; text-transform:uppercase; background:rgba(255,255,255,.03); }
        td { color:#e8f0fa; }
        .summary { padding:22px; }
        .summary h3 { margin:0; color:#fff; font-size:22px; }
        .row { display:flex; justify-content:space-between; gap:16px; padding:12px 0; border-bottom:1px solid rgba(255,255,255,.06); }
        .row:last-child { border-bottom:0; }
        .row span:last-child { color:#fff; font-weight:900; }
        .total { margin-top:14px; padding-top:14px; border-top:1px solid rgba(255,255,255,.08); display:flex; justify-content:space-between; font-size:24px; font-weight:900; color:#fff; }
        .btn {
            display:inline-flex; align-items:center; justify-content:center; min-height:46px; padding:0 16px; border-radius:14px; border:0; cursor:pointer; font-weight:900;
            text-decoration:none; transition:transform .2s;
        }
        .btn:hover { transform:translateY(-2px); }
        .btn-primary { background:linear-gradient(135deg, var(--accent), var(--accent-2)); color:#fff; }
        .btn-secondary { background:rgba(255,255,255,.06); color:#fff; border:1px solid var(--line); }
        .actions { display:flex; gap:12px; flex-wrap:wrap; margin-top:18px; }
        .note { margin-top:14px; color:var(--muted); line-height:1.7; }
        .empty { color:var(--muted); text-align:center; padding:24px; }
        .btn-stack { display:grid; gap:10px; margin-top:18px; }
        @media (max-width: 960px) { .grid { grid-template-columns:1fr; } .status { align-items:flex-start; } }
    </style>
</head>
<body>
<div class="wrap">
    <div class="status">
        <div class="mark">OK</div>
        <div>
            <h1>Order confirmed</h1>
            <p>Your order has been placed successfully.</p>
        </div>
    </div>

    <div class="grid">
        <section class="table-card">
            <div class="head">
                <h2>Order details</h2>
                <p>Order ID: <%= orderId %> | Date: <%= orderDate %></p>
            </div>
            <table>
                <thead>
                <tr>
                    <th>Product</th><th>Price</th><th>Description</th>
                </tr>
                </thead>
                <tbody>
                <%
                if(cartProducts != null && !cartProducts.isEmpty()){
                    for(Product p : cartProducts){
                %>
                <tr>
                    <td><%= p.getProductName() %></td>
                    <td>&#8377;<%= p.getPrice() %></td>
                    <td><%= p.getDescription() %></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr><td colspan="3" class="empty">No items were found for this order.</td></tr>
                <%
                }
                %>
                </tbody>
            </table>
        </section>

        <aside class="summary">
            <h3>Summary</h3>
            <div class="row"><span>Items</span><span><%= cartProducts != null ? cartProducts.size() : 0 %></span></div>
            <div class="row"><span>Status</span><span>Paid</span></div>
            <div class="row"><span>Shipping</span><span>Processing</span></div>
            <div class="total">
                <span>Total</span>
                <span><%= grandTotal > 0 ? "Rs " + String.format(java.util.Locale.US, "%.2f", grandTotal) : "Pending" %></span>
            </div>
            <div class="btn-stack">
                <a class="btn btn-primary" href="InvoicePdfServlet">Download PDF</a>
                <div class="actions">
                    <a class="btn btn-primary" href="ProductServlet">Continue shopping</a>
                    <a class="btn btn-secondary" href="products.jsp">Back to home</a>
                </div>
            </div>
            <div class="note">Thank you for shopping with ShopSphere.</div>
        </aside>
    </div>
</div>
<script>
(function () {
    document.body.classList.add("is-ready");
})();
</script>
</body>
</html>
