const fetch = require('node-fetch');
const colors = require('colors');

// Function to test CSP bypass
async function testCSPBypass(targetUrl) {
    try {
        // Fetch the target website
        const response = await fetch(targetUrl);
        const headers = response.headers;

        // Check if CSP header exists
        if (headers.has('content-security-policy')) {
            const cspHeader = headers.get('content-security-policy');

            // Check if 'unsafe-inline' is present in CSP header
            if (cspHeader.includes('unsafe-inline')) {
                console.log(colors.green("The website's CSP is vulnerable to 'unsafe-inline' bypass."));
                console.log("Here's how to test the vulnerability:");
                console.log(colors.yellow("1. Inspect the website's source code for inline scripts or styles."));
                console.log(colors.yellow("2. Inject a malicious script or style using the 'unsafe-inline' directive to see if it executes."));
            } else {
                console.log(colors.red("The website's CSP is not vulnerable to 'unsafe-inline' bypass."));
            }
        } else {
            console.log(colors.red("The website does not have a Content Security Policy (CSP) set."));
        }
    } catch (error) {
        console.error(colors.red("An error occurred while fetching the website:"), error);
    }
}

// Main function
async function main() {
    console.log(colors.cyan("Welcome to the CSP Bypass Vulnerability Tester!"));

    // Get target website URL from user input
    console.log(colors.cyan("Enter your target website URL: "));
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', async function(data) {
        const targetUrl = data.trim();

        if (!targetUrl) {
            console.error(colors.red("Please provide a valid URL."));
            process.exit(1);
        }

        console.log(colors.yellow("Testing for CSP bypass vulnerability..."));
        await testCSPBypass(targetUrl);

        process.exit(0);
    });
}

// Execute main function
main();
