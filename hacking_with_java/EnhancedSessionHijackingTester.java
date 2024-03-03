import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class EnhancedSessionHijackingTester {
    public static void main(String[] args) {
        System.out.println("\u001B[1mEnhanced Session Hijacking Vulnerability Tester\u001B[0m");
        System.out.println("-------------------------------");

        // Prompt user for target website URL
        String targetUrl = promptUser("Enter your target website URL: ");

        // Number of threads to simulate concurrent requests
        int numThreads = 10; // Adjust as needed

        ExecutorService executorService = Executors.newFixedThreadPool(numThreads);

        for (int i = 0; i < numThreads; i++) {
            executorService.submit(() -> {
                testSessionHijacking(targetUrl);
            });
        }

        executorService.shutdown();
    }

    private static void testSessionHijacking(String targetUrl) {
        try {
            URL url = new URL(targetUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");

            // Customize headers if needed
            // connection.setRequestProperty("User-Agent", "Mozilla/5.0");

            // Extract session cookies from the response headers
            String sessionCookie = connection.getHeaderField("Set-Cookie");
            System.out.println("Session Cookie: " + sessionCookie);

            // Read and analyze the response body if necessary
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String line;
            StringBuilder responseBody = new StringBuilder();
            while ((line = reader.readLine()) != null) {
                responseBody.append(line);
            }
            // Analyze responseBody for session-related information

            // Close resources
            reader.close();
            connection.disconnect();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String promptUser(String message) {
        System.out.print(message);
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        try {
            return reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
