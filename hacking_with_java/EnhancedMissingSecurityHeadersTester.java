import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class EnhancedMissingSecurityHeadersTester {
    public static void main(String[] args) {
        System.out.println("\033[0;33mMissing Security Headers Vulnerability Tester\033[0m");

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(System.in))) {
            List<String> targetUrls = new ArrayList<>();
            while (true) {
                System.out.print("Enter target website URL (type 'done' to finish): ");
                String input = reader.readLine().trim();
                if (input.equalsIgnoreCase("done")) {
                    break;
                }
                targetUrls.add(input);
            }

            if (targetUrls.isEmpty()) {
                System.out.println("No target URLs provided. Exiting...");
                return;
            }

            // Test for missing security headers concurrently
            testMissingSecurityHeadersConcurrently(targetUrls);
        } catch (IOException e) {
            System.err.println("Error reading input. Exiting...");
        }
    }

    private static void testMissingSecurityHeadersConcurrently(List<String> targetUrls) {
        ExecutorService executorService = Executors.newCachedThreadPool();
        List<CompletableFuture<Void>> futures = new ArrayList<>();

        for (String url : targetUrls) {
            CompletableFuture<Void> future = CompletableFuture.runAsync(() -> testMissingSecurityHeaders(url), executorService);
            futures.add(future);
        }

        CompletableFuture<Void> allOf = CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));
        try {
            allOf.get(); // Wait for all tasks to complete
        } catch (InterruptedException | ExecutionException e) {
            System.err.println("Error occurred while waiting for tasks to complete: " + e.getMessage());
        } finally {
            executorService.shutdown();
        }
    }

    private static void testMissingSecurityHeaders(String targetUrl) {
        try {
            URL url = new URL(targetUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("HEAD");

            int responseCode = connection.getResponseCode();
            System.out.printf("Testing %s ... Response Code: %d%n", targetUrl, responseCode);

            Map<String, List<String>> headers = connection.getHeaderFields();
            boolean missingSecurityHeaders = false;

            if (!headers.containsKey("X-Frame-Options")) {
                System.out.println("\033[0;31mMissing Security Header: X-Frame-Options\033[0m");
                missingSecurityHeaders = true;
            }
            if (!headers.containsKey("X-XSS-Protection")) {
                System.out.println("\033[0;31mMissing Security Header: X-XSS-Protection\033[0m");
                missingSecurityHeaders = true;
            }
            if (!headers.containsKey("Content-Security-Policy")) {
                System.out.println("\033[0;31mMissing Security Header: Content-Security-Policy\033[0m");
                missingSecurityHeaders = true;
            }

            if (!missingSecurityHeaders) {
                System.out.println("\033[0;32mNo missing security headers found. The website may be secure.\033[0m");
            }

            connection.disconnect();
        } catch (IOException e) {
            System.err.println("Error testing missing security headers for " + targetUrl + ": " + e.getMessage());
        }
    }
}
