#!/bin/bash

docker search rupamkabasi | awk '/rupamkabasi/ {print $1}' > repos.txt
while read repo; do
  echo "$repos"
  `curl -u rupamkabasi:Rupam@2019 -s -S  "https://registry.hub.docker.com/v2/repositories/$repos/tags/" | jq '."results"[]["last_updated"]'`

done <repos.txt
