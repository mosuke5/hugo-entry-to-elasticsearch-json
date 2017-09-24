#!/bin/bash
rm -rf ./site
git clone $1 site
bundle exec ruby main.rb site/content/entry/ > ./entries.json
