package admin;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter({
        "/adminDashboard",
        "/adminProducts",
        "/addProduct",
        "/adminEditProduct",
        "/adminUpdateProduct",
        "/adminDeleteProduct",
        "/dashboard.jsp",
        "/adminProducts.jsp",
        "/adminAddProduct.jsp",
        "/adminEditProduct.jsp"
})
public class AdminAuthFilter extends HttpFilter {

    @Override
    protected void doFilter(HttpServletRequest request,
                            HttpServletResponse response,
                            FilterChain chain)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("admin") != null) {
            chain.doFilter(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
