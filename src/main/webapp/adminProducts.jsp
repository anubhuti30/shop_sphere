<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Products | ShopSphere</title>
    <style>
        :root { --bg:#08111f; --panel:rgba(10,19,35,.9); --line:rgba(255,255,255,.08); --text:#e7eff9; --muted:#8fa4bc; --accent:#0ea5e9; --accent-2:#22c55e; --accent-3:#f97316; }
        * { box-sizing: border-box; }
        body { margin:0; min-height:100vh; font-family:"Segoe UI", Arial, sans-serif; color:var(--text); background:linear-gradient(180deg, #08111f 0%, #0b1424 100%); }
        a { color: inherit; text-decoration: none; }
        .wrap { width:min(1360px, calc(100% - 32px)); margin:0 auto; padding:24px 0 36px; }
        .top {
            display:flex; justify-content:space-between; align-items:end; gap:16px; margin-bottom:18px;
            padding:22px; border-radius:22px; border:1px solid var(--line); background:var(--panel);
        }
        .top h1 { margin:0; font-size:32px; }
        .top p { margin:6px 0 0; color:var(--muted); }
        .btn {
            display:inline-flex; align-items:center; justify-content:center; min-height:46px; padding:0 16px;
            border-radius:14px; border:0; cursor:pointer; font-weight:900; transition:transform .2s;
        }
        .btn:hover { transform:translateY(-2px); }
        .btn-primary { background:linear-gradient(135deg, var(--accent), var(--accent-2)); color:#fff; }
        .btn-danger { background:linear-gradient(135deg, #ef4444, #f97316); color:#fff; }
        .btn-secondary { background:rgba(255,255,255,.06); color:#fff; border:1px solid var(--line); }
        .table-card {
            border-radius:22px; border:1px solid var(--line); background:var(--panel); overflow:hidden;
            box-shadow:0 24px 60px rgba(0,0,0,.22);
        }
        .table-head {
            display:flex; justify-content:space-between; align-items:end; gap:16px; padding:20px 22px; border-bottom:1px solid var(--line);
        }
        .table-head h2 { margin:0; font-size:24px; }
        .table-head p { margin:6px 0 0; color:var(--muted); }
        .table-wrap { overflow:auto; }
        table { width:100%; border-collapse:collapse; min-width: 920px; }
        th, td { padding:16px 18px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); vertical-align:middle; }
        th { color:#b8c8da; font-size:12px; font-weight:900; letter-spacing:.12em; text-transform:uppercase; background:rgba(255,255,255,.03); }
        td { color:#e8f0fa; }
        tr:hover td { background:rgba(255,255,255,.03); }
        .product-cell { display:flex; align-items:center; gap:14px; }
        .thumb { width:64px; height:64px; border-radius:14px; object-fit:cover; background:#0b1423; border:1px solid var(--line); }
        .name { font-weight:900; }
        .meta { margin-top:4px; color:var(--muted); font-size:12px; }
        .badge { display:inline-flex; align-items:center; min-height:30px; padding:0 10px; border-radius:999px; background:rgba(14,165,233,.12); color:#8bdcff; font-size:12px; font-weight:900; }
        .price { font-weight:900; color:#fff; }
        .actions { display:flex; gap:8px; flex-wrap:wrap; }
        .empty {
            padding:32px 22px; color:var(--muted); text-align:center;
        }
        .footer {
            display:flex; justify-content:space-between; align-items:center; gap:16px; padding:18px 22px; border-top:1px solid var(--line);
            color:var(--muted); font-size:13px;
        }
        @media (max-width:760px) {
            .top, .table-head, .footer { flex-direction:column; align-items:flex-start; }
            .wrap { width: min(100% - 16px, 1360px); }
        }
    </style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div>
            <div class="badge">Admin product management</div>
            <h1>ShopSphere catalog</h1>
            <p>Manage item listings, pricing, and stock from one place.</p>
        </div>
        <div class="actions">
            <a class="btn btn-secondary" href="adminDashboard">Dashboard</a>
            <a class="btn btn-primary" href="<%= request.getContextPath() %>/addProduct">Add product</a>
        </div>
    </div>

    <section class="table-card">
        <div class="table-head">
            <div>
                <h2>Products</h2>
                <p>Current inventory across the storefront.</p>
            </div>
            <div class="badge"><%= products != null ? products.size() : 0 %> items</div>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Image</th>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Edit</th>
                    <th>Delete</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (products != null && !products.isEmpty()) {
                        for (Product p : products) {
                %>
                <tr>
                    <td><%= p.getProductId() %></td>
                    <td><img class="thumb" src="<%= request.getContextPath() + "/" + p.getImageUrl() %>" alt="<%= p.getProductName() %>"></td>
                    <td>
                        <div class="name"><%= p.getProductName() %></div>
                        <div class="meta"><%= p.getDescription() %></div>
                    </td>
                    <td class="price">&#8377;<%= p.getPrice() %></td>
                    <td><span class="badge"><%= p.getStock() %> units</span></td>
                    <td><a class="btn btn-secondary" href="adminEditProduct?id=<%= p.getProductId() %>">Edit</a></td>
                    <td>
                        <a class="btn btn-danger"
                           href="adminDeleteProduct?id=<%= p.getProductId() %>"
                           onclick="return confirm('Delete this product?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="empty">No products available yet.</td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>

        <div class="footer">
            <span>Use the edit and delete actions to keep the catalog current.</span>
            <a class="btn btn-secondary" href="adminDashboard">Back to dashboard</a>
        </div>
    </section>
</div>
</body>
</html>
