package controller;

import model.Product;
import util.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> cartProducts = new ArrayList<>();
        double grandTotal = 0;

        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect(request.getContextPath() + "/u_login.html");
                return;
            }

            int userId = (Integer) session.getAttribute("userId");
            String sql = "SELECT p.*, c.quantity FROM products p " +
                    "JOIN cart c ON p.product_id = c.product_id " +
                    "WHERE c.user_id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql))  {

                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Product p = new Product();
                        p.setProductId(rs.getInt("product_id"));
                        p.setProductName(rs.getString("product_name"));
                        p.setDescription(rs.getString("description"));
                        p.setPrice(rs.getDouble("price"));
                        p.setStock(rs.getInt("stock"));
                        p.setImageUrl(rs.getString("image_url"));

                        int qty = rs.getInt("quantity");
                        p.setQuantity(qty);

                        grandTotal += p.getPrice() * qty;

                        cartProducts.add(p);
                    }
                }
            }

            request.setAttribute("cartProducts", cartProducts);
            request.setAttribute("grandTotal", grandTotal);

            request.getRequestDispatcher("/cart.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            try {
                e.printStackTrace(response.getWriter());
            } catch (IOException ioEx) {
                ioEx.printStackTrace();
            }
        }
    }
}
