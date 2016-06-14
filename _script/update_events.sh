#!/bin/sh
set -ue

[ -f .env ] && . "$PWD/.env"
api="https://graph.facebook.com/v2.5"
auth="access_token=$ACCESS_TOKEN"

json=""

mkdir -p _data/events

get_events() {
  url="$api/$1/events?since=$(date +%s)&$auth"
  json="$json$(curl "$url"; echo)"
  # convert to yaml
  printf -- '---\n%s' "$json" | sed 's/\\\//\//g'
}

get_events "$PAGE_ID" > _data/events/page.yml
get_events "$GROUP_ID" > _data/events/group.yml

# Download images
mkdir -p images/events
for id in $(printf '%s' "$json" | jq -r '.data[].id'); do
  url="$(printf '%s\n' "$api/$id/photos?$auth")"
  photo_id="$(curl -L "$url" | jq -r '.data[0].id')"
  curl -L "$api/$photo_id/picture?$auth" -o "images/events/$id.jpeg"
done
