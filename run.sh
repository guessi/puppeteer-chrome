#!/bin/bash

SCRIPT_NAME="${1:-demo.js}"

EXTRA_FLAGS=""
if [ -f "$(pwd)/env_file" ]; then
  EXTRA_FLAGS="--env-file="$(pwd)/env_file""
fi

docker run -i --init --rm --name puppeteer-chrome --cap-add=SYS_ADMIN ${EXTRA_FLAGS} \
  -v $(pwd)/output:/home/pptruser/output \
    guessi/puppeteer-chrome:latest \
      node -e "$(cat $(pwd)/scripts/${SCRIPT_NAME})"
