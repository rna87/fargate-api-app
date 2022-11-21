FROM --platform=linux/amd64 node:fermium-slim

ARG PORT
ENV PORT=$PORT

EXPOSE $PORT

ARG LASTCOMMIT
ENV LASTCOMMIT=$LASTCOMMIT

ARG URL
ENV URL=$URL

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY healthcheck.js healthcheck.js
COPY . .

HEALTHCHECK CMD healthcheck

CMD ["npm", "start"]
