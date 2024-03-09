// Importing necessary modules
const axios = require('axios');
const cheerio = require('cheerio');
const chalk = require('chalk');

// Function to test for CMS Information Disclosure Vulnerabilities
async function testCMSInfoDisclosureVulnerabilities(url) {
    console.log(chalk.yellow.bold('\nTesting for CMS Information Disclosure Vulnerabilities...\n'));

    try {
        // Fetching the website content
        const response = await axios.get(url);
        const html = response.data;

        // Parsing HTML using Cheerio
        const $ = cheerio.load(html);

        // Checking for common CMS identifiers in the HTML
        const cmsIdentifiers = ['WordPress', 'Joomla', 'Drupal', 'Magento', 'Shopify', 'TYPO3', 'Blogger', 'Wix', 'Squarespace', 'PrestaShop', 'Ghost', 'Bitrix', 'OpenCart', 'MODX', 'Umbraco', 'XenForo'];
        let foundCMS = false;

        cmsIdentifiers.forEach(cms => {
            if (html.includes(cms)) {
                console.log(chalk.green.bold(`[+] Potential CMS identified: ${cms}`));
                foundCMS = true;
            }
        });

        if (!foundCMS) {
            console.log(chalk.red.bold('[-] No common CMS identifiers found.'));
        }

    } catch (error) {
        console.error(chalk.red.bold(`Error fetching website: ${error.message}`));
    }
}

// Function to prompt user for target website URL
async function getTargetWebsite() {
    return new Promise((resolve, reject) => {
        const readline = require('readline').createInterface({
            input: process.stdin,
            output: process.stdout
        });

        readline.question(chalk.blue.bold('Enter your target website URL: '), (url) => {
            readline.close();
            resolve(url);
        });
    });
}

// Main function to orchestrate the testing process
async function main() {
    const targetWebsite = await getTargetWebsite();
    await testCMSInfoDisclosureVulnerabilities(targetWebsite);
}

// Calling the main function
main();
