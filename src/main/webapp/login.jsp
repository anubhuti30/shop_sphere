<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Login | ShopSphere</title>
  <style>
    :root { --bg:#08111f; --panel:rgba(10,19,35,.9); --line:rgba(255,255,255,.08); --text:#e7eff9; --muted:#8fa4bc; --accent:#0ea5e9; --accent-2:#22c55e; }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      min-height: 100vh;
      display: grid;
      place-items: center;
      font-family: "Segoe UI", Arial, sans-serif;
      color: var(--text);
      background:
        radial-gradient(circle at top left, rgba(14,165,233,.18), transparent 28%),
        radial-gradient(circle at top right, rgba(34,197,94,.12), transparent 24%),
        linear-gradient(180deg, #08111f 0%, #0b1424 100%);
    }
    .wrap {
      width: min(1100px, calc(100% - 32px));
      display: grid;
      grid-template-columns: 0.95fr 1.05fr;
      gap: 18px;
    }
    .panel {
      border-radius: 24px;
      border: 1px solid var(--line);
      background: var(--panel);
      box-shadow: 0 24px 60px rgba(0,0,0,.24);
      overflow: hidden;
    }
    .hero {
      padding: 38px;
      min-height: 560px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      background:
        linear-gradient(180deg, rgba(8,17,31,.14), rgba(8,17,31,.92)),
        url("images/products/24-jbl-speaker.webp") center/cover;
    }
    .brand {
      display: inline-flex;
      align-items: center;
      gap: 10px;
      color: #fff;
      font-size: 28px;
      font-weight: 900;
      text-decoration: none;
    }
    .mark {
      width: 36px;
      height: 36px;
      border-radius: 11px;
      display: grid;
      place-items: center;
      background: linear-gradient(135deg, var(--accent), var(--accent-2));
    }
    .hero h1 {
      margin: 0;
      max-width: 11ch;
      font-size: clamp(38px, 5vw, 62px);
      line-height: .96;
    }
    .hero p {
      margin: 18px 0 0;
      max-width: 40ch;
      color: #c8d7ea;
      line-height: 1.75;
    }
    .chips { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 28px; }
    .chip {
      display: inline-flex;
      align-items: center;
      min-height: 34px;
      padding: 0 12px;
      border-radius: 999px;
      background: rgba(255,255,255,.08);
      border: 1px solid rgba(255,255,255,.08);
      color: #fff;
      font-size: 12px;
      font-weight: 800;
    }
    .form {
      padding: 38px;
    }
    .eyebrow {
      display: inline-flex;
      align-items: center;
      min-height: 34px;
      padding: 0 12px;
      border-radius: 999px;
      background: rgba(14,165,233,.12);
      color: #8bdcff;
      font-size: 12px;
      font-weight: 900;
      letter-spacing: .12em;
      text-transform: uppercase;
    }
    h2 { margin: 14px 0 8px; font-size: 34px; }
    .sub { margin: 0 0 24px; color: var(--muted); line-height: 1.65; }
    .alert {
      display: flex;
      gap: 10px;
      align-items: flex-start;
      margin-bottom: 18px;
      padding: 14px 16px;
      border-radius: 14px;
      background: rgba(249,115,22,.12);
      border: 1px solid rgba(249,115,22,.18);
      color: #ffcfb5;
    }
    form { display: grid; gap: 18px; }
    .field { display: grid; gap: 8px; }
    label { color: #d8e4f2; font-size: 13px; font-weight: 800; }
    input {
      min-height: 50px;
      padding: 0 16px;
      border-radius: 14px;
      border: 1px solid rgba(255,255,255,.1);
      background: rgba(255,255,255,.04);
      color: #fff;
      outline: none;
    }
    input:focus {
      border-color: rgba(14,165,233,.7);
      box-shadow: 0 0 0 4px rgba(14,165,233,.14);
    }
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-height: 50px;
      padding: 0 18px;
      border-radius: 14px;
      border: 0;
      cursor: pointer;
      font-size: 15px;
      font-weight: 900;
      background: linear-gradient(135deg, var(--accent), var(--accent-2));
      color: #fff;
      transition: transform .2s;
    }
    .btn:hover { transform: translateY(-2px); }
    .footer {
      margin-top: 18px;
      padding-top: 18px;
      border-top: 1px solid var(--line);
      color: var(--muted);
      font-size: 13px;
      line-height: 1.7;
    }
    .footer strong { color: #fff; }
    .toggle {
      align-self: end;
      border: 0;
      background: transparent;
      color: #8bdcff;
      cursor: pointer;
      font-weight: 800;
      padding: 0;
    }
    @media (max-width: 980px) {
      .wrap { grid-template-columns: 1fr; }
      .hero { min-height: 360px; }
    }
  </style>
</head>
<body>
<div class="wrap">
  <section class="panel hero">
    <div>
      <a class="brand" href="index.html">
        <span class="mark">S</span>
        <span>ShopSphere</span>
      </a>
      <h1>Admin control for a cleaner storefront.</h1>
      <p>Manage products, inventory, and order-facing content through a focused dashboard designed for everyday operations.</p>
      <div class="chips">
        <span class="chip">Product management</span>
        <span class="chip">Inventory control</span>
        <span class="chip">Order visibility</span>
      </div>
    </div>
  </section>

  <section class="panel form">
    <div class="eyebrow">Admin access</div>
    <h2>Sign in</h2>
    <p class="sub">Enter the administrator credentials to continue.</p>

    <%
      String error = (String) request.getAttribute("error");
      if (error != null) {
    %>
    <div class="alert"><span>!</span><span><%= error %></span></div>
    <%
      }
    %>

    <form action="adminLogin" method="post" id="adminLoginForm">
      <div class="field">
        <label for="username">Username</label>
        <input class="form-control" type="text" id="username" name="username" placeholder="Enter your username" required autocomplete="username">
      </div>

      <div class="field">
        <label for="password">Password</label>
        <input class="form-control" type="password" id="password" name="password" placeholder="Enter your password" required autocomplete="current-password">
      </div>

      <button type="button" class="toggle" id="togglePassword">Show password</button>
      <button type="submit" class="btn">Sign in to dashboard</button>
    </form>

    <div class="footer">
      <strong>ShopSphere</strong> admin console.
    </div>
  </section>
</div>

<script>
(function () {
  const input = document.getElementById("password");
  const toggle = document.getElementById("togglePassword");
  toggle.addEventListener("click", function () {
    const isHidden = input.type === "password";
    input.type = isHidden ? "text" : "password";
    toggle.textContent = isHidden ? "Hide password" : "Show password";
  });
})();
</script>
</body>
</html>
