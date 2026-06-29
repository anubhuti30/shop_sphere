package admin;

import model.Product;
import util.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/addProduct")
public class AddProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/adminAddProduct.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {

            String name = request.getParameter("productName");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String image = request.getParameter("imageUrl");

            Connection con = DBConnection.getConnection();

            String sql =
                    "INSERT INTO products(product_name,description,price,stock,image_url) VALUES(?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, description);
            ps.setDouble(3, price);
            ps.setInt(4, stock);
            ps.setString(5, image);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect(request.getContextPath() + "/adminProducts");

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
