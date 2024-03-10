import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class CrossOriginMessagingTester {

    public static void main(String[] args) {
        // Ask for target website URL
        System.out.println("Enter your target website URL: ");
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String targetUrl = "";
        try {
            targetUrl = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Test for vulnerability
        boolean isVulnerable = testForVulnerability(targetUrl);

        // Output result
        System.out.println("\nTest completed.\n");
        if (isVulnerable) {
            System.out.println("The target website is vulnerable to HTML5 Cross-Origin Messaging.");
            System.out.println("Testing the vulnerability by sending a cross-origin message...");
            sendCrossOriginMessage(targetUrl);
        } else {
            System.out.println("The target website is not vulnerable to HTML5 Cross-Origin Messaging.");
        }
    }

    private static boolean testForVulnerability(String targetUrl) {
        boolean isVulnerable = false;
        try {
            // Send a cross-origin request
            URL url = new URL(targetUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Origin", "http://malicious-domain.com");
            connection.connect();

            // Check response code
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                isVulnerable = true;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return isVulnerable;
    }

    private static void sendCrossOriginMessage(String targetUrl) {
        try {
            // Construct URL for the target website
            URL url = new URL(targetUrl);

            // Open connection
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST"); // Use appropriate HTTP method
            connection.setRequestProperty("Content-Type", "application/json"); // Set appropriate Content-Type header
            connection.setRequestProperty("Access-Control-Allow-Origin", "*"); // Allow cross-origin requests
            connection.setDoOutput(true); // Enable output for the request

            // Construct and send the message
            String message = "{\"key\": \"value\"}"; // Your message content
            connection.getOutputStream().write(message.getBytes());

            // Get response
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String line;
            StringBuffer response = new StringBuffer();
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();

            // Print response
            System.out.println("Response from target website:");
            System.out.println(response.toString());

            // Close connection
            connection.disconnect();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
