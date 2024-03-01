const https = require('https');
const url = require('url');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Function to make a request to the provided URL
function makeRequest(targetUrl, callback) {
    const options = new URL(targetUrl);

    const req = https.get(options, (res) => {
        let data = '';

        res.on('data', (chunk) => {
            data += chunk;
        });

        res.on('end', () => {
            callback(null, res.statusCode, data);
        });
    });

    req.on('error', (err) => {
        callback(err);
    });
}

// Test function to check for SSRF vulnerability
function testSSRF(targetUrl) {
    makeRequest(targetUrl, (err, statusCode, data) => {
        if (err) {
            console.error('Error occurred:', err);
            rl.close();
            return;
        }

        console.log('Response Status Code:', statusCode);
        console.log('Response Body:', data);
        rl.close();
    });
}

// Prompt user for target website URL
rl.question('Enter your target website URL: ', (answer) => {
    const targetUrl = answer.trim();
    testSSRF(targetUrl);
});
