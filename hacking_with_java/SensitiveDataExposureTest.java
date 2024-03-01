import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

public class SensitiveDataExposureTest {

    private static final Scanner scanner = new Scanner(System.in);
    private static final String RESET = "\u001B[0m";
    private static final String RED = "\u001B[31m";
    private static final String GREEN = "\u001B[32m";

    public static void main(String[] args) {
        System.out.print("Enter your target website URL: ");
        String urlToTest = scanner.nextLine();

        // Predefined sensitive data patterns
        String[] predefinedPatterns = {
            "Password",
            "Credit Card Number",
            "Social Security Number",
            "Date of Birth",
            "Email Address",
            "Phone Number",
            "Address",
            "Passport Number",
            "Driver's License Number",
            "Bank Account Number",
            "Personal Identification Number (PIN)",
            "Health Insurance Information",
            "National Identification Number",
            "Tax Identification Number"
        };

        System.out.println("Predefined sensitive data patterns:");
        for (String pattern : predefinedPatterns) {
            System.out.println("- " + pattern);
        }

        System.out.print("Enter additional sensitive data patterns (comma-separated, leave empty if none): ");
        String additionalPatternsInput = scanner.nextLine();
        List<String> sensitiveDataPatterns = new ArrayList<>();

        for (String pattern : additionalPatternsInput.split(",")) {
            if (!pattern.trim().isEmpty()) {
                sensitiveDataPatterns.add(pattern.trim());
            }
        }

        try {
            URL url = new URL(urlToTest);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            if (connection instanceof HttpsURLConnection) {
                // Skip certificate validation for HTTPS connections
                skipCertificateValidation();
            }

            connection.setRequestMethod("GET");

            int responseCode = connection.getResponseCode();
            System.out.println("Response Code: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder response = new StringBuilder();
                String inputLine;

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                // Check for sensitive data in the response
                String responseBody = response.toString();
                for (String pattern : sensitiveDataPatterns) {
                    if (containsSensitiveData(responseBody, pattern)) {
                        System.out.println(RED + "Sensitive data pattern '" + pattern + "' found on the website: " + url + RESET);
                    } else {
                        System.out.println(GREEN + "No sensitive data pattern '" + pattern + "' found on the website: " + url + RESET);
                    }
                }
            } else {
                System.out.println(RED + "Failed to retrieve content from the website: " + url + RESET);
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static void skipCertificateValidation() {
        // Create a trust manager that does not validate certificate chains
        TrustManager[] trustAllCerts = new TrustManager[] {
            new X509TrustManager() {
                public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
                public void checkClientTrusted(
                    java.security.cert.X509Certificate[] certs, String authType) {
                }
                public void checkServerTrusted(
                    java.security.cert.X509Certificate[] certs, String authType) {
                }
            }
        };

        // Install the all-trusting trust manager
        try {
            SSLContext sc = SSLContext.getInstance("TLS");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static boolean containsSensitiveData(String responseBody, String sensitiveDataPattern) {
        // Use regex for pattern matching
        Pattern pattern = Pattern.compile("\\b" + sensitiveDataPattern + "\\b", Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(responseBody);
        return matcher.find();
    }
}
