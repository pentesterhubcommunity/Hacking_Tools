import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class HTMLInjectionTester {

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        try {
            // Prompt the user to enter the target website URL
            System.out.print("Enter the target website URL: ");
            String websiteURL = reader.readLine().trim();

            // Perform injection test
            testForInjection(websiteURL);
        } catch (IOException e) {
            System.out.println("Error reading input: " + e.getMessage());
        } finally {
            // Close the reader
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private static void testForInjection(String websiteURL) {
        // Injected script to test for vulnerability
        String injectedScript = "<script>alert('Vulnerable to HTML Injection!')</script>";

        try {
            // Create URL object
            URL url = new URL(websiteURL);

            // Test for injection in GET request
            testInjectionPoint(url, "GET", injectedScript);

            // Test for injection in POST request
            testInjectionPoint(url, "POST", injectedScript);
        } catch (IOException e) {
            System.out.println("Error occurred while testing for injection: " + e.getMessage());
        }
    }

    private static void testInjectionPoint(URL url, String method, String injectedScript) throws IOException {
        // Establish connection
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        // Set request method
        connection.setRequestMethod(method);

        // Get response code
        int responseCode = connection.getResponseCode();

        // Read response
        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        StringBuilder response = new StringBuilder();
        String inputLine;

        while ((inputLine = reader.readLine()) != null) {
            response.append(inputLine);
        }
        reader.close();

        // Check if injected script is present in the response
        if (response.toString().contains(injectedScript)) {
            System.out.println("Vulnerable to HTML Injection in " + method + " request.");
        } else {
            System.out.println("Not vulnerable to HTML Injection in " + method + " request.");
        }
    }
}
