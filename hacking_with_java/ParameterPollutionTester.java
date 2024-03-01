import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class ParameterPollutionTester {
    public static void main(String[] args) {
        // Prompt the user to enter the target website URL
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Enter your target website link: ");
        String url = "";
        try {
            url = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        // Extract parameters from the URL
        Map<String, String> params = extractParameters(url);
        if (params.isEmpty()) {
            System.out.println("No parameters found in the URL.");
            return;
        }

        // Test parameter pollution
        testParameterPollution(url, params);
    }

    // Method to extract parameters from the URL
    private static Map<String, String> extractParameters(String url) {
        Map<String, String> params = new HashMap<>();
        String[] parts = url.split("\\?");
        if (parts.length > 1) {
            String query = parts[1];
            String[] pairs = query.split("&");
            for (String pair : pairs) {
                String[] keyValue = pair.split("=");
                if (keyValue.length == 2) {
                    params.put(keyValue[0], keyValue[1]);
                }
            }
        }
        return params;
    }

    // Method to test parameter pollution
    private static void testParameterPollution(String url, Map<String, String> params) {
        try {
            // Iterate through parameters
            for (Map.Entry<String, String> entry : params.entrySet()) {
                // Clone the parameters map and modify one parameter at a time
                Map<String, String> modifiedParams = new HashMap<>(params);
                modifiedParams.put(entry.getKey(), "modified_value");

                // Send the HTTP request with modified parameters
                sendRequest(url, modifiedParams);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Method to send HTTP request
    private static void sendRequest(String url, Map<String, String> params) throws IOException {
        URL urlObj = new URL(url);
        HttpURLConnection conn = (HttpURLConnection) urlObj.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);

        // Build the query string
        StringBuilder queryString = new StringBuilder();
        for (Map.Entry<String, String> entry : params.entrySet()) {
            if (queryString.length() > 0) {
                queryString.append("&");
            }
            queryString.append(entry.getKey()).append("=").append(entry.getValue());
        }

        // Write parameters to the connection output stream
        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = queryString.toString().getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        // Read the response
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "utf-8"))) {
            StringBuilder response = new StringBuilder();
            String responseLine = null;
            while ((responseLine = br.readLine()) != null) {
                response.append(responseLine.trim());
            }
            System.out.println("Response: " + response.toString());
        }

        // Close connection
        conn.disconnect();
    }
}
