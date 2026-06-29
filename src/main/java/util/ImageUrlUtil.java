package util;

import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;


public final class ImageUrlUtil {

    private ImageUrlUtil() {
    }

    public static String resolve(HttpServletRequest request, String imageUrl) {
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            return request.getContextPath() + "/images/products/default.webp";
        }

        String trimmed = imageUrl.trim();

        if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
            return trimmed;
        }

        if (trimmed.startsWith("/")) {
            return request.getContextPath() + trimmed;
        }

        return request.getContextPath() + "/" + trimmed;
    }
}
