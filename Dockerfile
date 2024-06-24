FROM public.ecr.aws/docker/library/node:20-bookworm-slim

# Please find the version information at link below:
# - https://github.com/puppeteer/puppeteer/releases
ENV PUPPETEER_VERSION 22.12.0

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer installs, work.
RUN apt update \
 && apt install --no-install-recommends -y \
      ca-certificates \
      curl \
 # https://www.google.com/linuxrepositories/
 && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | tee /etc/apt/trusted.gpg.d/google.asc \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/trusted.gpg.d/google.asc] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google.list \
 # dependencies
 && apt update \
 && apt install --no-install-recommends -y \
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
