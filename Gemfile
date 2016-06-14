require "net/http"
require "json"
versions = JSON.parse Net::HTTP.get URI "https://pages.github.com/versions.json"

ruby versions["ruby"]
source "https://rubygems.org"

gem "github-pages", versions["github-pages"]
