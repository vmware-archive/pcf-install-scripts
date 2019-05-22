#!/bin/bash
PRODUCTS=`cat products.json`
MATCHES=`echo $PRODUCTS | jq -c " .products[] | select( .slug |contains(\"$1\")) | .id"`
#echo MATCHES: $MATCHES
if [ -z "$RELONLY" ]; then
  echo id,slug,name,latestreleaseid,releaseurl,latestproducturl
fi
for ID in $MATCHES; do
  PRODUCT=`echo $PRODUCTS|jq -c ".products[] | select((.id|tonumber) == $ID) |."`
  #echo PRODUCT: $PRODUCT
  ID=`echo $PRODUCT|jq -rc ".id"`
  SLUG=`echo $PRODUCT|jq -rc ".slug"`
  NAME=`echo $PRODUCT|jq -rc ".name"`
  RELS=`echo $PRODUCT|jq -rc "._links.releases.href"`
  RELOUT=`curl --silent "$RELS" -H "Accept: application/json"`
  RELID=`echo $RELOUT|jq -rc ".releases[0].id"`
  RELURL=`echo $RELOUT|jq -rc ".releases[0]._links.product_files.href"`
  #echo RELID: $RELID
  #echo RELOUT: $RELOUT
  #SLUG=`echo $PRODUCTS|jq -r ".products[] | select( .slug|contains(\"$1\")) |.slug"`
  #NAME=`echo $PRODUCTS|jq -r ".products[] | select( .slug|contains(\"$1\")) |.name"`
  if [ -n "$RELONLY" ]; then
    echo $RELID
  else
    echo $ID,$SLUG,$NAME,$RELID,$RELS,$RELURL
  fi
done
exit 0
