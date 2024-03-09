const axios = require('axios');
const cheerio = require('cheerio');
const readline = require('readline');
const chalk = require('chalk');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.question(chalk.yellow('Enter your target website url: '), async (url) => {
  try {
    console.log(chalk.blue(`Spidering website: ${url}`));
    const response = await axios.get(url);
    const html = response.data;
    const $ = cheerio.load(html);

    // Collecting links
    const links = [];
    $('a').each((index, element) => {
      links.push($(element).attr('href'));
    });

    // Collecting input fields
    const inputFields = [];
    $('input').each((index, element) => {
      inputFields.push({
        name: $(element).attr('name'),
        type: $(element).attr('type'),
        value: $(element).attr('value')
      });
    });

    // Analyzing input fields for potential vulnerabilities
    console.log(chalk.green('\nLinks found:'));
    links.forEach(link => console.log(chalk.cyan(link)));

    console.log(chalk.green('\nInput fields found:'));
    inputFields.forEach(field => console.log(chalk.cyan(JSON.stringify(field))));

    inputFields.forEach(field => {
      if (field.type === 'text' || field.type === 'password') {
        console.log(chalk.yellow(`\nPotential vulnerability found in input field: ${field.name}`));
        console.log(chalk.red('Possible XSS injection point detected!'));
      }
    });

    console.log(chalk.blue('\nSpidering complete!'));

  } catch (error) {
    console.error(chalk.red(`Error occurred: ${error.message}`));
  }

  rl.close();
});
