import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class OpenRedirectionTest {

    private static final int TIMEOUT = 5000; // Timeout in milliseconds
    private static final String ANSI_RESET = "\u001B[0m";
    private static final String ANSI_YELLOW = "\u001B[33m";
    private static final String ANSI_RED = "\u001B[31m";
    private static final String ANSI_GREEN = "\u001B[32m";

    private static boolean testOpenRedirection(String targetUrl) {
        try {
            URL url = new URL(targetUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setInstanceFollowRedirects(false); // Disable automatic redirection
            connection.setRequestMethod("GET");
            connection.setRequestProperty("User-Agent", "Mozilla/5.0"); // Set user-agent header
            connection.setConnectTimeout(TIMEOUT);
            connection.setReadTimeout(TIMEOUT);
            int responseCode = connection.getResponseCode();
            return responseCode >= 300 && responseCode < 400;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) {
        System.out.println("========================");
        System.out.println(ANSI_YELLOW + "Open Redirection Vulnerability Test" + ANSI_RESET);
        System.out.println("========================");

        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        try {
            System.out.print("Enter the URL to test for open redirection vulnerability: ");
            String targetUrl = reader.readLine();

            if (!targetUrl.startsWith("http://") && !targetUrl.startsWith("https://")) {
                targetUrl = "http://" + targetUrl; // Assume HTTP if not specified
            }

            boolean isVulnerable = testOpenRedirection(targetUrl);

            if (isVulnerable) {
                System.out.println(ANSI_RED + "The provided URL is vulnerable to open redirection." + ANSI_RESET);
            } else {
                System.out.println(ANSI_GREEN + "The provided URL is not vulnerable to open redirection." + ANSI_RESET);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
