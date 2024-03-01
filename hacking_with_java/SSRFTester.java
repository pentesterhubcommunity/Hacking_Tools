import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class SSRFTester {

    public static void main(String[] args) {
        try {
            // Prompt the user to enter the target website URL
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
            System.out.print("Enter your target website URL: ");
            String urlToTest = reader.readLine();

            // Create a URL object
            URL url = new URL(urlToTest);

            // Open a connection to the URL
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            // Set request method
            connection.setRequestMethod("GET");

            // Follow redirects
            connection.setInstanceFollowRedirects(true);

            // Set timeout (10 seconds)
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(10000);

            // Send the request
            int responseCode = connection.getResponseCode();
            System.out.println("Response Code: " + responseCode);

            // Get final URL after redirection
            URL finalUrl = connection.getURL();
            System.out.println("Final URL: " + finalUrl);

            // Read response
            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // Process the response as needed
            System.out.println("Response Content:");
            System.out.println(response.toString());

            // Close the connection
            connection.disconnect();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
