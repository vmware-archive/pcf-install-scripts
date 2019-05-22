#!/bin/bash
PRODUCTS=`cat products.json`
for ID in $(echo $PRODUCTS | jq -r ".products[].id" ) ; do
  # get product name
  PINFO=`echo $PRODUCTS|jq -r ".products[] | select( (.id | tonumber) == $ID) | ."`
  #echo PINFO: $PINFO
  PNAME=`echo $PINFO|jq -r .name `
  SLUG=`echo $PINFO|jq -r .slug `

  echo $ID,$SLUG,$PNAME
done

