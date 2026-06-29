<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard | ShopSphere Admin</title>
  <style>
    :root { --bg:#08111f; --panel:rgba(10,19,35,.9); --line:rgba(255,255,255,.08); --text:#e7eff9; --muted:#8fa4bc; --accent:#0ea5e9; --accent-2:#22c55e; --accent-3:#f97316; --accent-4:#facc15; }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      font-family: "Segoe UI", Arial, sans-serif;
      color: var(--text);
      background:
        radial-gradient(circle at top left, rgba(14,165,233,.16), transparent 28%),
        radial-gradient(circle at top right, rgba(34,197,94,.12), transparent 25%),
        linear-gradient(180deg, #08111f 0%, #0b1424 100%);
    }
    a { color: inherit; text-decoration: none; }
    .layout {
      display: grid;
      grid-template-columns: 280px 1fr;
      min-height: 100vh;
    }
    .sidebar {
      position: sticky;
      top: 0;
      height: 100vh;
      padding: 24px;
      border-right: 1px solid var(--line);
      background: rgba(7,17,31,.72);
      backdrop-filter: blur(18px);
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 26px;
      font-weight: 900;
      color: #fff;
    }
    .mark {
      width: 36px;
      height: 36px;
      border-radius: 11px;
      display: grid;
      place-items: center;
      background: linear-gradient(135deg, var(--accent), var(--accent-2));
    }
    .menu { list-style: none; padding: 18px 0 0; margin: 0; display: grid; gap: 8px; }
    .menu a {
      display: flex;
      align-items: center;
      min-height: 46px;
      padding: 0 14px;
      border-radius: 14px;
      color: #c9d6e6;
      font-weight: 800;
      background: transparent;
      border: 1px solid transparent;
    }
    .menu a.active,
    .menu a:hover {
      background: rgba(255,255,255,.06);
      color: #fff;
      border-color: rgba(255,255,255,.08);
    }
    .sidebar-note {
      margin-top: 18px;
      padding-top: 18px;
      border-top: 1px solid var(--line);
      color: var(--muted);
      line-height: 1.7;
      font-size: 13px;
    }
    .content {
      padding: 24px;
    }
    .topbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 18px;
      padding: 18px 22px;
      border-radius: 22px;
      border: 1px solid var(--line);
      background: var(--panel);
      box-shadow: 0 24px 60px rgba(0,0,0,.22);
    }
    .topbar h1 { margin: 0; font-size: 30px; }
    .topbar p { margin: 6px 0 0; color: var(--muted); }
    .actions { display: flex; gap: 10px; flex-wrap: wrap; }
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-height: 46px;
      padding: 0 16px;
      border-radius: 14px;
      border: 0;
      cursor: pointer;
      font-weight: 900;
      transition: transform .2s;
    }
    .btn:hover { transform: translateY(-2px); }
    .btn-primary { background: linear-gradient(135deg, var(--accent), var(--accent-2)); color: #fff; }
    .btn-secondary { background: rgba(255,255,255,.06); color: #fff; border: 1px solid var(--line); }
    .stats {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 18px;
      margin-top: 18px;
    }
    .card {
      padding: 20px;
      border-radius: 22px;
      border: 1px solid var(--line);
      background: var(--panel);
      box-shadow: 0 18px 42px rgba(0,0,0,.18);
    }
    .card .label {
      color: var(--muted);
      font-size: 12px;
      font-weight: 900;
      letter-spacing: .12em;
      text-transform: uppercase;
    }
    .card .value {
      margin-top: 10px;
      color: #fff;
      font-size: 34px;
      font-weight: 900;
      line-height: 1;
    }
    .card .note { margin-top: 10px; color: #bfd0e4; line-height: 1.6; font-size: 13px; }
    .grid {
      display: grid;
      grid-template-columns: 1.2fr .8fr;
      gap: 18px;
      margin-top: 18px;
    }
    .section-head {
      display: flex;
      justify-content: space-between;
      align-items: end;
      gap: 16px;
      margin-bottom: 16px;
    }
    .section-head h2 { margin: 0; font-size: 24px; color: #fff; }
    .section-head p { margin: 6px 0 0; color: var(--muted); }
    .list {
      display: grid;
      gap: 12px;
      margin: 0;
      padding: 0;
      list-style: none;
    }
    .list li {
      display: flex;
      justify-content: space-between;
      gap: 12px;
      padding: 14px 16px;
      border-radius: 14px;
      background: rgba(255,255,255,.04);
      border: 1px solid rgba(255,255,255,.06);
      color: #dbe7f5;
    }
    .pill {
      display: inline-flex;
      align-items: center;
      min-height: 28px;
      padding: 0 10px;
      border-radius: 999px;
      background: rgba(14,165,233,.12);
      color: #8bdcff;
      font-size: 12px;
      font-weight: 900;
    }
    .activity {
      display: grid;
      gap: 12px;
    }
    .activity .row {
      padding: 14px 16px;
      border-radius: 14px;
      background: rgba(255,255,255,.04);
      border: 1px solid rgba(255,255,255,.06);
      color: #dbe7f5;
      line-height: 1.6;
    }
    .mobile-toggle { display: none; }
    @media (max-width: 1020px) {
      .layout { grid-template-columns: 1fr; }
      .sidebar { position: static; height: auto; }
      .stats, .grid { grid-template-columns: 1fr 1fr; }
    }
    @media (max-width: 760px) {
      .content { padding: 16px; }
      .stats, .grid { grid-template-columns: 1fr; }
      .topbar { flex-direction: column; align-items: flex-start; }
    }
  </style>
</head>
<body>
<div class="layout">
  <aside class="sidebar">
    <a class="brand" href="<%=request.getContextPath()%>/index.html">
      <span class="mark">S</span>
      <span>ShopSphere</span>
    </a>
    <ul class="menu">
      <li><a class="active" href="${pageContext.request.contextPath}/adminDashboard">Dashboard</a></li>
      <li><a href="${pageContext.request.contextPath}/adminProducts">Products</a></li>
      <li><a href="${pageContext.request.contextPath}/addProduct">Add Product</a></li>
      <li><a href="<%=request.getContextPath()%>/index.html">Storefront</a></li>
    </ul>
    <div class="sidebar-note">
      Manage products and inventory from one focused control panel.
    </div>
  </aside>

  <main class="content">
    <header class="topbar">
      <div>
        <div class="pill">Admin dashboard</div>
        <h1>Welcome back, ${sessionScope.admin}</h1>
        <p>Here is the current state of your store.</p>
      </div>
      <div class="actions">
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/adminProducts">View products</a>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/addProduct">Add product</a>
      </div>
    </header>

    <section class="stats">
      <div class="card">
        <div class="label">Products</div>
        <div class="value">${products}</div>
        <div class="note">Current catalog items in the store.</div>
      </div>
      <div class="card">
        <div class="label">Users</div>
        <div class="value">${users}</div>
        <div class="note">Registered customer accounts.</div>
      </div>
      <div class="card">
        <div class="label">Orders</div>
        <div class="value">${orders}</div>
        <div class="note">Total order records currently tracked.</div>
      </div>
      <div class="card">
        <div class="label">Revenue</div>
        <div class="value">${revenue}</div>
        <div class="note">Gross revenue snapshot from the system.</div>
      </div>
    </section>

    <section class="grid">
      <div class="card">
        <div class="section-head">
          <div>
            <h2>Quick actions</h2>
            <p>Tasks used most often by the admin flow.</p>
          </div>
        </div>
        <ul class="list">
          <li><span>Review catalog updates</span><span class="pill">Products</span></li>
          <li><span>Add a new product listing</span><span class="pill">Add</span></li>
          <li><span>Edit pricing or inventory</span><span class="pill">Update</span></li>
          <li><span>Return to storefront</span><span class="pill">Store</span></li>
        </ul>
      </div>

      <div class="card">
        <div class="section-head">
          <div>
            <h2>Store notes</h2>
            <p>Operational summary for this admin session.</p>
          </div>
        </div>
        <div class="activity">
          <div class="row">Inventory and product management are linked to the existing servlet routes.</div>
          <div class="row">The storefront and admin views now share the same visual language.</div>
          <div class="row">Use the product pages to keep catalog content current.</div>
        </div>
      </div>
    </section>
  </main>
</div>
</body>
</html>
