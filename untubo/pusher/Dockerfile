FROM node:boron

LABEL maintainer="salvatore.mazzarino@nearform.com"

RUN apt-get update && apt-get install -y libsasl2-dev

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json .
# For npm@5 or later, copy package-lock.json as well
# COPY package.json package-lock.json ./

RUN npm install

# Bundle app source
COPY . .

CMD [ "npm", "start" ]
