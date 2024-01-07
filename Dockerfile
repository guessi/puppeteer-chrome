FROM node:18-bullseye-slim

# Please find the version information at link below:
# - https://github.com/puppeteer/puppeteer/releases
ENV PUPPETEER_VERSION 21.7.0

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer installs, work.
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
      ca-certificates \
      curl \
      gnupg2 \
 && curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
      fonts-freefont-ttf \
      fonts-ipafont-gothic \
      fonts-kacst \
      fonts-thai-tlwg \
      fonts-wqy-zenhei \
      google-chrome-stable \
      libasound2 \
      libgconf-2-4 \
      libgtk2.0-0 \
      libnss3 \
      libxss1 \
      libxtst6 \
      xvfb \
 && rm -rf /var/lib/apt/lists/*

# Add user so we don't need --no-sandbox.
# Same layer as npm install to keep re-chowned files from using up several hundred MBs more space
RUN groupadd -r pptruser \
 && useradd -r -g pptruser -G audio,video pptruser \
 && mkdir -p /home/pptruser \
 && chown -R pptruser:pptruser /home/pptruser

# Run everything after as non-privileged user.
USER pptruser

# Specify WORKDIR
WORKDIR ["/home/pptruser"]

# Install puppeteer so it's available in the container.
RUN npm i puppeteer@${PUPPETEER_VERSION} puppeteer-extra puppeteer-extra-plugin-stealth
