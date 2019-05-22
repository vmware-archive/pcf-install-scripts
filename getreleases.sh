#!/bin/sh
curl --silent https://network.pivotal.io/api/v2/products -H "Accept: application/json" > products.json
echo "Products outputted to products.json. Now run list/search releases commands"
exit 0
