import java.util.Scanner; // Import Scanner from java.util
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.BufferedReader;
import java.io.InputStreamReader;

public class BrokenAccessControlTester {
    public static void main(String[] args) {
        // Prompt the user to enter the target website URL
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter your target website URL: ");
        String targetUrl = scanner.nextLine();
        
        // Define the HTTP methods to test
        String[] httpMethods = {"GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS"};
        
        try {
            // Create a URL object
            URL url = new URL(targetUrl);
            
            // Iterate over each HTTP method
            for (String method : httpMethods) {
                // Open a connection to the URL
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                
                // Set the request method
                connection.setRequestMethod(method);
                
                // Send the request
                int responseCode = connection.getResponseCode();
                
                // Read the response from the server
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String line;
                StringBuilder response = new StringBuilder();
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                
                // Check if the response indicates successful access
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    System.out.println("Access to the restricted page with " + method + " request was successful!");
                    System.out.println("Response:");
                    System.out.println(response.toString());
                } else {
                    System.out.println("Access to the restricted page with " + method + " request was denied (HTTP response code: " + responseCode + ")");
                }
                
                // Close the connection
                connection.disconnect();
            }
        } catch (Exception e) {
            System.err.println("An error occurred: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
