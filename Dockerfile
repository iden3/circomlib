FROM node:11-alpine

WORKDIR /usr/src/app

RUN apk add --no-cache git python build-base

COPY package*.json ./
RUN npm ci

COPY . .

CMD [ "npm", "test" ]
