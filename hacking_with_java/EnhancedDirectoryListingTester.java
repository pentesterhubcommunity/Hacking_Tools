import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class EnhancedDirectoryListingTester {

    // ANSI color codes
    private static final String ANSI_RESET = "\u001B[0m";
    private static final String ANSI_RED = "\u001B[31m";
    private static final String ANSI_GREEN = "\u001B[32m";

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.println("Enhanced Directory Listing Vulnerability Tester");
        System.out.print("Enter your target website URL: ");
        String targetUrl = scanner.nextLine();

        System.out.println("\nTesting for directory listing vulnerability on: " + targetUrl);

        // Create a list of user-agent strings to rotate
        List<String> userAgents = new ArrayList<>();
        userAgents.add("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36");
        userAgents.add("Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101 Firefox/98.0");

        ExecutorService executorService = Executors.newFixedThreadPool(userAgents.size());

        for (String userAgent : userAgents) {
            executorService.execute(() -> testDirectoryListing(targetUrl, userAgent));
        }

        executorService.shutdown();

        try {
            executorService.awaitTermination(Long.MAX_VALUE, TimeUnit.NANOSECONDS);
        } catch (InterruptedException e) {
            System.out.println("Error: " + e.getMessage());
        }

        scanner.close();
    }

    private static void testDirectoryListing(String targetUrl, String userAgent) {
        try {
            URL url = new URL(targetUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("User-Agent", userAgent);

            int responseCode = connection.getResponseCode();
            System.out.println(getColorizedString(userAgent + " | Response Code: " + responseCode, ANSI_RESET));

            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                String responseBody = response.toString();

                // Check if directory listing is present
                if (responseBody.contains("Index of /")) {
                    System.out.println(getColorizedString(userAgent + " | Directory listing vulnerability detected!", ANSI_RED));
                    System.out.println(getColorizedString("Here are the directories/files found:", ANSI_RED));

                    // Extract and print directory listings
                    String[] lines = responseBody.split("\n");
                    for (String line : lines) {
                        if (line.contains("<a href=") && line.contains("</a>")) {
                            String directory = line.split("\"")[1];
                            System.out.println(getColorizedString(directory, ANSI_RED));
                        }
                    }
                } else {
                    System.out.println(getColorizedString(userAgent + " | No directory listing vulnerability detected.", ANSI_GREEN));
                }
            } else {
                System.out.println(getColorizedString(userAgent + " | Failed to connect to the target website.", ANSI_RESET));
            }
        } catch (IOException e) {
            System.out.println(getColorizedString(userAgent + " | Error: " + e.getMessage(), ANSI_RESET));
        }
    }

    private static String getColorizedString(String message, String color) {
        return color + message + ANSI_RESET;
    }
}
