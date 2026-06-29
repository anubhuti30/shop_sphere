package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;


import model.Product;

@WebServlet("/OrderConfirmationServlet")
public class OrderConfirmationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        List<Product> cartProducts = null;

        if (session != null) {
            cartProducts = (List<Product>) session.getAttribute("checkoutCartProducts");
            if (cartProducts == null) {
                cartProducts = (List<Product>) session.getAttribute("cartProducts");
            }
        }

        double grandTotal = 0;
        if (cartProducts != null) {
            for (Product p : cartProducts) {
                grandTotal += p.getPrice() * p.getQuantity();
            }
        }

        // Unique Order ID
        String orderId = UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        // Order Date
        String orderDate = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new Date());

        request.setAttribute("orderId", orderId);
        request.setAttribute("orderDate", orderDate);
        request.setAttribute("cartProducts", cartProducts);
        request.setAttribute("grandTotal", grandTotal);

        if (session != null) {
            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastOrderDate", orderDate);
            session.setAttribute("lastOrderTotal", grandTotal);
            session.removeAttribute("cartProducts");
        }

        RequestDispatcher rd = request.getRequestDispatcher("/orderconfirmation.jsp");
        rd.forward(request, response);
    }
}
