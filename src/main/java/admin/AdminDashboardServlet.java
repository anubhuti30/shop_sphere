package admin;

import util.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;


@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String sql = "SELECT COUNT(*) FROM products";
            int productCount = 0;

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    productCount = rs.getInt(1);
                }
            }

            request.setAttribute("products", productCount);
            request.setAttribute("users", 0);
            request.setAttribute("orders", 0);
            request.setAttribute("revenue", 0.0);

            request.getRequestDispatcher("/dashboard.jsp")
                    .forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load admin dashboard.", e);
        } catch (Exception e) {
            throw new ServletException("Unexpected admin dashboard failure.", e);

        }

    }

}
