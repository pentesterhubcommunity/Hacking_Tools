import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class WafEvasionTester {

    public static void main(String[] args) {
        System.out.println("\u001B[36mWeb Application Firewall (WAF) Evasion Tester\u001B[0m");
        System.out.print("Enter your target website URL: ");
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        try {
            String targetUrl = reader.readLine();
            testWafEvasion(targetUrl);
        } catch (IOException e) {
            System.out.println("An error occurred while reading input: " + e.getMessage());
        }
    }

    private static void testWafEvasion(String targetUrl) {
        try {
            URL url = new URL(targetUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            int responseCode = connection.getResponseCode();
            if (responseCode == 200) {
                System.out.println("\u001B[32mTarget is potentially vulnerable to WAF evasion.\u001B[0m");
                System.out.println("Here's how to test this vulnerability:");
                System.out.println("1. Use different HTTP methods (POST, PUT, DELETE) instead of GET.");
                System.out.println("2. Manipulate parameters by adding special characters or encoding them differently.");
                System.out.println("3. Use alternative encodings like Base64 or URL encoding.");
                System.out.println("\n\u001B[34mResponse from the server:\u001B[0m");
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    System.out.println(inputLine);
                }
                in.close();
            } else {
                System.out.println("\u001B[33mTarget does not seem to be vulnerable to WAF evasion.\u001B[0m");
            }
        } catch (IOException e) {
            System.out.println("An error occurred while testing WAF evasion: " + e.getMessage());
        }
    }
}
