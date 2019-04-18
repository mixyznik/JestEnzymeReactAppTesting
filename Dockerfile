# Extending image
FROM node:carbon

ARG SMB_PASS
ARG SMB_USER

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install autoconf automake libtool nasm make pkg-config git apt-utils yarn
RUN npm install --global surge
RUN npm install -g heroku

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Versions
RUN npm -v
RUN node -v

# login to heroku
RUN heroku login -i > echo "$SMB_USER" > echo "$SMB_PASS"
# RUN echo "$SMB_USER"
# RUN echo "$SMB_PASS"


# Install app dependencies
COPY package.json /usr/src/app/
COPY yarn.lock /usr/src/app/

RUN npm install

# Bundle app source
COPY . /usr/src/app

# Port to listener
EXPOSE 3000

# Environment variables
ENV NODE_ENV production
ENV PORT 3000
ENV PUBLIC_PATH "/"

RUN npm run deploy > echo "$SMB_USER" > echo "$SMB_PASS"
# RUN echo "$SMB_USER"
# RUN echo "$SMB_PASS"
RUN surge

# Main command
CMD [ "npm", "run", "start" ]