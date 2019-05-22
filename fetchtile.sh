#!/bin/bash
# Get your pivnet token by logging in to pivnet and saying 'generate a new refresh token'
PIVNETTOKEN=$PIVNET_TOKEN
if [ -z "$PIVNETTOKEN" ]; then
  echo "ERROR: You MUST export PIVNET_TOKEN=YOURTOKEN  to be your UAA refresh token for PivNet before proceeding"
  exit 1
fi
PRODUCTSLUG=$1
RELEASEID=$2
echo "  Downloading product $PRODUCTSLUG release $RELEASEID"
ACCESS_TOKEN=`curl --silent  -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization: Bearer $PIVNETTOKEN" -d "{\"refresh_token\": \"$PIVNETTOKEN\"}" -X POST https://network.pivotal.io/api/v2/authentication/access_tokens |jq -rc ".access_token" `
#echo TOKEN: $ACCESS_TOKEN

FILEJSON=`curl --silent  -H "Accept: application/json" https://network.pivotal.io/api/v2/products/$PRODUCTSLUG/releases/$RELEASEID/product_files `
#echo FILEJSON: $FILEJSON
EULA="https://network.pivotal.io/api/v2/products/$PRODUCTSLUG/releases/$RELEASEID/eula_acceptance" 
# Accept EULA first
ACCEPT=`curl --silent -L -H "Authorization: Bearer $ACCESS_TOKEN" -X POST $EULA `
for FILEID in $(echo $FILEJSON|jq -rc ".product_files[].id"); do
  FINFO=`echo $FILEJSON|jq -rc ".product_files[] | select((.id | tonumber) == $FILEID) | ."`
  #echo $FILEID = $FINFO
  DURL=`echo $FILEJSON|jq -rc ".product_files[] | select((.id | tonumber) == $FILEID) | ._links.download.href"`
  KEY=`echo $FILEJSON|jq -rc ".product_files[] | select((.id | tonumber) == $FILEID) | .aws_object_key"`
  #echo DURL: $DURL
  if [ -f "fetched/$KEY" ]; then
    echo "    Skipping file $FILEID as it's already downloaded ($KEY)"
  else
    mkdir -p fetched/$(dirname "$KEY")
    #$PRODUCTSLUG/$RELEASEID
    echo "    Fetching $PRODUCTSLUG release version $RELEASEID file $FILEID - $KEY ..."
    curl -L -H "Authorization: Bearer $ACCESS_TOKEN"  $DURL > "fetched/$KEY.tmp"
    mv "fetched/$KEY.tmp" fetched/$KEY
    echo "    Done."
  fi
done
echo "  Downloads complete for product $PRODUCTSLUG"
exit 0
