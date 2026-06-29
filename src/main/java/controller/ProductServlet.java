package controller;

import model.Product;
import util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DEFAULT_IMAGE_PATH =
            "images/products/default.webp";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Product> products = new ArrayList<>();

        String keyword = request.getParameter("keyword");
        String searchTerm = (keyword == null) ? "" : keyword.trim();

        try (Connection con = DBConnection.getConnection()) {

            String sql;

            if (searchTerm.isEmpty()) {
                sql = "SELECT * FROM products";
            } else {
                sql = "SELECT * FROM products WHERE product_name LIKE ? OR description LIKE ?";
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                if (!searchTerm.isEmpty()) {
                    ps.setString(1, "%" + searchTerm + "%");
                    ps.setString(2, "%" + searchTerm + "%");
                }

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        Product product = new Product();

                        product.setProductId(rs.getInt("product_id"));
                        product.setProductName(rs.getString("product_name"));
                        product.setDescription(rs.getString("description"));
                        product.setPrice(rs.getDouble("price"));
                        product.setStock(rs.getInt("stock"));
                        product.setImageUrl(
                                getImagePathOrDefault(rs.getString("image_url"))
                        );

                        products.add(product);
                    }
                }
            }

            request.setAttribute("products", products);
            request.setAttribute("keyword", searchTerm);

            request.getRequestDispatcher("/products.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            response.setContentType("text/plain");

            e.printStackTrace(response.getWriter());

            return;
        }
    }

    private String getImagePathOrDefault(String imageUrl) {

        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return DEFAULT_IMAGE_PATH;
        }

        return imageUrl.trim();
    }
}
