import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class HttpSecurityHeaderTester {
    // ANSI color codes for colored output
    public static final String ANSI_RESET = "\u001B[0m";
    public static final String ANSI_GREEN = "\u001B[32m";
    public static final String ANSI_RED = "\u001B[31m";

    public static void main(String[] args) {
        System.out.println("Welcome to the Advanced HTTP Security Headers Vulnerability Tester!");

        // Prompt user to enter target website URL
        System.out.print("Please enter the URL of the website you want to test: ");
        String targetUrl = "";
        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
            targetUrl = reader.readLine();
        } catch (IOException e) {
            System.err.println("Error reading input.");
            return;
        }

        // Test for security headers and vulnerabilities
        boolean vulnerable = testSecurityHeaders(targetUrl);

        // Display result
        System.out.println("\n-----------------------------------------");
        if (vulnerable) {
            System.out.println("The target website may be vulnerable to HTTP Security Headers Misconfiguration.");
            System.out.println("Please review the detailed vulnerability report for further analysis.");
        } else {
            System.out.println("Great news! The target website appears to have strong security headers configuration.");
        }
        System.out.println("-----------------------------------------");
    }

    private static boolean testSecurityHeaders(String url) {
        ExecutorService executor = Executors.newFixedThreadPool(4);
        try {
            URL targetUrl = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) targetUrl.openConnection();
            connection.setRequestMethod("HEAD");
            connection.setConnectTimeout(5000); // 5 seconds timeout
            Map<String, java.util.List<String>> headers = connection.getHeaderFields();

            // Check for essential security headers and vulnerabilities concurrently
            boolean hasContentSecurityPolicy = false;
            boolean hasXContentTypeOptions = false;
            boolean hasXFrameOptions = false;
            boolean hasXXSSProtection = false;

            for (Map.Entry<String, java.util.List<String>> entry : headers.entrySet()) {
                String headerName = entry.getKey();
                if (headerName != null) {
                    switch (headerName.toLowerCase()) {
                        case "content-security-policy":
                            hasContentSecurityPolicy = true;
                            // TODO: Analyze CSP Policy
                            break;
                        case "x-content-type-options":
                            hasXContentTypeOptions = true;
                            // TODO: Analyze X-Content-Type-Options
                            break;
                        case "x-frame-options":
                            hasXFrameOptions = true;
                            // TODO: Analyze X-Frame-Options
                            break;
                        case "x-xss-protection":
                            hasXXSSProtection = true;
                            // TODO: Analyze X-XSS-Protection
                            break;
                        // Add more headers to analyze if needed
                    }
                }
            }

            // Log header presence with colored output
            System.out.println("\nTesting security headers for: " + url);
            System.out.println("-----------------------------------------");
            System.out.println("Content-Security-Policy Header: " + (hasContentSecurityPolicy ? ANSI_GREEN + "✅ Present" : ANSI_RED + "❌ Missing"));
            System.out.println("X-Content-Type-Options Header: " + (hasXContentTypeOptions ? ANSI_GREEN + "✅ Present" : ANSI_RED + "❌ Missing"));
            System.out.println("X-Frame-Options Header: " + (hasXFrameOptions ? ANSI_GREEN + "✅ Present" : ANSI_RED + "❌ Missing"));
            System.out.println("X-XSS-Protection Header: " + (hasXXSSProtection ? ANSI_GREEN + "✅ Present" : ANSI_RED + "❌ Missing"));

            // TODO: Generate detailed vulnerability report based on the analysis

            return !(hasContentSecurityPolicy && hasXContentTypeOptions && hasXFrameOptions && hasXXSSProtection);
        } catch (IOException e) {
            System.err.println("Error connecting to target URL: " + e.getMessage());
            return false;
        } finally {
            executor.shutdown();
        }
    }
}
