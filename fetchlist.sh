#!/bin/sh
for PRODUCT in $(cat product.list); do
  echo "Fetching $PRODUCT"
  PS=`RELONLY=true ./searchreleases.sh $PRODUCT `
  ./fetchtile.sh $PRODUCT $PS
done
echo "All downloads complete"
exit 0
