import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DataLeakageTester {

    public static void main(String[] args) {
        // Prompt the user to enter the target website URL
        System.out.print("\033[0;34mEnter your target website URL: \033[0m");
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String targetUrl = "";
        try {
            targetUrl = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Test for data leakage vulnerabilities
        testDataLeakage(targetUrl);
    }

    private static void testDataLeakage(String targetUrl) {
        try {
            // Open a connection to the target URL
            URL url = new URL(targetUrl);
            URLConnection connection = url.openConnection();

            // Read response from the server
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line).append("\n");
            }
            reader.close();

            // Check for sensitive information in the response
            String responseData = content.toString();
            boolean hasLeakage = checkForLeakage(responseData);

            // Display results
            if (hasLeakage) {
                System.out.println("\033[0;31mPotential data leakage vulnerability detected!\033[0m");
                System.out.println("Sensitive information such as passwords, credit card numbers, social security numbers, email addresses, or personal identification numbers may be exposed.");
                System.out.println("Please review the website's code and remove any instances of sensitive data exposure.");
                System.out.println("Consider implementing proper access controls and encryption for sensitive data.");
            } else {
                System.out.println("\033[0;32mNo data leakage vulnerability detected.\033[0m");
            }
        } catch (IOException e) {
            System.err.println("\033[0;31mError: Unable to connect to the target website.\033[0m");
            e.printStackTrace();
        }
    }

    private static boolean checkForLeakage(String responseData) {
        // Regular expressions to search for sensitive data patterns
        Pattern passwordPattern = Pattern.compile("password", Pattern.CASE_INSENSITIVE);
        Pattern creditCardPattern = Pattern.compile("\\b(?:\\d[ -]*?){13,16}\\b");
        Pattern ssnPattern = Pattern.compile("\\b\\d{3}-\\d{2}-\\d{4}\\b");
        Pattern emailPattern = Pattern.compile("\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}\\b");
        Pattern pinPattern = Pattern.compile("\\b\\d{4}\\b");

        // Match patterns in the response data
        Matcher passwordMatcher = passwordPattern.matcher(responseData);
        Matcher creditCardMatcher = creditCardPattern.matcher(responseData);
        Matcher ssnMatcher = ssnPattern.matcher(responseData);
        Matcher emailMatcher = emailPattern.matcher(responseData);
        Matcher pinMatcher = pinPattern.matcher(responseData);

        // Check if sensitive data is found
        return passwordMatcher.find() || creditCardMatcher.find() || ssnMatcher.find() || emailMatcher.find() || pinMatcher.find();
    }
}
