package admin;

import model.Product;
import util.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;


import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/adminProducts")
public class AdminProductListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = new ArrayList<>();

        try {
            String sql = "SELECT * FROM products ORDER BY product_id DESC";
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Product p = new Product();
                    p.setProductId(rs.getInt("product_id"));
                    p.setProductName(rs.getString("product_name"));
                    p.setDescription(rs.getString("description"));
                    p.setPrice(rs.getDouble("price"));
                    p.setStock(rs.getInt("stock"));
                    p.setImageUrl(rs.getString("image_url"));
                    products.add(p);
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load admin products.", e);
        }

        request.setAttribute("products", products);

        request.getRequestDispatcher("/adminProducts.jsp")
                .forward(request, response);
    }
}
