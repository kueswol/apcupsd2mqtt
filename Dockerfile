FROM gregewing/apcupsd:latest

RUN apt-get -y update
RUN apt-get -y install npm
RUN mkdir /apcupsd2mqtt
COPY ./ /apcupsd2mqtt
WORKDIR /apcupsd2mqtt
RUN npm install -g
RUN chmod +x ./startapcupsd2mqtt.sh
CMD ./startapcupsd2mqtt.sh
