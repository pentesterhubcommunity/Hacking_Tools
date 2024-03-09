// Function to test for Custom Header Vulnerabilities
async function testCustomHeaderVulnerabilities(targetUrl) {
    const headers = new Headers();
    headers.append('X-Test-Header', 'test');

    const requestOptions = {
        method: 'GET',
        headers: headers,
        redirect: 'follow'
    };

    console.log(`Testing for Custom Header Vulnerabilities on: ${targetUrl}`);

    try {
        const response = await fetch(targetUrl, requestOptions);
        const responseData = await response.text();

        console.log(`Response Status: ${response.status}`);
        if (response.status === 200 && responseData.includes('X-Test-Header')) {
            console.log('\x1b[32m', 'Target website is vulnerable to Custom Header Vulnerabilities.');
            console.log('\x1b[0m', 'To test the vulnerability, try accessing the target website with a custom header.');
        } else {
            console.log('\x1b[31m', 'Target website is not vulnerable to Custom Header Vulnerabilities.');
            console.log('\x1b[0m', 'The website did not return the custom header in the response.');
        }
    } catch (error) {
        console.error('Error:', error);
    }
}

// Function to get user input for target website URL
function getTargetUrl() {
    const readline = require('readline').createInterface({
        input: process.stdin,
        output: process.stdout
    });

    return new Promise((resolve) => {
        readline.question('Enter your target website url: ', (url) => {
            resolve(url);
            readline.close();
        });
    });
}

// Main function
async function main() {
    const targetUrl = await getTargetUrl();
    await testCustomHeaderVulnerabilities(targetUrl);
}

// Run the main function
main();
