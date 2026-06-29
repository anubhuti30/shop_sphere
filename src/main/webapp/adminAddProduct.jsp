<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Product | ShopSphere</title>
<style>
    :root { --bg:#08111f; --panel:rgba(10,19,35,.9); --line:rgba(255,255,255,.08); --text:#e7eff9; --muted:#8fa4bc; --accent:#0ea5e9; --accent-2:#22c55e; }
    * { box-sizing:border-box; }
    body { margin:0; min-height:100vh; font-family:"Segoe UI", Arial, sans-serif; color:var(--text); background:linear-gradient(180deg, #08111f 0%, #0b1424 100%); }
    a { color:inherit; text-decoration:none; }
    .wrap { width:min(920px, calc(100% - 32px)); margin:0 auto; padding:24px 0 36px; }
    .panel { padding:24px; border-radius:22px; border:1px solid var(--line); background:var(--panel); box-shadow:0 24px 60px rgba(0,0,0,.22); }
    .top { display:flex; justify-content:space-between; align-items:end; gap:16px; margin-bottom:18px; }
    .top h1 { margin:0; font-size:32px; }
    .top p { margin:6px 0 0; color:var(--muted); }
    .badge { display:inline-flex; align-items:center; min-height:30px; padding:0 10px; border-radius:999px; background:rgba(14,165,233,.12); color:#8bdcff; font-size:12px; font-weight:900; }
    form { display:grid; gap:16px; }
    .grid { display:grid; grid-template-columns:repeat(2, minmax(0, 1fr)); gap:16px; }
    .field { display:grid; gap:8px; }
    .full { grid-column:1 / -1; }
    label { font-size:13px; font-weight:800; color:#d8e4f2; }
    input, textarea {
        width:100%; min-height:50px; padding:14px 16px; border-radius:14px; border:1px solid rgba(255,255,255,.1);
        background:rgba(255,255,255,.04); color:#fff; outline:none; resize:vertical;
    }
    textarea { min-height:120px; }
    input:focus, textarea:focus { border-color:rgba(14,165,233,.7); box-shadow:0 0 0 4px rgba(14,165,233,.14); }
    .actions { display:flex; gap:12px; flex-wrap:wrap; margin-top:6px; }
    .btn {
        display:inline-flex; align-items:center; justify-content:center; min-height:48px; padding:0 16px; border-radius:14px; border:0;
        cursor:pointer; font-weight:900; transition:transform .2s;
    }
    .btn:hover { transform:translateY(-2px); }
    .btn-primary { background:linear-gradient(135deg, var(--accent), var(--accent-2)); color:#fff; }
    .btn-secondary { background:rgba(255,255,255,.06); color:#fff; border:1px solid var(--line); }
    @media (max-width:760px) { .grid { grid-template-columns:1fr; } .full { grid-column:auto; } .top { flex-direction:column; align-items:flex-start; } }
</style>
</head>
<body>
<div class="wrap">
    <div class="top">
        <div>
            <div class="badge">Catalog builder</div>
            <h1>Add a product</h1>
            <p>Create a new storefront listing for ShopSphere.</p>
        </div>
        <div class="actions">
            <a class="btn btn-secondary" href="adminProducts">Products</a>
            <a class="btn btn-secondary" href="adminDashboard">Dashboard</a>
        </div>
    </div>

    <div class="panel">
        <form action="addProduct" method="post" id="addProductForm">
            <div class="grid">
                <div class="field full">
                    <label>Product Name</label>
                    <input type="text" name="productName" required>
                </div>
                <div class="field full">
                    <label>Description</label>
                    <textarea name="description" rows="5" placeholder="Describe the product clearly."></textarea>
                </div>
                <div class="field">
                    <label>Price</label>
                    <input type="number" step="0.01" name="price" required>
                </div>
                <div class="field">
                    <label>Stock</label>
                    <input type="number" name="stock" required>
                </div>
                <div class="field full">
                    <label>Image URL</label>
                    <input type="text" name="imageUrl" required>
                </div>
            </div>
            <div class="actions">
                <button type="submit" class="btn btn-primary">Save product</button>
                <a class="btn btn-secondary" href="adminProducts">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
document.getElementById("addProductForm").addEventListener("submit", function () {
    const btn = this.querySelector("button[type='submit']");
    btn.textContent = "Saving...";
});
</script>
</body>
</html>
