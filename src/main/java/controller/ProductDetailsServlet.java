package controller;

import model.Product;
import util.ImageUrlUtil;
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
import jakarta.servlet.http.HttpSession;

@WebServlet("/ProductDetailsServlet")
public class ProductDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DEFAULT_IMAGE_PATH = "images/products/default.webp";

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Product ID is missing.");

            if (isAjaxRequest(request)) {
                writeAjaxResponse(request, response, null, "Product ID is missing.");
                return;
            }

            request.getRequestDispatcher("/product-details.jsp").forward(request, response);
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);

            Product product = null;

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM products WHERE product_id=?")) {

                ps.setInt(1, productId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        product = new Product();
                        product.setProductId(rs.getInt("product_id"));
                        product.setProductName(rs.getString("product_name"));
                        product.setDescription(rs.getString("description"));
                        product.setPrice(rs.getDouble("price"));
                        product.setStock(rs.getInt("stock"));
                        product.setImageUrl(getImagePathOrDefault(rs.getString("image_url")));
                    }
                }
            }

            if (product == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                request.setAttribute("errorMessage", "Product not found.");
            } else {
                final int viewedProductId = product.getProductId();
                HttpSession session = request.getSession();
                List<Product> recentlyViewed =
                        (List<Product>) session.getAttribute("recentlyViewedProducts");

                if (recentlyViewed == null) {
                    recentlyViewed = new ArrayList<>();
                }

                recentlyViewed.removeIf(item -> item.getProductId() == viewedProductId);
                recentlyViewed.add(0, product);

                if (recentlyViewed.size() > 4) {
                    recentlyViewed = new ArrayList<>(recentlyViewed.subList(0, 4));
                }

                session.setAttribute("recentlyViewedProducts", recentlyViewed);
            }

            request.setAttribute("product", product);

            if (isAjaxRequest(request)) {
                writeAjaxResponse(request, response, product, (String) request.getAttribute("errorMessage"));
                return;
            }

            request.getRequestDispatcher("/product-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid Product ID.");

            if (isAjaxRequest(request)) {
                writeAjaxResponse(request, response, null, "Invalid Product ID.");
                return;
            }

            request.getRequestDispatcher("/product-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load product details.");

            if (isAjaxRequest(request)) {
                writeAjaxResponse(request, response, null, "Unable to load product details.");
                return;
            }

            request.getRequestDispatcher("/product-details.jsp").forward(request, response);
        }
    }

    private String getImagePathOrDefault(String imageUrl) {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return DEFAULT_IMAGE_PATH;
        }
        return imageUrl.trim();
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        return "true".equals(request.getParameter("ajax"))
                || "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }

    private void writeAjaxResponse(HttpServletRequest request,
                                   HttpServletResponse response,
                                   Product product,
                                   String errorMessage)
            throws IOException {

        response.setContentType("text/html;charset=UTF-8");

        if (errorMessage != null) {
            response.getWriter().println("<p class='error'>" + errorMessage + "</p>");
            return;
        }

        if (product == null) {
            response.getWriter().println("<p class='error'>Product not found.</p>");
            return;
        }

        String defaultImage = ImageUrlUtil.resolve(request, DEFAULT_IMAGE_PATH);
        String image = ImageUrlUtil.resolve(request, product.getImageUrl());

        response.getWriter().println(
                "<img src='" + image + "' alt='" + product.getProductName() + "' onerror=\"this.onerror=null;this.src='" + defaultImage + "';\">"
                        + "<h1>" + product.getProductName() + "</h1>"
                        + "<p>" + product.getDescription() + "</p>"
                        + "<p class='price'>&#8377;" + product.getPrice() + "</p>"
                        + "<p><strong>Stock:</strong> " + product.getStock() + "</p>"
                        + "<br>"
                        + "<a class='btn btn-primary' href='"
                        + request.getContextPath()
                        + "/AddToCartServlet?id="
                        + product.getProductId()
                        + "'>Add To Cart</a>"
        );
    }
}
