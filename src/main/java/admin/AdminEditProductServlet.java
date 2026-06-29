package admin;

import model.Product;
import util.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/adminEditProduct")
public class AdminEditProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(request.getParameter("id"));

            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM products WHERE product_id=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            Product product = null;

            if(rs.next()){

                product = new Product();

                product.setProductId(rs.getInt("product_id"));
                product.setProductName(rs.getString("product_name"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setStock(rs.getInt("stock"));
                product.setImageUrl(rs.getString("image_url"));

            }

            rs.close();
            ps.close();
            con.close();

            request.setAttribute("product", product);

            request.getRequestDispatcher("/adminEditProduct.jsp")
                    .forward(request,response);

        }

        catch(Exception e){

            e.printStackTrace();

        }

    }

}