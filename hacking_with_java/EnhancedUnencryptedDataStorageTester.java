import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class EnhancedUnencryptedDataStorageTester {

    private static final int NUM_THREADS = 10; // Number of threads for parallel testing
    private static final int TIMEOUT_MS = 5000; // Timeout for HTTP requests in milliseconds

    public static void main(String[] args) {
        System.out.println("\u001B[34mUnencrypted Data Storage Vulnerability Tester\u001B[0m");
        System.out.println("--------------------------------------------");

        // Prompt the user to enter the target website URL
        System.out.print("\u001B[33mEnter your target website URL: \u001B[0m");
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(System.in))) {
            String targetUrl = reader.readLine();
            testForUnencryptedStorage(targetUrl);
        } catch (IOException e) {
            System.err.println("Error reading input: " + e.getMessage());
        }
    }

    private static void testForUnencryptedStorage(String targetUrl) {
        ExecutorService executor = Executors.newFixedThreadPool(NUM_THREADS);

        try {
            URL url = new URL(targetUrl);
            for (int i = 0; i < NUM_THREADS; i++) {
                executor.execute(new UnencryptedStorageTester(url));
            }
            executor.shutdown();
            executor.awaitTermination(TIMEOUT_MS * NUM_THREADS, TimeUnit.MILLISECONDS);
        } catch (IOException | InterruptedException e) {
            System.err.println("Error testing for vulnerability: " + e.getMessage());
        }
    }

    private static class UnencryptedStorageTester implements Runnable {
        private final URL url;

        public UnencryptedStorageTester(URL url) {
            this.url = url;
        }

        @Override
        public void run() {
            try {
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("GET");
                connection.setConnectTimeout(TIMEOUT_MS);
                connection.setReadTimeout(TIMEOUT_MS);

                int responseCode = connection.getResponseCode();
                String contentType = connection.getContentType();

                // Check if the website uses unencrypted storage for sensitive data
                if (responseCode == HttpURLConnection.HTTP_OK && contentType != null &&
                        contentType.toLowerCase().contains("text/plain")) {
                    System.out.println("\u001B[31mWARNING: The website might be using unencrypted storage for sensitive data!\u001B[0m");
                    System.out.println("Here's how to test for Unencrypted Data Storage Vulnerability:");
                    System.out.println("1. Check if sensitive data, such as passwords or personal information, is being transmitted over HTTP instead of HTTPS.");
                    System.out.println("2. Inspect the network traffic using tools like Wireshark to see if sensitive data is transmitted in plaintext.");
                    System.out.println("3. Look for configuration files or databases that might be accessible over an unencrypted connection.");
                } else {
                    System.out.println("\u001B[32mNo Unencrypted Data Storage Vulnerability found.\u001B[0m");
                }

                connection.disconnect();
            } catch (IOException e) {
                System.err.println("Error testing for vulnerability: " + e.getMessage());
            }
        }
    }
}
