package util;

import java.sql.*;

public final class DBConnection {

    private static final String DEFAULT_URL = "jdbc:mysql://acela.proxy.rlwy.net:47498/railway";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "ukgEYWWRbFSCfNaIMOnzVidlhccaZUCy";

    private static final String URL = resolve("SHOPSPHERE_DB_URL", "shopsphere.db.url", DEFAULT_URL);
    private static final String USER = resolve("SHOPSPHERE_DB_USER", "shopsphere.db.user", DEFAULT_USER);
    private static final String PASSWORD = resolve("SHOPSPHERE_DB_PASSWORD", "shopsphere.db.password", DEFAULT_PASSWORD);

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError(e);
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static String resolve(String envName, String propertyName, String defaultValue) {
        String propertyValue = System.getProperty(propertyName);
        if (propertyValue != null && !propertyValue.isBlank()) {
            return propertyValue;
        }

        String envValue = System.getenv(envName);
        if (envValue != null && !envValue.isBlank()) {
            return envValue;
        }

        return defaultValue;
    }
}
