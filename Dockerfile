FROM node:alpine
MAINTAINER "James Wernicke <wernicke@lanl.gov>"

# Set us up the environment
ARG hubot_name
ARG hubot_owner
ARG hubot_description
ARG hubot_adapter
ENV HUBOT_ADAPTER="${hubot_adapter}"
ARG hubot_packages
ARG hubot_port
EXPOSE ${hubot_port}
ARG http_proxy
ENV http_proxy="${http_proxy}"
ARG https_proxy
ENV https_proxy="${https_proxy}"

# Install dependencies
RUN apk update && apk upgrade && apk add redis
RUN rm -rf /var/cache/apk/*
RUN npm install -g coffeescript yo generator-hubot

# Create hubot user
RUN adduser -h /srv/hubot -s /bin/sh -S hubot
RUN chown $(whoami) /usr/local/lib/node_modules/
RUN chown $(whoami) /usr/local/bin/

# Switch over to our hubot environment
WORKDIR /srv/hubot
USER hubot

# Build hubot
RUN yo hubot --adapter="${hubot_adapter}" --name="${hubot_name}" --owner="${hubot_owner}" --description="${hubot_description}" --defaults

# Remove Heroku dependencies
RUN sed -i '/heroku/d' external-scripts.json
RUN sed -i '/heroku/d' package.json

RUN npm install
RUN npm install -S ${hubot_packages}

# Add scripts
ADD external-scripts.json .
RUN rm hubot-scripts.json
ADD scripts/* scripts/

# You might need to do some other custom things here to build your image.

####################################################
# Everything before this is part of the image build.
####################################################

# Run hubot
ENTRYPOINT ["sh", "-c", "bin/hubot", "-a", "$HUBOT_ADAPTER"]
