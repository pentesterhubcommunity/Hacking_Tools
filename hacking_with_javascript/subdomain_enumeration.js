const dns = require('dns');
const readline = require('readline');
const chalk = require('chalk');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

function enumerateSubdomains(domain, recordTypes) {
    return new Promise((resolve, reject) => {
        const promises = recordTypes.map(recordType => {
            return new Promise((resolve, reject) => {
                dns.resolve(`${domain}`, recordType, (err, records) => {
                    if (err) {
                        // Ignore DNS resolution errors and continue with an empty array
                        resolve([]);
                    } else {
                        resolve(records);
                    }
                });
            });
        });

        Promise.all(promises)
            .then(results => {
                const subdomains = results.flat().filter((item, index, self) => self.indexOf(item) === index);
                resolve(subdomains);
            })
            .catch(reject);
    });
}

// Prompt user for target domain and record types
rl.question(chalk.yellow('Enter your target domain: '), (domain) => {
    rl.question(chalk.yellow('Enter DNS record types to query (comma-separated, e.g., A,CNAME): '), (recordTypesInput) => {
        const recordTypes = recordTypesInput.split(',').map(type => type.trim().toUpperCase());
        const startTime = Date.now();

        enumerateSubdomains(domain, recordTypes)
            .then(subdomains => {
                console.log(chalk.green(`\nSubdomains for ${domain}:`));
                subdomains.forEach(subdomain => console.log(chalk.cyan(subdomain)));
                const elapsedTime = (Date.now() - startTime) / 1000; // Convert to seconds
                console.log(chalk.green(`\nEnumeration completed in ${elapsedTime} seconds.\n`));
                rl.close();
            })
            .catch(err => {
                console.error(chalk.red(`\nError enumerating subdomains: ${err}\n`));
                rl.close();
            });
    });
});
