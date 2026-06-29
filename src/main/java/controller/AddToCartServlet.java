package controller;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import util.DBConnection;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/u_login.html");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");
            String productIdParam = request.getParameter("id");
            if (productIdParam == null || productIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/CartServlet");
                return;
            }

            int productId = Integer.parseInt(productIdParam);

            try (Connection con = DBConnection.getConnection()) {
                if (con == null) {
                    throw new SQLException("Database connection is null");
                }

                // Check if product already exists in cart
                String checkSql =
                        "SELECT quantity FROM cart WHERE user_id=? AND product_id=?";

                try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {

                    checkPs.setInt(1, userId);
                    checkPs.setInt(2, productId);

                    try (ResultSet rs = checkPs.executeQuery()) {

                        if (rs.next()) {

                            // Update quantity
                            String updateSql =
                                    "UPDATE cart SET quantity = quantity + 1 WHERE user_id=? AND product_id=?";

                            try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {

                                updatePs.setInt(1, userId);
                                updatePs.setInt(2, productId);

                                updatePs.executeUpdate();

                            }

                        } else {

                            // cart_id is required in the current schema, so generate the next value explicitly.
                            int nextCartId;
                            String nextIdSql = "SELECT COALESCE(MAX(cart_id), 0) + 1 AS next_id FROM cart";

                            try (PreparedStatement nextIdPs = con.prepareStatement(nextIdSql);
                                 ResultSet nextIdRs = nextIdPs.executeQuery()) {
                                nextCartId = nextIdRs.next() ? nextIdRs.getInt("next_id") : 1;
                            }

                            String insertSql =
                                    "INSERT INTO cart(cart_id, user_id, product_id, quantity) VALUES (?, ?, ?, 1)";

                            try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                                insertPs.setInt(1, nextCartId);
                                insertPs.setInt(2, userId);
                                insertPs.setInt(3, productId);
                                insertPs.executeUpdate();
                            }
                        }
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/CartServlet");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
