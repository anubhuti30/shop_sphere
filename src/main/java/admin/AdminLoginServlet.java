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


@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            String sql = "SELECT * FROM admin WHERE username=? AND password=?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, username);
                ps.setString(2, password);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        HttpSession session = request.getSession();
                        session.setAttribute("admin", username);
                        response.sendRedirect(request.getContextPath() + "/adminDashboard");
                    } else {
                        request.setAttribute("error", "Invalid Username or Password");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                    }
                }
            }

        } catch (SQLException e) {
            request.setAttribute("error", "Unable to connect to the database.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (Exception e) {

            e.printStackTrace();
            request.setAttribute("error", "Unexpected login failure.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        }

    }

}
