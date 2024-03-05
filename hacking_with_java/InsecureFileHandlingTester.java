import java.io.*;
import java.net.*;
import java.util.Scanner;

public class InsecureFileHandlingTester {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Prompt the user to enter the target website URL
        System.out.print("Enter your target website URL: ");
        String targetUrl = scanner.nextLine();

        // Perform the test
        testInsecureFileHandling(targetUrl);

        scanner.close();
    }

    public static void testInsecureFileHandling(String targetUrl) {
        try {
            // Construct a URL object
            URL url = new URL(targetUrl);

            // Open a connection to the URL
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            // Set request method to GET
            connection.setRequestMethod("GET");

            // Get the response code
            int responseCode = connection.getResponseCode();

            // Check if the response code indicates success
            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Vulnerability found
                System.out.println("<html>");
                System.out.println("<body>");
                System.out.println("<h1 style=\"color:red;\">Insecure File Handling vulnerability found on: " + targetUrl + "</h1>");
                System.out.println("<p>This vulnerability allows an attacker to read sensitive files on the server.</p>");

                // Check for common sensitive file paths or extensions
                String[] sensitiveFiles = {
                    "/etc/passwd", 
                    "/etc/shadow", 
                    ".env", 
                    "web.config",
                    "/etc/apache2/apache2.conf",
                    "/etc/ssh/sshd_config",
                    "/etc/mysql/my.cnf",
                    "/var/www/html/config.php",
                    "/var/www/html/wp-config.php",
                    "/home/user/.ssh/id_rsa",
                    "/home/user/.bash_history",
                    "/proc/self/environ",
                    "/proc/version",
                    "/proc/cmdline",
                    "/proc/cpuinfo",
                    "/proc/mounts",
                    "/proc/net/tcp",
                    "/proc/net/udp",
                    "/proc/net/raw",
                    "/proc/net/icmp",
                    "/proc/net/dev",
                    "/proc/net/route",
                    "/proc/net/if_inet6"
                };
                for (String file : sensitiveFiles) {
                    testFilePath(targetUrl + file);
                }

                // Provide recommendations to fix the vulnerability
                System.out.println("<p>To fix this vulnerability, ensure that file paths are properly validated and sanitized.</p>");
                System.out.println("</body>");
                System.out.println("</html>");
            } else {
                // No vulnerability found
                System.out.println("<html>");
                System.out.println("<body>");
                System.out.println("<h1 style=\"color:green;\">No Insecure File Handling vulnerability found on: " + targetUrl + "</h1>");
                System.out.println("</body>");
                System.out.println("</html>");
            }

            // Close the connection
            connection.disconnect();

        } catch (MalformedURLException e) {
            System.out.println("Invalid URL: " + e.getMessage());
        } catch (IOException e) {
            System.out.println("Error testing vulnerability: " + e.getMessage());
        }
    }

    // Method to test if a file path exists
    public static void testFilePath(String filePath) {
        try {
            URL url = new URL(filePath);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                System.out.println("<p style=\"color:red;\">Vulnerable file found: <a href=\"" + filePath + "\">" + filePath + "</a></p>");
            }
            connection.disconnect();
        } catch (IOException e) {
            // File path does not exist
        }
    }
}
