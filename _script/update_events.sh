#!/bin/sh
set -ue

source .env
mkdir -p _data
echo "---" > _data/events.yml
curl "https://graph.facebook.com/$GROUP_ID/events?since=$(date +%s)&access_token=$ACCESS_TOKEN" | sed 's/\\\//\//g' >> _data/events.yml
