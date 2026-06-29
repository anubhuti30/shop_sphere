package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import util.DBConnection;


@WebServlet("/UpdateCartServlet")
public class UpdateCartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("===== UPDATE CART CALLED =====");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Session expired");
            response.sendRedirect(request.getContextPath() + "/u_login.html");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");
            int productId = Integer.parseInt(request.getParameter("id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            System.out.println("User ID = " + userId);
            System.out.println("Product ID = " + productId);
            System.out.println("Quantity = " + quantity);

            String sql = "UPDATE cart SET quantity=? WHERE user_id=? AND product_id=?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, quantity);
                ps.setInt(2, userId);
                ps.setInt(3, productId);

                int rows = ps.executeUpdate();

                System.out.println("Rows Updated = " + rows);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/CartServlet");
    }
}
