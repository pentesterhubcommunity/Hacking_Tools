import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

public class GoogleDorking {

    // Function to perform Google dorking for the target domain
    public static void performDorking(String targetDomain, List<String> queries) {
        try {
            for (String query : queries) {
                // Encode the query
                String encodedQuery = URLEncoder.encode(query.replace("{target_domain}", targetDomain), "UTF-8");

                // Construct the Google search URL
                String url = "https://www.google.com/search?q=" + encodedQuery;

                // Open Google Chrome with the dorking query
                String[] command = {"google-chrome", url};
                Process process = Runtime.getRuntime().exec(command);
                System.out.println("Opening Google Chrome with the dork query: " + query);

                // Wait for the command to finish
                process.waitFor();
            }
            System.out.println("All dorking queries for " + targetDomain + " have been executed. Close the tabs when you're done viewing the results.");
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        // List to store dork queries
        List<String> queries = new ArrayList<>();
        queries.add("site:{target_domain} inurl:login");
        queries.add("site:{target_domain} intitle:index.of");
        queries.add("site:{target_domain} intext:password");
        queries.add("site:{target_domain} filetype:pdf");
        queries.add("site:{target_domain} inurl:admin");
        queries.add("site:{target_domain} intitle:admin");
        queries.add("site:{target_domain} intitle:dashboard");
        queries.add("site:{target_domain} intitle:config OR site:{target_domain} intitle:configuration");
        queries.add("site:{target_domain} intitle:setup");
        queries.add("site:{target_domain} intitle:phpinfo");
        queries.add("site:{target_domain} inurl:wp-admin");
        queries.add("site:{target_domain} inurl:wp-content");
        queries.add("site:{target_domain} inurl:wp-includes");
        queries.add("site:{target_domain} inurl:wp-login");
        queries.add("site:{target_domain} inurl:wp-config");
        queries.add("site:{target_domain} inurl:wp-config.txt");
        queries.add("site:{target_domain} inurl:wp-config.php");
        queries.add("site:{target_domain} inurl:wp-config.php.bak");
        queries.add("site:{target_domain} inurl:wp-config.php.old");
        queries.add("site:{target_domain} inurl:wp-config.php.save");
        // Additional queries
        queries.add("site:{target_domain} inurl:config.php");
        queries.add("site:{target_domain} inurl:config.bak");
        queries.add("site:{target_domain} inurl:config.old");
        queries.add("site:{target_domain} inurl:config.txt");
        queries.add("site:{target_domain} inurl:config.save");
        queries.add("site:{target_domain} inurl:config.swp");
        queries.add("site:{target_domain} inurl:config.php.swp");
        queries.add("site:{target_domain} inurl:config.php~");
        queries.add("site:{target_domain} inurl:config.php.old");
        queries.add("site:{target_domain} inurl:config.php.save");
        queries.add("site:{target_domain} inurl:config.php.bak");
        // Additional queries
        queries.add("site:{target_domain} inurl:backup.zip");
        queries.add("site:{target_domain} inurl:backup.tgz");
        queries.add("site:{target_domain} inurl:backup.tar.gz");
        queries.add("site:{target_domain} inurl:backup.rar");
        queries.add("site:{target_domain} inurl:backup.sql");
        queries.add("site:{target_domain} inurl:backup.tar");
        queries.add("site:{target_domain} inurl:backup.7z");
        queries.add("site:{target_domain} inurl:backup.bak");
        queries.add("site:{target_domain} inurl:backup.old");
        queries.add("site:{target_domain} inurl:backup.db");
        // Add more queries here...

        // Prompt for target domain
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.print("Enter your target domain (e.g., example.com): ");
        String targetDomain = "";
        try {
            targetDomain = reader.readLine().trim();
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Loop through each 3 dorking queries
        for (int i = 0; i < queries.size(); i += 3) {
            // Prompt for confirmation before running the next 3 commands
            System.out.print("Press [Enter] to run the next 3 commands (or type 'quit' to exit): ");
            String choice = "";
            try {
                choice = reader.readLine().trim();
            } catch (IOException e) {
                e.printStackTrace();
            }
            if ("quit".equals(choice)) {
                System.out.println("Exiting...");
                break;
            }

            // Extract 3 queries to run
            int end = Math.min(i + 3, queries.size());
            List<String> queriesToRun = queries.subList(i, end);

            // Perform dorking for the target domain
            performDorking(targetDomain, queriesToRun);
        }
    }
}
