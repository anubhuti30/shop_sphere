<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,util.DBConnection" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/u_login.html");
        return;
    }

    String name = request.getParameter("login");
    String password = request.getParameter("password");
    String errorMessage = null;

    if (name == null || name.trim().isEmpty() || password == null || password.trim().isEmpty()) {
        errorMessage = "Please enter both name and password.";
    } else {
        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                throw new SQLException("Database connection is null");
            }

            try (Connection connection = con;
                 PreparedStatement ps = connection.prepareStatement(
                         "SELECT user_id, name FROM users WHERE name=? AND password=?")) {

                ps.setString(1, name.trim());
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        session.setAttribute("username", rs.getString("name"));
                        session.setAttribute("userId", rs.getInt("user_id"));
                        session.setAttribute("loginTime", new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new java.util.Date()));
                        session.setAttribute("recentlyViewedProducts", new java.util.ArrayList<Integer>());
                        response.sendRedirect(request.getContextPath() + "/products.jsp");
                        return;
                    }
                }
            }

            errorMessage = "Invalid username or password.";
        } catch (Exception e) {
            errorMessage = e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | ShopSphere</title>
    <style>
        :root {
            --bg: #08111f;
            --panel: rgba(10, 19, 35, 0.9);
            --line: rgba(255, 255, 255, 0.08);
            --text: #e7eff9;
            --muted: #8fa4bc;
            --accent: #0ea5e9;
            --accent-2: #22c55e;
        }
        * { box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            font-family: "Segoe UI", Arial, sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at top left, rgba(14, 165, 233, 0.18), transparent 26%),
                radial-gradient(circle at top right, rgba(34, 197, 94, 0.14), transparent 25%),
                linear-gradient(180deg, #08111f 0%, #0b1424 100%);
            opacity: 0;
            transition: opacity 180ms ease;
        }
        body.is-ready { opacity: 1; }
        a { color: inherit; text-decoration: none; }
        .shell {
            width: min(1120px, calc(100% - 32px));
            display: grid;
            grid-template-columns: 0.95fr 1.05fr;
            gap: 18px;
        }
        .panel {
            border-radius: 24px;
            border: 1px solid var(--line);
            background: var(--panel);
            box-shadow: 0 24px 60px rgba(0, 0, 0, 0.24);
            overflow: hidden;
        }
        .hero {
            padding: 38px;
            min-height: 560px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            background:
                linear-gradient(180deg, rgba(8, 17, 31, 0.14), rgba(8, 17, 31, 0.92)),
                url("images/products/24-jbl-speaker.webp") center/cover;
        }
        .brand {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 28px;
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
        h2 { margin: 14px 0 8px; font-size: 34px; color:#fff; }
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
            .shell { grid-template-columns: 1fr; }
            .hero { min-height: 360px; }
        }
    </style>
</head>
<body>
<div class="shell">
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
    <div class="eyebrow">Customer login</div>
    <h2>Sign in</h2>
    <p class="sub">Use your account name and password to continue shopping.</p>

    <%
      if (errorMessage != null) {
    %>
    <div class="alert"><span>!</span><span><%= errorMessage %></span></div>
    <%
      }
    %>

    <form action="u_login.jsp" method="post" id="loginForm">
      <div class="field">
        <label for="login">Name</label>
        <input id="login" type="text" name="login" placeholder="Enter your name" required>
      </div>

      <div class="field">
        <label for="password">Password</label>
        <input id="password" type="password" name="password" placeholder="Enter your password" required>
      </div>

      <button type="button" class="toggle" id="togglePassword">Show password</button>
      <button type="submit" class="btn">Login</button>
    </form>

    <div class="footer">
      <strong>ShopSphere</strong> customer login.
    </div>
  </section>
</div>

<script>
(function () {
  document.body.classList.add("is-ready");

  const input = document.getElementById("password");
  const toggle = document.getElementById("togglePassword");
  const form = document.getElementById("loginForm");
  toggle.addEventListener("click", function () {
    const hidden = input.type === "password";
    input.type = hidden ? "text" : "password";
    toggle.textContent = hidden ? "Hide password" : "Show password";
  });

  form.addEventListener("submit", function () {
    document.body.classList.remove("is-ready");
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

  const form = document.getElementById("loginForm");
  form.addEventListener("submit", function () {
    document.body.classList.remove("is-ready");
  });
})();
</script>
</body>
</html>
