const readline = require('readline');

// Color constants
const colors = {
  reset: "\x1b[0m",
  bright: "\x1b[1m",
  red: "\x1b[31m",
  green: "\x1b[32m",
  yellow: "\x1b[33m"
};

// Function to send HTTP request
async function sendRequest(url, method, headers, body) {
  try {
    // Simulate sending HTTP request (replace with actual fetch or HTTP client code)
    console.log(`${colors.green}Simulating sending request:${colors.reset}`, { url, method, headers, body });
    return { status: 200, statusText: 'OK' }; // Replace with actual response
  } catch (error) {
    console.error(`${colors.red}Error sending request:${colors.reset}`, error);
    return null;
  }
}

// Function to generate a random payload
function generateRandomPayload() {
  // Example: generate a random string of characters
  const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const length = 10;
  let payload = '';
  for (let i = 0; i < length; i++) {
    payload += characters.charAt(Math.floor(Math.random() * characters.length));
  }
  return payload;
}

// Function to check for cache-related headers in response
function hasCacheHeaders(response) {
  const cacheControlHeader = response.headers.get('cache-control');
  const pragmaHeader = response.headers.get('pragma');
  return (cacheControlHeader || pragmaHeader);
}

// Create readline interface
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Ask user for target website URL
rl.question('Enter your target website URL:', async (targetUrl) => {
  if (targetUrl) {
    // Prompt user to select HTTP method
    const method = await askQuestion('Enter HTTP method (GET, POST, etc.):') || 'GET';

    // Automatically detect cache-related headers
    const headers = {};

    // Generate a random payload
    const body = generateRandomPayload();

    // Number of request attempts
    const numAttempts = 3;

    // Send multiple requests
    for (let i = 0; i < numAttempts; i++) {
      await sendRequest(targetUrl, method.toUpperCase(), headers, body)
        .then(response => {
          if (response) {
            console.log(`${colors.green}Attempt ${i+1}:${colors.reset} ${colors.bright}Request sent successfully.${colors.reset} Response status: ${response.status} ${response.statusText}`);
            // Check if cache-related headers are present in the response
            if (hasCacheHeaders(response)) {
              console.log(`${colors.yellow}Cache-related headers detected. Potential for cache poisoning!${colors.reset}`);
            } else {
              console.log(`${colors.yellow}No cache-related headers detected.${colors.reset}`);
            }
          } else {
            console.error(`${colors.red}Attempt ${i+1}: Failed to send request.${colors.reset}`);
          }
        })
        .catch(error => {
          console.error(`${colors.red}Attempt ${i+1}: Error sending request:${colors.reset}`, error);
        });
    }
  } else {
    console.error(`${colors.red}Target website URL is required.${colors.reset}`);
  }
  rl.close();
});

// Function to ask a question via readline
function askQuestion(question) {
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      resolve(answer);
    });
  });
}
