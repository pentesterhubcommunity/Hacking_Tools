const readline = require('readline');
const https = require('https');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.question('Enter your target website link: ', (targetUrl) => {
  const redirectUrl = "https://www.bbc.com";

  // Send a request with the redirection URL
  https.get(targetUrl + "?redirect=" + redirectUrl, (res) => {
    let status_code = res.statusCode;
    let effective_url = res.headers.location;

    // Check if the response status code indicates a successful redirection
    if (status_code >= 300 && status_code < 400 && effective_url === redirectUrl) {
      console.log("\x1b[32mVulnerable: Open Redirection exists\x1b[0m");
    } else if (status_code >= 300 && status_code < 400) {
      console.log("\x1b[31mPotentially Vulnerable: Redirection occurred but not to the specified URL\x1b[0m");
    } else if (status_code < 200 || status_code >= 400) {
      console.log("\x1b[31mNot Vulnerable: HTTP request failed with status code " + status_code + "\x1b[0m");
    } else {
      console.log("\x1b[31mNot Vulnerable: Redirection did not occur\x1b[0m");
    }
  }).on('error', (e) => {
    console.error("\x1b[31mError: " + e.message + "\x1b[0m");
  });

  rl.close();
});
