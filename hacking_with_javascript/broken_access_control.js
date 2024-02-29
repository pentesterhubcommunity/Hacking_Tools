const readline = require('readline');
const { execSync } = require('child_process');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Function to gracefully exit the program
function exitProgram() {
  console.log("Exiting the program...");
  rl.close();
  process.exit(0);
}

// Listen for the SIGINT signal (Ctrl + C)
process.on('SIGINT', exitProgram);

// Prompt user for target URL
rl.question("Enter your target URL: ", (targetUrl) => {
  console.log(`Running tests on ${targetUrl} ...`);

  // Define test commands
  const testCommands = [
    `curl -s -o /dev/null -w '%{http_code}' ${targetUrl}`,
    // Add more test commands as needed
  ];

  // Iterate through each test command
  console.log("Performing tests...");
  testCommands.forEach(command => {
    try {
      const result = execSync(`${command}`).toString();
      console.log(`Command: ${command}\nResult: ${result}\n`);
    } catch (error) {
      console.error(`Error executing command: ${command}\n${error}`);
    }
  });

  console.log("Tests completed.");
  rl.close();
});
