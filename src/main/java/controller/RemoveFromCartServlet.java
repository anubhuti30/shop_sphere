package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import util.DBConnection;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        doDeleteFromCart(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doDeleteFromCart(request, response);
    }

    private void doDeleteFromCart(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/u_login.html");
            return;
        }

        String productIdParam = request.getParameter("id");
        if (productIdParam == null || productIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException ex) {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            if (con == null) {
                throw new SQLException("Database connection is null");
            }

            try (Connection connection = con;
                 PreparedStatement ps = connection.prepareStatement(
                         "DELETE FROM cart WHERE user_id=? AND product_id=?")) {

                ps.setInt(1, userId);
                ps.setInt(2, productId);

                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/CartServlet");
    }
}
