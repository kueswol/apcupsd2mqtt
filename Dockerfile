FROM gregewing/apcupsd:latest

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends npm && \
	rm -rf /var/lib/apt/lists/*
RUN mkdir /apcupsd2mqtt
COPY ./src/ /apcupsd2mqtt
WORKDIR /apcupsd2mqtt
RUN npm config set registry http://registry.npmjs.org/ && \
    npm install -g && \
    npm prune --production
RUN chmod +x ./startapcupsd2mqtt.sh
CMD ./startapcupsd2mqtt.sh
