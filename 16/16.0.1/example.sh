#!/bin/bash
docker volume create asterisk
docker run -d --rm --name="Asterisk-16" --network="host" \
       -v asterisk:/opt/asterisk jrhavlik/asterisk:16.0.1