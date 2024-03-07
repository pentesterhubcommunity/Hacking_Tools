import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class InformationDisclosureTester {

    // Colors for better visualization
    public static final String ANSI_RESET = "\u001B[0m";
    public static final String ANSI_RED = "\u001B[31m";
    public static final String ANSI_GREEN = "\u001B[32m";
    public static final String ANSI_CYAN = "\u001B[36m";

    public static void main(String[] args) {
        try {
            // Get the target website URL from the user
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
            System.out.print("Enter your target website URL: ");
            String targetUrl = reader.readLine();

            // Check for Information Disclosure vulnerability
            System.out.println(ANSI_CYAN + "Checking for Information Disclosure vulnerability..." + ANSI_RESET);
            checkForInformationDisclosure(targetUrl);
        } catch (IOException e) {
            System.err.println(ANSI_RED + "Error: " + e.getMessage() + ANSI_RESET);
        }
    }

    // Method to check for Information Disclosure vulnerability
    private static void checkForInformationDisclosure(String targetUrl) {
        try {
            // Array of sensitive endpoints to check
            String[] sensitiveEndpoints = {"robots.txt", ".git/config", ".svn/entries", ".DS_Store", "WEB-INF/web.xml", "phpinfo.php", "admin", "config.php", "login.php"};
            
            // Attempt to access sensitive endpoints
            for (String endpoint : sensitiveEndpoints) {
                String fullUrl = targetUrl + "/" + endpoint;
                HttpURLConnection connection = (HttpURLConnection) new URL(fullUrl).openConnection();
                connection.setRequestMethod("GET");
                int responseCode = connection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    System.out.println(ANSI_GREEN + "Vulnerability Found: " + fullUrl + " is accessible." + ANSI_RESET);
                    // Additional checks or actions can be performed here
                } else {
                    System.out.println(ANSI_RED + "Not Vulnerable: " + fullUrl + " is not accessible. Response code: " + responseCode + ANSI_RESET);
                }
            }
        } catch (IOException e) {
            System.err.println(ANSI_RED + "Error while checking for Information Disclosure vulnerability: " + e.getMessage() + ANSI_RESET);
        }
    }
}
