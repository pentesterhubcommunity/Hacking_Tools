import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class CMSInformationDisclosureTester {

    public static void main(String[] args) {
        System.out.println("\u001B[36mCMS Information Disclosure Vulnerability Tester\u001B[0m");
        System.out.print("\u001B[33mEnter your target website URL: \u001B[0m");

        try {
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
            String targetURL = reader.readLine();
            reader.close();

            System.out.println("\u001B[36mTesting for CMS Information Disclosure Vulnerability...\u001B[0m");
            testForVulnerability(targetURL);

        } catch (IOException e) {
            System.out.println("\u001B[31mAn error occurred while reading input: " + e.getMessage() + "\u001B[0m");
        }
    }

    private static void testForVulnerability(String targetURL) {
        try {
            URL url = new URL(targetURL);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.connect();

            String serverHeader = connection.getHeaderField("Server");
            if (serverHeader != null && !serverHeader.isEmpty()) {
                System.out.println("\u001B[31mThe website may be vulnerable to CMS Information Disclosure.\u001B[0m");
                System.out.println("\u001B[31mServer header information: " + serverHeader + "\u001B[0m");
                System.out.println("\u001B[34mTo test further, you can try accessing common CMS-specific paths such as /wp-admin for WordPress or /admin for Drupal.\u001B[0m");
            } else {
                System.out.println("\u001B[32mThe website does not seem to be vulnerable to CMS Information Disclosure.\u001B[0m");
            }

            connection.disconnect();
        } catch (IOException e) {
            System.out.println("\u001B[31mAn error occurred while testing for vulnerability: " + e.getMessage() + "\u001B[0m");
        }
    }
}
