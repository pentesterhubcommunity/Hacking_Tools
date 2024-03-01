import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class WebCacheDeceptionTester {
    private static final int NUM_REQUESTS = 10; // Number of concurrent requests to send
    private static final int TIMEOUT_SECONDS = 10; // Timeout for each request in seconds

    // ANSI color codes
    private static final String RESET = "\u001B[0m";
    private static final String RED = "\u001B[31m";
    private static final String GREEN = "\u001B[32m";
    private static final String YELLOW = "\u001B[33m";

    public static void main(String[] args) {
        // Ask for the target website URL
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Enter your target website URL: ");
        String targetUrl = "";
        try {
            targetUrl = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Test for Web Cache Deception
        testCacheDeception(targetUrl);
    }

    public static void testCacheDeception(String url) {
        ExecutorService executorService = Executors.newFixedThreadPool(NUM_REQUESTS);
        for (int i = 0; i < NUM_REQUESTS; i++) {
            executorService.submit(() -> {
                try {
                    // Craft a request with random headers
                    URL obj = new URL(url);
                    HttpURLConnection con = (HttpURLConnection) obj.openConnection();
                    con.setRequestMethod("GET");
                    con.setRequestProperty("Cache-Control", "no-cache");
                    con.setRequestProperty("User-Agent", getRandomUserAgent()); // Random User-Agent header
                    con.setRequestProperty("Accept-Language", getRandomLanguage()); // Random Accept-Language header

                    // Allow users to add custom headers (optional)
                    // con.setRequestProperty("Custom-Header", "Value");

                    // Set timeout
                    con.setConnectTimeout(TIMEOUT_SECONDS * 1000);
                    con.setReadTimeout(TIMEOUT_SECONDS * 1000);

                    // Send the request
                    int responseCode = con.getResponseCode();

                    // Read response headers
                    Map<String, String> responseHeaders = new HashMap<>();
                    con.getHeaderFields().forEach((key, value) -> {
                        if (key != null) {
                            StringBuilder headerValue = new StringBuilder();
                            for (String v : value) {
                                if (headerValue.length() > 0) {
                                    headerValue.append(", ");
                                }
                                headerValue.append(v);
                            }
                            responseHeaders.put(key, headerValue.toString());
                        }
                    });

                    // Read response body (optional for additional analysis)
                    // String responseBody = readResponseBody(con);

                    // Check response headers and body for caching indicators or sensitive information leakage

                    // Print response details
                    System.out.println("Response Code: " + colorizeStatusCode(responseCode));
                    System.out.println("Response Headers:");
                    responseHeaders.forEach((key, value) -> System.out.println(key + ": " + value));

                    // Check if caching was detected
                    // Add custom logic based on response headers and body

                } catch (IOException e) {
                    System.out.println(RED + "Error occurred: " + e.getMessage() + RESET);
                }
            });
        }

        // Shutdown executor service
        executorService.shutdown();
        try {
            executorService.awaitTermination(TIMEOUT_SECONDS * NUM_REQUESTS, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private static String getRandomUserAgent() {
        String[] userAgents = {
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36",
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36",
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.71 Safari/537.36",
                // Add more user agents as needed
        };
        Random random = new Random();
        return userAgents[random.nextInt(userAgents.length)];
    }

    private static String getRandomLanguage() {
        String[] languages = {"en-US", "en-GB", "fr-FR", "es-ES", "de-DE", "ja-JP"};
        Random random = new Random();
        return languages[random.nextInt(languages.length)];
    }

    // Method to read response body (optional for additional analysis)
    private static String readResponseBody(HttpURLConnection con) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
        StringBuilder responseBody = new StringBuilder();
        String inputLine;
        while ((inputLine = in.readLine()) != null) {
            responseBody.append(inputLine);
        }
        in.close();
        return responseBody.toString();
    }

    // Method to colorize response status code for better visibility
    private static String colorizeStatusCode(int statusCode) {
        if (statusCode >= 200 && statusCode < 300) {
            return GREEN + statusCode + RESET; // Success (2xx)
        } else if (statusCode >= 300 && statusCode < 400) {
            return YELLOW + statusCode + RESET; // Redirection (3xx)
        } else {
            return RED + statusCode + RESET; // Error (4xx, 5xx, etc.)
        }
    }
}
