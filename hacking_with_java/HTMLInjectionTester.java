import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class HTMLInjectionTester {

    private static final int NUM_THREADS = 5; // Number of threads for asynchronous requests

    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));

        try {
            // Prompt the user to enter the target website URL
            System.out.print("Enter the target website URL: ");
            String websiteURL = reader.readLine().trim();

            // Validate URL format
            if (!isValidURL(websiteURL)) {
                System.out.println("Invalid URL format. Please enter a valid URL.");
                return;
            }

            // Perform injection test
            testForInjection(websiteURL);
        } catch (IOException e) {
            System.out.println("Error reading input: " + e.getMessage());
        } finally {
            // Close the reader
            try {
                if (reader != null) {
                    reader.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private static void testForInjection(String websiteURL) {
        // Injected script to test for vulnerability
        String injectedScript = "<script>alert('Vulnerable to HTML Injection!')</script>";

        // Create a thread pool for asynchronous requests
        ExecutorService executor = Executors.newFixedThreadPool(NUM_THREADS);

        try {
            // Create URL object
            URL url = new URL(websiteURL);

            // Make asynchronous requests to test for injection
            for (InjectionPoint injectionPoint : InjectionPoint.values()) {
                executor.submit(() -> {
                    try {
                        // Establish connection
                        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

                        // Set request method
                        connection.setRequestMethod(injectionPoint.getMethod());

                        // Get response code
                        int responseCode = connection.getResponseCode();

                        // Read response
                        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                        StringBuilder response = new StringBuilder();
                        String inputLine;

                        while ((inputLine = reader.readLine()) != null) {
                            response.append(inputLine);
                        }
                        reader.close();

                        // Check if injected script is present in the response
                        if (response.toString().contains(injectedScript)) {
                            System.out.println("Vulnerable to HTML Injection at " + injectionPoint.name());
                        }
                    } catch (IOException e) {
                        System.out.println("Error occurred while testing for injection at " + injectionPoint.name() + ": " + e.getMessage());
                    }
                });
            }
        } catch (IOException e) {
            System.out.println("Error occurred while creating URL connection: " + e.getMessage());
        } finally {
            // Shutdown the executor
            executor.shutdown();
        }
    }

    private static boolean isValidURL(String url) {
        // Regular expression for URL validation
        String regex = "^(http|https)://.*$";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(url);
        return matcher.matches();
    }

    // Enum to represent injection points
    enum InjectionPoint {
        GET("GET"),
        POST("POST");

        private final String method;

        InjectionPoint(String method) {
            this.method = method;
        }

        public String getMethod() {
            return method;
        }
    }
}
