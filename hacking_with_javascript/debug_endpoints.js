const axios = require('axios');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function testDebugEndpoints(url) {
  console.log(`Testing ${url} for exposed debug endpoints...`);
  axios.get(url)
    .then(response => {
      const debugEndpoints = findDebugEndpoints(response.data);
      if (debugEndpoints.length > 0) {
        console.log(`Debug endpoints found: ${debugEndpoints.join(', ')}`);
        console.log(`The target ${url} is vulnerable.`);
        console.log('To test the vulnerability, try accessing these debug endpoints in your browser or through a tool like curl or Postman.');
      } else {
        console.log('No exposed debug endpoints found.');
        console.log(`The target ${url} is not vulnerable.`);
      }
    })
    .catch(error => {
      console.error('An error occurred while testing for debug endpoints:', error.message);
    });
}

function findDebugEndpoints(html) {
  // Expanded regex pattern to find common debug endpoints
  const regex = /\/debug|\/test|\/dev|\/logs|\/admin|\/info|\/trace|\/metrics|\/monitor|\/status/i;
  const matches = html.match(regex);
  return matches ? matches : [];
}

rl.question('Enter your target website URL: ', (url) => {
  testDebugEndpoints(url);
  rl.close();
});
