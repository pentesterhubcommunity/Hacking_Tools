import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class DebugEndpointTester {

    public static void main(String[] args) {
        System.out.println("\033[0;34mWelcome to Exposed Debug Endpoints Tester!\033[0m");
        System.out.print("\033[0;33mEnter your target website URL: \033[0m");
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        try {
            String targetUrl = reader.readLine();
            System.out.println("\033[0;34mTesting for exposed debug endpoints on: " + targetUrl + "...\033[0m");
            testDebugEndpoints(targetUrl);
        } catch (IOException e) {
            System.err.println("\033[0;31mError reading input. Please try again.\033[0m");
        }
    }

    private static void testDebugEndpoints(String targetUrl) {
        try {
            // Test for common debug endpoints
            String[] debugEndpoints = {"debug", "info", "status", "health", "metrics", "monitoring", "diagnostics", "trace", "admin", "dashboard", "logs", "system", "test", "dev", "setup", "debugging"};

            for (String endpoint : debugEndpoints) {
                URL url = new URL(targetUrl + "/" + endpoint);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("GET");
                int responseCode = connection.getResponseCode();

                if (responseCode == HttpURLConnection.HTTP_OK) {
                    System.out.println("\033[0;33mVulnerable endpoint found: " + endpoint + "\033[0m");
                    System.out.println("\033[0;32mHow to test vulnerability: \033[0m");
                    System.out.println("Try accessing the endpoint directly in a web browser or using tools like cURL or Postman.");
                    System.out.println("Check if the endpoint provides sensitive information or exposes internal details of the server.");
                } else {
                    System.out.println("\033[0;36mNo vulnerable endpoint found: " + endpoint + "\033[0m");
                }
                connection.disconnect();
            }
        } catch (IOException e) {
            System.err.println("\033[0;31mError testing debug endpoints: " + e.getMessage() + "\033[0m");
        }
    }
}
