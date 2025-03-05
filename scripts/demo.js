'use strict';

const homedir = process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;
const puppeteer = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
puppeteer.use(StealthPlugin());

const target = 'https://pptr.dev/';
const options = {
  headless: true,
};

const viewport = {
    width: 1024,
    height: 768,
};

(async () => {
  const browser = await puppeteer.launch(options);
  const page = await browser.newPage();

  // set resolution
  console.debug("setup browser resolution")
  await page.setViewport(viewport);

  // wait for the page load
  console.debug("launching " + target)
  await page.goto(target, { waitUntil: ['networkidle0', 'domcontentloaded'] });

  // wait for page load
  console.debug("wait for page load")
  await page.waitForTimeout(3000);

  console.debug("taking screenshot")
  await page.screenshot({ path: homedir + '/output/screenshot.png', fullPage: true });
  console.debug("screenshot captured")

  // all done
  console.debug("exiting")
  await browser.close()
})();
