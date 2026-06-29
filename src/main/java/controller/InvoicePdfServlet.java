package controller;

import model.Product;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@WebServlet("/InvoicePdfServlet")
public class InvoicePdfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/u_login.html");
            return;
        }

        List<Product> cartProducts = getProducts(session);
        double grandTotal = getTotal(session, cartProducts);
        String orderId = stringValue(session.getAttribute("lastOrderId"));
        String orderDate = stringValue(session.getAttribute("lastOrderDate"));

        if (orderId.isEmpty()) {
            orderId = "INV-" + new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        }
        if (orderDate.isEmpty()) {
            orderDate = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new Date());
        }

        byte[] pdf = buildPdf(orderId, orderDate, cartProducts, grandTotal, stringValue(session.getAttribute("username")));

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"ShopSphere-Invoice-" + orderId + ".pdf\"");
        response.setContentLength(pdf.length);
        response.getOutputStream().write(pdf);
    }

    private List<Product> getProducts(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<Product> checkoutProducts = (List<Product>) session.getAttribute("checkoutCartProducts");
        if (checkoutProducts != null) {
            return checkoutProducts;
        }

        @SuppressWarnings("unchecked")
        List<Product> cartProducts = (List<Product>) session.getAttribute("cartProducts");
        if (cartProducts != null) {
            return cartProducts;
        }

        return new ArrayList<>();
    }

    private double getTotal(HttpSession session, List<Product> cartProducts) {
        Object total = session.getAttribute("lastOrderTotal");
        if (total instanceof Number) {
            return ((Number) total).doubleValue();
        }

        Object checkoutTotal = session.getAttribute("checkoutGrandTotal");
        if (checkoutTotal instanceof Number) {
            return ((Number) checkoutTotal).doubleValue();
        }

        double calculated = 0;
        for (Product product : cartProducts) {
            calculated += product.getPrice() * product.getQuantity();
        }
        return calculated;
    }

    private byte[] buildPdf(String orderId,
                            String orderDate,
                            List<Product> cartProducts,
                            double grandTotal,
                            String username) throws IOException {
        DecimalFormat df = new DecimalFormat("0.00");
        String safeCustomer = username == null ? "" : username.trim();
        int firstPageRows = cartProducts.isEmpty() ? 0 : Math.min(14, cartProducts.size());
        int remainingRows = Math.max(0, cartProducts.size() - firstPageRows);
        int continuationPages = remainingRows == 0 ? 0 : (remainingRows + 19) / 20;
        int totalPages = 1 + continuationPages;

        List<PageBuffer> pages = new ArrayList<>();
        int cursor = 0;

        PageBuffer firstPage = new PageBuffer();
        drawFirstPage(firstPage, orderId, orderDate, safeCustomer, df, grandTotal, cartProducts, cursor, firstPageRows, totalPages);
        pages.add(firstPage);
        cursor += firstPageRows;

        for (int pageNumber = 2; pageNumber <= totalPages; pageNumber++) {
            int pageRows = Math.min(20, cartProducts.size() - cursor);
            PageBuffer page = new PageBuffer();
            drawContinuationPage(page, orderId, orderDate, df, cartProducts, cursor, pageRows, pageNumber, totalPages);
            pages.add(page);
            cursor += pageRows;
        }

        return writePdfDocument(pages);
    }

    private void drawFirstPage(PageBuffer page,
                               String orderId,
                               String orderDate,
                               String safeCustomer,
                               DecimalFormat df,
                               double grandTotal,
                               List<Product> cartProducts,
                               int startIndex,
                               int rowCount,
                               int totalPages) {
        double subtotal = grandTotal;
        double shipping = 0.0;
        double tax = 0.0;
        double total = grandTotal;

        fillRect(page, 0, 0, 595, 842, 1, 1, 1);
        drawHeader(page, orderId, orderDate, 82, false, 1, totalPages);

        strokeRect(page, 42, 674, 328, 68, 0.86, 0.89, 0.93, 1.0);
        fillRect(page, 42, 674, 328, 22, 0.95, 0.97, 1.0);
        addText(page, "F2", 9, 56, 687, "CUSTOMER", 0.40, 0.46, 0.55);
        addText(page, "F1", 13, 56, 665, safeCustomer.isEmpty() ? "Guest" : safeCustomer, 0.09, 0.14, 0.20);
        addText(page, "F1", 9, 56, 651, "Billing prepared from the active session.", 0.47, 0.53, 0.62);

        strokeRect(page, 386, 674, 167, 68, 0.86, 0.89, 0.93, 1.0);
        fillRect(page, 386, 674, 167, 22, 0.95, 0.97, 1.0);
        addText(page, "F2", 9, 400, 687, "SUMMARY", 0.40, 0.46, 0.55);
        addText(page, "F1", 12, 400, 665, "Rs " + df.format(total), 0.09, 0.14, 0.20);
        addText(page, "F1", 9, 400, 651, "Grand total payable", 0.47, 0.53, 0.62);

        fillRect(page, 42, 618, 511, 28, 0.09, 0.14, 0.20);
        addText(page, "F2", 9, 56, 627, "PRODUCT", 1, 1, 1);
        addText(page, "F2", 9, 338, 627, "QTY", 1, 1, 1);
        addText(page, "F2", 9, 386, 627, "UNIT PRICE", 1, 1, 1);
        addText(page, "F2", 9, 484, 627, "AMOUNT", 1, 1, 1);

        int startY = 590;
        int rowHeight = 28;
        if (rowCount == 0) {
            fillRect(page, 42, startY - 4, 511, rowHeight, 0.97, 0.98, 0.99);
            addText(page, "F1", 11, 56, startY + 6, "No items available in this order.", 0.38, 0.43, 0.50);
        } else {
            for (int i = 0; i < rowCount; i++) {
                Product product = cartProducts.get(startIndex + i);
                int y = startY - (i * rowHeight);
                if (i % 2 == 0) {
                    fillRect(page, 42, y - 4, 511, rowHeight, 0.98, 0.99, 1.0);
                }

                String name = truncate(product.getProductName(), 42);
                String unitPrice = "Rs " + df.format(product.getPrice());
                String amount = "Rs " + df.format(product.getPrice() * product.getQuantity());

                addText(page, "F1", 10, 56, y + 6, name, 0.08, 0.13, 0.20);
                addText(page, "F1", 10, 346, y + 6, String.valueOf(product.getQuantity()), 0.08, 0.13, 0.20);
                addText(page, "F1", 10, 402, y + 6, unitPrice, 0.08, 0.13, 0.20);
                addText(page, "F1", 10, 502, y + 6, amount, 0.08, 0.13, 0.20);
                drawRule(page, 42, y - 4, 553, y - 4, 0.88, 0.91, 0.95, 0.6);
            }

            if (startIndex + rowCount < cartProducts.size()) {
                addText(page, "F1", 9, 42, startY - (rowHeight * rowCount) - 2,
                        "Additional items continue on the next page.", 0.47, 0.53, 0.62);
            }
        }

        strokeRect(page, 340, 178, 213, 120, 0.86, 0.89, 0.93, 1.0);
        fillRect(page, 340, 272, 213, 26, 0.95, 0.97, 1.0);
        addText(page, "F2", 9, 354, 192, "PAYMENT BREAKDOWN", 0.40, 0.46, 0.55);
        addText(page, "F1", 10, 354, 162, "Subtotal", 0.23, 0.28, 0.35);
        addText(page, "F1", 10, 354, 146, "Shipping", 0.23, 0.28, 0.35);
        addText(page, "F1", 10, 354, 130, "Tax", 0.23, 0.28, 0.35);
        addText(page, "F2", 12, 354, 108, "Grand Total", 0.06, 0.11, 0.18);
        addText(page, "F1", 10, 522, 162, "Rs " + df.format(subtotal), 0.23, 0.28, 0.35, true);
        addText(page, "F1", 10, 522, 146, shipping == 0.0 ? "Free" : "Rs " + df.format(shipping), 0.23, 0.28, 0.35, true);
        addText(page, "F1", 10, 522, 130, tax == 0.0 ? "Included" : "Rs " + df.format(tax), 0.23, 0.28, 0.35, true);
        addText(page, "F2", 12, 522, 108, "Rs " + df.format(total), 0.06, 0.11, 0.18, true);

        drawRule(page, 42, 132, 553, 132, 0.84, 0.88, 0.93, 0.8);
        addText(page, "F1", 9, 42, 112, "Thank you for shopping with ShopSphere.", 0.34, 0.40, 0.47);
        addText(page, "F1", 8, 42, 98, "This invoice was generated from your order session and is ready for download or printing.", 0.53, 0.58, 0.66);
        drawFooter(page, 1, totalPages);
    }

    private void drawContinuationPage(PageBuffer page,
                                      String orderId,
                                      String orderDate,
                                      DecimalFormat df,
                                      List<Product> cartProducts,
                                      int startIndex,
                                      int rowCount,
                                      int pageNumber,
                                      int totalPages) {
        fillRect(page, 0, 0, 595, 842, 1, 1, 1);
        drawHeader(page, orderId, orderDate, 68, true, pageNumber, totalPages);

        fillRect(page, 42, 716, 511, 24, 0.09, 0.14, 0.20);
        addText(page, "F2", 9, 56, 723, "PRODUCT", 1, 1, 1);
        addText(page, "F2", 9, 338, 723, "QTY", 1, 1, 1);
        addText(page, "F2", 9, 386, 723, "UNIT PRICE", 1, 1, 1);
        addText(page, "F2", 9, 484, 723, "AMOUNT", 1, 1, 1);

        int startY = 690;
        int rowHeight = 28;

        for (int i = 0; i < rowCount; i++) {
            Product product = cartProducts.get(startIndex + i);
            int y = startY - (i * rowHeight);
            if (i % 2 == 0) {
                fillRect(page, 42, y - 4, 511, rowHeight, 0.98, 0.99, 1.0);
            }

            String name = truncate(product.getProductName(), 42);
            String unitPrice = "Rs " + df.format(product.getPrice());
            String amount = "Rs " + df.format(product.getPrice() * product.getQuantity());

            addText(page, "F1", 10, 56, y + 6, name, 0.08, 0.13, 0.20);
            addText(page, "F1", 10, 346, y + 6, String.valueOf(product.getQuantity()), 0.08, 0.13, 0.20);
            addText(page, "F1", 10, 402, y + 6, unitPrice, 0.08, 0.13, 0.20);
            addText(page, "F1", 10, 502, y + 6, amount, 0.08, 0.13, 0.20);
            drawRule(page, 42, y - 4, 553, y - 4, 0.88, 0.91, 0.95, 0.6);
        }

        if (startIndex + rowCount < cartProducts.size()) {
            addText(page, "F1", 9, 42, startY - (rowHeight * rowCount) - 2,
                    "Additional items continue on the next page.", 0.47, 0.53, 0.62);
        }

        drawFooter(page, pageNumber, totalPages);
    }

    private void drawHeader(PageBuffer page,
                            String orderId,
                            String orderDate,
                            int bandHeight,
                            boolean compact,
                            int pageNumber,
                            int totalPages) {
        fillRect(page, 0, 842 - bandHeight, 595, bandHeight, 0.05, 0.11, 0.22);

        int logoY = compact ? 792 : 794;
        int titleY = compact ? 792 : 800;
        int subY = compact ? 776 : 782;
        int sub2Y = compact ? 764 : 770;
        int metaTopY = compact ? 794 : 804;
        int metaValueY = compact ? 777 : 787;
        int metaDateY = compact ? 766 : 776;
        int metaDateValueY = compact ? 749 : 761;

        fillRect(page, 42, compact ? 784 : 776, 28, 28, 0.12, 0.68, 0.90);
        addText(page, "F2", 16, 48, logoY, "S", 1, 1, 1);
        addText(page, "F2", compact ? 18 : 24, 78, titleY, "ShopSphere Invoice", 1, 1, 1);
        addText(page, "F1", compact ? 9 : 10, 78, subY,
                compact ? "Order details continued on the next page." : "Clean order summary and payment record",
                0.82, 0.88, 0.95);
        addText(page, "F1", compact ? 9 : 10, 78, sub2Y,
                compact ? "ShopSphere checkout and billing" : "Generated automatically from the checkout flow",
                0.76, 0.83, 0.91);

        strokeRect(page, 394, compact ? 770 : 768, 160, compact ? 48 : 54, 0.78, 0.84, 0.90, 0.9);
        addText(page, "F2", 9, 408, metaTopY, "ORDER ID", 0.52, 0.58, 0.66);
        addText(page, "F1", 11, 408, metaValueY, orderId, 0.08, 0.13, 0.20);
        addText(page, "F2", 9, 408, metaDateY, "DATE", 0.52, 0.58, 0.66);
        addText(page, "F1", 11, 408, metaDateValueY, orderDate, 0.08, 0.13, 0.20);
    }

    private byte[] writePdfDocument(List<PageBuffer> pages) throws IOException {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        List<Integer> offsets = new ArrayList<>();
        int pageCount = pages.size();
        int firstFontObject = 3 + (pageCount * 2);
        int secondFontObject = firstFontObject + 1;

        write(out, "%PDF-1.4\n");

        offsets.add(out.size());
        write(out, "1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n");

        offsets.add(out.size());
        StringBuilder kids = new StringBuilder();
        for (int i = 0; i < pageCount; i++) {
            if (i > 0) {
                kids.append(' ');
            }
            kids.append(3 + (i * 2)).append(" 0 R");
        }
        write(out, "2 0 obj\n<< /Type /Pages /Kids [" + kids + "] /Count " + pageCount + " >>\nendobj\n");

        for (int i = 0; i < pageCount; i++) {
            int pageObject = 3 + (i * 2);
            int contentObject = pageObject + 1;
            byte[] contentBytes = pages.get(i).content.toString().getBytes(StandardCharsets.US_ASCII);

            offsets.add(out.size());
            write(out,
                    pageObject + " 0 obj\n"
                            + "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] "
                            + "/Resources << /Font << /F1 " + firstFontObject + " 0 R /F2 " + secondFontObject + " 0 R >> >> "
                            + "/Contents " + contentObject + " 0 R >>\n"
                            + "endobj\n");

            offsets.add(out.size());
            write(out, contentObject + " 0 obj\n<< /Length " + contentBytes.length + " >>\nstream\n");
            out.write(contentBytes);
            write(out, "\nendstream\nendobj\n");
        }

        offsets.add(out.size());
        write(out, firstFontObject + " 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>\nendobj\n");

        offsets.add(out.size());
        write(out, secondFontObject + " 0 obj\n<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>\nendobj\n");

        int xrefStart = out.size();
        int totalObjects = 2 + (pageCount * 2) + 2;
        write(out, "xref\n0 " + (totalObjects + 1) + "\n");
        write(out, "0000000000 65535 f \n");
        for (int offset : offsets) {
            write(out, String.format("%010d 00000 n \n", offset));
        }
        write(out, "trailer\n<< /Size " + (totalObjects + 1) + " /Root 1 0 R >>\n");
        write(out, "startxref\n" + xrefStart + "\n%%EOF");

        return out.toByteArray();
    }

    private void drawFooter(PageBuffer page, int pageNumber, int totalPages) {
        drawRule(page, 42, 56, 553, 56, 0.84, 0.88, 0.93, 0.8);
        addText(page, "F1", 8, 42, 40, "ShopSphere", 0.40, 0.46, 0.55);
        addText(page, "F1", 8, 553, 40, "Page " + pageNumber + " of " + totalPages, 0.40, 0.46, 0.55, true);
    }

    private void write(ByteArrayOutputStream out, String text) throws IOException {
        out.write(text.getBytes(StandardCharsets.US_ASCII));
    }

    private void addText(PageBuffer page,
                         String font,
                         int size,
                         int x,
                         int y,
                         String text,
                         double r,
                         double g,
                         double b) {
        addText(page, font, size, x, y, text, r, g, b, false);
    }

    private void addText(PageBuffer page,
                         String font,
                         int size,
                         int x,
                         int y,
                         String text,
                         double r,
                         double g,
                         double b,
                         boolean rightAlign) {
        String safe = escape(text);
        StringBuilder block = new StringBuilder();
        block.append("BT\n");
        block.append(String.format(java.util.Locale.US, "%.3f %.3f %.3f rg\n", r, g, b));
        block.append("/").append(font).append(" ").append(size).append(" Tf\n");
        if (rightAlign) {
            int estimatedWidth = estimateTextWidth(text, size);
            x = Math.max(0, x - estimatedWidth);
        }
        block.append(x).append(" ").append(y).append(" Td\n");
        block.append("(").append(safe).append(") Tj\n");
        block.append("ET\n");
        page.content.append(block);
    }

    private void fillRect(PageBuffer page,
                          int x,
                          int y,
                          int width,
                          int height,
                          double r,
                          double g,
                          double b) {
        page.content.append(String.format(java.util.Locale.US,
                "%.3f %.3f %.3f rg\n%d %d %d %d re\nf\n",
                r, g, b, x, y, width, height));
    }

    private void strokeRect(PageBuffer page,
                            int x,
                            int y,
                            int width,
                            int height,
                            double r,
                            double g,
                            double b,
                            double lineWidth) {
        page.content.append(String.format(java.util.Locale.US,
                "q\n%.3f %.3f %.3f RG\n%.3f w\n%d %d %d %d re\nS\nQ\n",
                r, g, b, lineWidth, x, y, width, height));
    }

    private void drawRule(PageBuffer page,
                          int x1,
                          int y1,
                          int x2,
                          int y2,
                          double r,
                          double g,
                          double b,
                          double lineWidth) {
        page.content.append(String.format(java.util.Locale.US,
                "q\n%.3f %.3f %.3f RG\n%.3f w\n%d %d m\n%d %d l\nS\nQ\n",
                r, g, b, lineWidth, x1, y1, x2, y2));
    }

    private int estimateTextWidth(String text, int fontSize) {
        if (text == null || text.isEmpty()) {
            return 0;
        }
        return Math.min(180, (int) Math.round(text.length() * fontSize * 0.52));
    }

    private String truncate(String text, int maxChars) {
        if (text == null) {
            return "";
        }

        String trimmed = text.trim();
        if (trimmed.length() <= maxChars) {
            return trimmed;
        }

        if (maxChars <= 3) {
            return trimmed.substring(0, maxChars);
        }

        return trimmed.substring(0, maxChars - 3) + "...";
    }

    private String escape(String text) {
        String safe = text == null ? "" : text;
        safe = safe.replace("\\", "\\\\")
                .replace("(", "\\(")
                .replace(")", "\\)");

        StringBuilder ascii = new StringBuilder(safe.length());
        for (int i = 0; i < safe.length(); i++) {
            char c = safe.charAt(i);
            ascii.append(c >= 32 && c <= 126 ? c : '?');
        }
        return ascii.toString();
    }

    private String stringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private static final class PageBuffer {
        private final StringBuilder content = new StringBuilder();
    }
}
