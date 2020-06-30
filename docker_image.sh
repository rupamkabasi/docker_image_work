#!/bin/bash

#`docker search rupamkabasi |
#awk '/rupamkabasi/ {print $1}'` > repos.txt

docker search rupamkabasi | sed '/^$/d' |sed 1d | cut -d' ' -f 1 >repos.txt

rm -rf time.txt tag.txt repolist.txt
cat repos.txt | while read line
do
 echo "$line" >> repolist.txt
curl -u rupamkabasi:Rupam@2019 -s -S  "https://registry.hub.docker.com/v2/repositories/$line/tags/" | jq '."results"[]["last_updated"]'| sed -n 1p |  cut -d'"' -f 2| sed 's/T/ /g' | tr -d 'Z' >> time.txt
curl -u rupamkabasi:Rupam@2019 -s -S  "https://registry.hub.docker.com/v2/repositories/$line/tags/" | jq '."results"[]["name"]'| sed -n 1p |  cut -d'"' -f 2 >> tag.txt

done

latest_tag=`paste tag.txt time.txt repolist.txt | sort -r -k2,3| sed -n 1p | awk '{print $1}'`
latest_repo=`paste tag.txt time.txt repolist.txt | sort -r -k2,3| sed -n 1p | awk '{print $4}'`

echo pulling latest image $latest_repo:$latest_tag ....
docker pull $latest_repo:$latest_tag
docker tag $latest_repo:$latest_tag rupam12071993/image_push:$latest_tag
docker login --username rupam12071993 --password Rupam@2019
docker push rupam12071993/image_push:$latest_tag

