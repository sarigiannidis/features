#! /usr/bin/env node

const puppeteer = require('puppeteer'); // https://pptr.dev/
const process = require('process');

// process.argv.forEach((val, index) => {
//   console.log(`argv[${index}]: ${val}`);
// });

if (!process.argv[2]) {
  console.log('Please provide a URL to screenshot');
  process.exit(1);
}
url = process.argv[2];

if (!process.argv[3]) {
  console.log('Please provide a filename to save the screenshot');
  process.exit(1);
}
output = process.argv[3];

const launchOptions = {
  executablePath: '/usr/bin/chromium-browser',
  args: [
    '--no-sandbox',
    '--disable-gpu'
  ]
};

const gotoOptions = {
  waitUntil: 'networkidle0'
};

(async () => {
    const browser = await puppeteer.launch(launchOptions);
    try{
      const page = await browser.newPage();
      await page.goto(url, gotoOptions);
      await page.screenshot({
        path: output,
        fullPage: true
      });
    } finally {
    await browser.close();
    }
})();