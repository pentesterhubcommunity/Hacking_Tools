const fetch = require('node-fetch');

// Cache object to store responses for caching
const cache = {};

// Function to test for Missing Security Headers vulnerability
async function testSecurityHeaders(url) {
    try {
        // Check if response is cached
        if (cache[url]) {
            console.log("\x1b[36m%s\x1b[0m", `Testing Security Headers for: ${url} (cached)\n`);
            return analyzeHeaders(cache[url]);
        }

        // Set custom User-Agent header
        const headers = { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36' };

        const response = await fetch(url, { headers, timeout: 5000 }); // Timeout set to 5 seconds
        const headersObj = Object.fromEntries(response.headers.entries());
        
        // Cache the response
        cache[url] = headersObj;

        console.log("\x1b[36m%s\x1b[0m", `Testing Security Headers for: ${url}\n`);
        analyzeHeaders(headersObj);
    } catch (error) {
        console.error("\x1b[31m%s\x1b[0m", "Error occurred:", error.message);
    }
}

// Function to analyze security headers
function analyzeHeaders(headers) {
    const missingHeaders = [];

    securityHeaders.forEach(header => {
        if (!headers[header.name.toLowerCase()]) {
            missingHeaders.push(header);
        }
    });

    if (missingHeaders.length > 0) {
        console.log("\x1b[31m%s\x1b[0m", "Missing Security Headers:\n");
        missingHeaders.forEach(header => {
            console.log("\x1b[31m%s\x1b[0m", `${header.name} - ${header.description}`);
        });
        console.log("\n\x1b[32m%s\x1b[0m", "How to exploit this vulnerability:");
        console.log("\x1b[32m%s\x1b[0m", "An attacker can exploit these missing security headers to perform various attacks such as clickjacking, cross-site scripting (XSS), or man-in-the-middle (MITM) attacks.");
    } else {
        console.log("\x1b[32m%s\x1b[0m", "No Missing Security Headers found. This website is secure.");
    }
}

// Main function to get user input and start the test
async function main() {
    const readline = require('readline').createInterface({
        input: process.stdin,
        output: process.stdout
    });

    readline.question("\x1b[36m%s\x1b[0m", "Enter your target website URL: ", async (url) => {
        await testSecurityHeaders(url);
        readline.close();
    });
}

// Start the program
main();
