#!/bin/sh
set -ue

source .env
api="https://graph.facebook.com/v2.5"
auth="access_token=$ACCESS_TOKEN"
url="$api/$GROUP_ID/events?since=$(date +%s)&$auth"

mkdir -p _data
json="$(curl "$url")"
echo --- > _data/events.yml
printf '%s' "$json" | sed 's/\\\//\//g' >> _data/events.yml

# Download images
mkdir -p images/events
for id in $(printf '%s' "$json" | jq -r '.data[].id'); do
  url="$(printf '%s\n' "$api/$id/photos?$auth")"
  photo_id="$(curl -L "$url" | jq -r '.data[0].id')"
  curl -L "$api/$photo_id/picture?$auth" -o "images/events/$id.jpeg"
done
