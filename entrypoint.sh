#!/bin/sh

echo "certonly $DOMAINS --standalone --debug-challenges --agree-tos"
certbot certonly $DOMAINS --standalone --debug-challenges --agree-tos
