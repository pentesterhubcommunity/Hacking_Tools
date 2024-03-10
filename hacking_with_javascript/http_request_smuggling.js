const https = require('https');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

rl.question("\x1b[33mEnter your target website url: \x1b[0m", (url) => {
  const request = https.request(url, { method: 'POST', headers: { 'Transfer-Encoding': 'chunked' } }, (res) => {
    console.log(`\x1b[36mStatus code: ${res.statusCode}\x1b[0m`);
    console.log('\x1b[36mHeaders:\x1b[0m');
    console.log(res.headers);
    console.log('\x1b[36mResponse body:\x1b[0m');
    res.on('data', (chunk) => {
      console.log(chunk.toString());
    });
  });

  request.on('error', (error) => {
    console.error('\x1b[31mError:\x1b[0m', error);
  });

  request.write('0\r\n\r\n');

  request.end();
});

rl.on('close', () => {
  console.log('\x1b[33mProgram closed.\x1b[0m');
});
