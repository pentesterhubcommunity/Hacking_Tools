const readline = require('readline');
const fetch = require('node-fetch');

async function collectParameters() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    // Prompt user for target website link
    rl.question("Enter your target website link: ", async (targetWebsite) => {
        try {
            // Fetch the target website
            const response = await fetch(targetWebsite);

            if (!response.ok) {
                throw new Error(`Failed to fetch ${targetWebsite}. Status: ${response.status}`);
            }

            // Extract query parameters from URL
            const url = new URL(targetWebsite);
            const queryParams = url.searchParams;

            // Display parameters
            console.log("Parameters from the target website:");
            queryParams.forEach((value, key) => {
                console.log(`${key}: ${value}`);
            });

            rl.close();
        } catch (error) {
            console.error("Error occurred:", error);
            rl.close();
        }
    });
}

// Call the function to start collecting parameters
collectParameters();
