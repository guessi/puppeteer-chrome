'use strict';

const homedir = process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;
const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  const navigationPromise = page.waitForNavigation();

  // set resolution
  console.log("[Debug] setup browser resolution")
  await page.setViewport({ width: 800, height: 600 });

  // wait for the page load
  console.log("[Debug] launching https://www.google.com")
  await page.goto('https://www.google.com', { waitUntil: ['networkidle0', 'domcontentloaded'] });

  // wait for page load
  console.log("[Debug] wait for page load")
  await page.waitFor(3000);

  console.log("[Debug] taking screenshot")
  await page.screenshot({ path: homedir + '/output/screenshot.png', fullPage: true });
  console.log("[Debug] screenshot captured")

  // all done
  console.log("[Debug] exiting")
  await browser.close()
})();
