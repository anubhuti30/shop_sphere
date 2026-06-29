package controller;

import util.DBConnection;
import util.ImageUrlUtil;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SearchProductServlet")
public class SearchProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String DEFAULT_IMAGE_PATH = "images/products/default.webp";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String keyword = request.getParameter("keyword");
        String searchTerm = (keyword == null) ? "" : keyword.trim();
        String contextPath = request.getContextPath();

        response.setContentType("text/html;charset=UTF-8");

        String sql = "SELECT * FROM products WHERE product_name LIKE ? OR description LIKE ?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setString(1, "%" + searchTerm + "%");
            ps.setString(2, "%" + searchTerm + "%");

            try (
                    ResultSet rs = ps.executeQuery();
                    PrintWriter out = response.getWriter()
            ) {
                while (rs.next()) {
                    String imageUrl = ImageUrlUtil.resolve(
                            request,
                            getImagePathOrDefault(rs.getString("image_url"))
                    );

                    String defaultImageUrl = ImageUrlUtil.resolve(request, DEFAULT_IMAGE_PATH);

                    out.println(
                            "<article class='card'>"
                                    + "<img src='" + imageUrl + "' alt='" + rs.getString("product_name") + "' onerror=\"this.onerror=null;this.src='" + defaultImageUrl + "';\">"
                                    + "<h3>" + rs.getString("product_name") + "</h3>"
                                    + "<p class='description'>" + rs.getString("description") + "</p>"
                                    + "<p class='price'>&#8377;" + rs.getDouble("price") + "</p>"
                                    + "<p class='stock'>Stock: " + rs.getInt("stock") + "</p>"
                                    + "<div class='card-actions'>"
                                    + "<a href='" + contextPath + "/ProductDetailsServlet?id=" + rs.getInt("product_id") + "' class='btn btn-secondary view-details-btn'>View details</a>"
                                    + "<a href='" + contextPath + "/AddToCartServlet?id=" + rs.getInt("product_id") + "' class='btn btn-primary'>Add to cart</a>"
                                    + "</div>"
                                    + "</article>"
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("<p style='color:#ffb4b4;'>Error loading products.</p>");
        }
    }

    private String getImagePathOrDefault(String imageUrl) {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return DEFAULT_IMAGE_PATH;
        }
        return imageUrl.trim();
    }
}
