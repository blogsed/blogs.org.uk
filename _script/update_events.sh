#!/bin/sh
set -ue

source .env
url="https://graph.facebook.com/$GROUP_ID/events?since=$(date +%s)&access_token=$ACCESS_TOKEN"

mkdir -p _data
echo --- > _data/events.yml
curl "$url" | sed 's/\\\//\//g' >> _data/events.yml
