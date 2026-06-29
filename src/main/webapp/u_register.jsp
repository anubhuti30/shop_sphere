<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,java.util.Objects,util.DBConnection" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/u_register.html");
        return;
    }

    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm_password");

    boolean validInput = name != null && !name.isBlank()
            && email != null && !email.isBlank()
            && phone != null && !phone.isBlank()
            && password != null && !password.isBlank();

    if (!validInput) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Failed | ShopSphere</title>
    <style>
        body { margin:0; min-height:100vh; display:grid; place-items:center; font-family:"Segoe UI", Arial, sans-serif; color:#e7eff9; background:linear-gradient(180deg, #08111f 0%, #0b1424 100%); }
        .card { width:min(520px, calc(100% - 32px)); padding:34px; border-radius:24px; background:rgba(10,19,35,.9); border:1px solid rgba(255,255,255,.08); text-align:center; }
        .mark { width:72px; height:72px; margin:0 auto 18px; border-radius:22px; display:grid; place-items:center; background:rgba(249,115,22,.14); color:#ffb28a; font-size:28px; font-weight:900; }
        h1 { margin:0; font-size:34px; }
        p { margin:14px 0 0; color:#8fa4bc; line-height:1.7; }
        a { display:inline-flex; align-items:center; justify-content:center; min-height:48px; margin-top:22px; padding:0 18px; border-radius:14px; background:linear-gradient(135deg, #0ea5e9, #22c55e); color:#fff; text-decoration:none; font-weight:900; }
    </style>
</head>
<body>
<main class="card">
    <div class="mark">!</div>
    <h1>Registration failed</h1>
    <p>Please fill in all required fields.</p>
    <a href="u_register.html">Go back</a>
</main>
</body>
</html>
<%
        return;
    }

    if (!Objects.equals(password, confirmPassword)) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passwords Do Not Match | ShopSphere</title>
    <style>
        body { margin:0; min-height:100vh; display:grid; place-items:center; font-family:"Segoe UI", Arial, sans-serif; color:#e7eff9; background:linear-gradient(180deg, #08111f 0%, #0b1424 100%); }
        .card { width:min(520px, calc(100% - 32px)); padding:34px; border-radius:24px; background:rgba(10,19,35,.9); border:1px solid rgba(255,255,255,.08); text-align:center; }
        .mark { width:72px; height:72px; margin:0 auto 18px; border-radius:22px; display:grid; place-items:center; background:rgba(249,115,22,.14); color:#ffb28a; font-size:28px; font-weight:900; }
        h1 { margin:0; font-size:34px; }
        p { margin:14px 0 0; color:#8fa4bc; line-height:1.7; }
        a { display:inline-flex; align-items:center; justify-content:center; min-height:48px; margin-top:22px; padding:0 18px; border-radius:14px; background:linear-gradient(135deg, #0ea5e9, #22c55e); color:#fff; text-decoration:none; font-weight:900; }
    </style>
</head>
<body>
<main class="card">
    <div class="mark">!</div>
    <h1>Passwords do not match</h1>
    <p>Please enter the same password in both fields.</p>
    <a href="u_register.html">Go back</a>
</main>
</body>
</html>
<%
        return;
    }

    String errorMessage = null;
    boolean registered = false;

    try {
        Connection con = DBConnection.getConnection();
        if (con == null) {
            throw new SQLException("Database connection is null");
        }

        try (Connection connection = con) {
            connection.setAutoCommit(false);
            try {
                int nextUserId = 1;

                try (PreparedStatement nextIdStmt = connection.prepareStatement(
                        "SELECT user_id FROM users ORDER BY user_id DESC LIMIT 1 FOR UPDATE");
                     ResultSet rs = nextIdStmt.executeQuery()) {
                    if (rs.next()) {
                        nextUserId = rs.getInt(1) + 1;
                    }
                }

                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO users(user_id, name, email, phone, password) VALUES (?, ?, ?, ?, ?)")) {

                    ps.setInt(1, nextUserId);
                    ps.setString(2, name);
                    ps.setString(3, email);
                    ps.setString(4, phone);
                    ps.setString(5, password);

                    registered = ps.executeUpdate() > 0;
                }

                connection.commit();
            } catch (Exception e) {
                try {
                    connection.rollback();
                } catch (SQLException ignore) {
                    // Ignore rollback errors and surface the original failure.
                }
                throw e;
            } finally {
                try {
                    connection.setAutoCommit(true);
                } catch (SQLException ignore) {
                    // Ignore cleanup errors.
                }
            }
        }
    } catch (Exception e) {
        errorMessage = e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration | ShopSphere</title>
    <style>
        body { margin:0; min-height:100vh; display:grid; place-items:center; font-family:"Segoe UI", Arial, sans-serif; color:#e7eff9; background:linear-gradient(180deg, #08111f 0%, #0b1424 100%); }
        .card { width:min(560px, calc(100% - 32px)); padding:34px; border-radius:24px; background:rgba(10,19,35,.9); border:1px solid rgba(255,255,255,.08); text-align:center; }
        .mark { width:72px; height:72px; margin:0 auto 18px; border-radius:22px; display:grid; place-items:center; background:rgba(34,197,94,.14); color:#8cffb8; font-size:26px; font-weight:900; }
        h1 { margin:0; font-size:34px; }
        p { margin:14px 0 0; color:#8fa4bc; line-height:1.7; }
        .details { margin-top:18px; text-align:left; padding:16px; border-radius:16px; background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08); }
        .details p { margin:8px 0; }
        a { display:inline-flex; align-items:center; justify-content:center; min-height:48px; margin-top:22px; padding:0 18px; border-radius:14px; background:linear-gradient(135deg, #0ea5e9, #22c55e); color:#fff; text-decoration:none; font-weight:900; }
    </style>
</head>
<body>
<main class="card">
<% if (registered) { %>
    <div class="mark">OK</div>
    <h1>Registration successful</h1>
    <div class="details">
        <p><strong>Name:</strong> <%= name %></p>
        <p><strong>Email:</strong> <%= email %></p>
        <p><strong>Phone:</strong> <%= phone %></p>
    </div>
    <a href="u_login.html">Login now</a>
<% } else { %>
    <div class="mark">!</div>
    <h1>Registration failed</h1>
    <p><%= errorMessage != null ? errorMessage : "Unable to create account." %></p>
    <a href="u_register.html">Try again</a>
<% } %>
</main>
</body>
</html>
