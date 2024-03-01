import java.net.HttpURLConnection;
import java.net.URL;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.util.Scanner;

public class CachePoisoningTester {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter your target website URL: ");
        String targetUrl = scanner.nextLine();

        HttpURLConnection connection = null;
        BufferedReader reader = null;

        try {
            // Send a GET request to the target URL
            URL url = new URL(targetUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000); // Adjust timeout as needed
            connection.setReadTimeout(5000); // Adjust timeout as needed

            int responseCode = connection.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Read response from the server
                reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String line;
                StringBuilder response = new StringBuilder();

                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }

                // Print response headers
                System.out.println("\nResponse from " + targetUrl + ":");
                System.out.println(response.toString());

                // Analyze response headers
                System.out.println("\nCache-Control: " + connection.getHeaderField("Cache-Control"));
                System.out.println("Expires: " + connection.getHeaderField("Expires"));
                System.out.println("Vary: " + connection.getHeaderField("Vary"));

                // Test cache poisoning with additional HTTP methods
                testCachePoisoning(url);

            } else {
                System.out.println("\nFailed to fetch content from " + targetUrl + ". Response code: " + responseCode);
            }

        } catch (Exception e) {
            System.err.println("\nError occurred: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources
            if (reader != null) {
                try {
                    reader.close();
                } catch (Exception e) {
                    System.err.println("Error closing reader: " + e.getMessage());
                }
            }
            if (connection != null) {
                connection.disconnect();
            }
            scanner.close();
        }
    }

    private static void testCachePoisoning(URL url) {
        Scanner scanner = new Scanner(System.in);

        // Options for cache poisoning testing
        System.out.println("\nSelect cache poisoning test:");
        System.out.println("1. Send POST request with manipulated parameters");
        System.out.println("2. Send PUT request to manipulate cache entries");
        System.out.println("3. Send DELETE request to remove cache entries");
        System.out.println("0. Exit");
        System.out.print("Enter your choice: ");
        
        int choice = scanner.nextInt();

        switch (choice) {
            case 1:
                // Test cache poisoning with manipulated parameters (POST request)
                // Implement the logic for crafting and sending POST requests
                System.out.println("Testing cache poisoning with manipulated parameters (POST request)...");
                // Craft and send POST request
                break;
            case 2:
                // Test cache poisoning by manipulating cache entries (PUT request)
                // Implement the logic for crafting and sending PUT requests
                System.out.println("Testing cache poisoning by manipulating cache entries (PUT request)...");
                // Craft and send PUT request
                break;
            case 3:
                // Test cache poisoning by removing cache entries (DELETE request)
                // Implement the logic for crafting and sending DELETE requests
                System.out.println("Testing cache poisoning by removing cache entries (DELETE request)...");
                // Craft and send DELETE request
                break;
            case 0:
                // Exit the program
                System.out.println("Exiting...");
                System.exit(0);
                break;
            default:
                System.out.println("Invalid choice. Please try again.");
        }

        scanner.close();
    }
}
