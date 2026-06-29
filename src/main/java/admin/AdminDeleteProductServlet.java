package admin;

import util.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;


import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/adminDeleteProduct")
public class AdminDeleteProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try{

            int id=Integer.parseInt(request.getParameter("id"));

            Connection con=DBConnection.getConnection();

            String sql="DELETE FROM products WHERE product_id=?";

            PreparedStatement ps=con.prepareStatement(sql);

            ps.setInt(1,id);

            ps.executeUpdate();

            ps.close();

            con.close();

            response.sendRedirect(request.getContextPath()+"/adminProducts");

        }

        catch(Exception e){

            e.printStackTrace();

        }

    }

}