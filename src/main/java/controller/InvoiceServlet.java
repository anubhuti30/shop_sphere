package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import model.Product;
import util.DBConnection;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/InvoiceServlet")
public class InvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/u_login.html");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        List<Product> cartProducts = new ArrayList<>();
        double grandTotal = 0;

        try {

            String sql =
                    "SELECT p.product_id, p.product_name, p.description, " +
                            "p.price, p.stock, p.image_url, c.quantity " +
                            "FROM cart c " +
                            "INNER JOIN products p ON c.product_id = p.product_id " +
                            "WHERE c.user_id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Product product = new Product();
                        product.setProductId(rs.getInt("product_id"));
                        product.setProductName(rs.getString("product_name"));
                        product.setDescription(rs.getString("description"));
                        product.setPrice(rs.getDouble("price"));
                        product.setStock(rs.getInt("stock"));
                        product.setImageUrl(rs.getString("image_url"));
                        product.setQuantity(rs.getInt("quantity"));

                        grandTotal += product.getPrice() * product.getQuantity();
                        cartProducts.add(product);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("cartProducts", cartProducts);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("invoiceDate",
                new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new Date()));

        session.setAttribute("checkoutCartProducts", cartProducts);
        session.setAttribute("checkoutGrandTotal", grandTotal);
        session.setAttribute("checkoutInvoiceDate", new Date());

        request.getRequestDispatcher("/invoice.jsp")
                .forward(request, response);
    }
}
