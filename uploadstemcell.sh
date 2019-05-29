#!/bin/bash
echo $1 $2 $3
TOKEN=`curl -s -k -H 'Accept: application/json;charset=utf-8' -d 'grant_type=password' -d "username=$1" -d "password=$2" -u 'opsman:' https://localhost/uaa/oauth/token | jq -r .access_token`
echo $TOKEN
curl -vv -H "Authorization: bearer $TOKEN" -k -X POST https://localhost/api/stemcells -F "stemcell[file]=@$3" 

