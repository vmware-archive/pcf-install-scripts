# Pivotal Cloud Foundry offline install scripts

This repo contains useful scripts for downloading files ready for an offline install.

## Usage

- Edit product.list and remove/add the slug (names) of the PivNet products you wish to download
- Login to PivNet
- Click on your user drop down menu and select Edit Profile
- Alongside where it says UAA API Token, click on Request New Refresh Token, and copy this token text to the clipboard
- Type in `export PIVNET_TOKEN=PASTECONTENTHERE` and hit enter
- Run `./fetchlist.sh` and watch all files download
- All files will be placed in to ./fetched, totalling around 40 GB by default (PAS+PKS+Redis+MySQL+RabbitMQ)

## Details

There are various useful scripts.

- getreleases.sh will connect to PivNet and download the latest product list and links and cache them in to products.json (a version of products.json is provided in case you forget to do this!)
- listreleases.sh will output a human friendly list of the contents of products.json
- searchreleases.sh redis will search the products list for a slug that matches 'redis' in its name. This will return 3 products. It is case sensitive
- fetchlist.sh will read the product.list file and call fetchtile.sh for the latest version of each product listed in it
- fetchtile.sh will download all files for a specified release version of the specified tile, ONLY if they do not exist on the file system. This also takes in to account partial failed downloads (so it's safe to resume any download job!)
- uploadtile.sh will upload and install a specified tile file in to the local opsman (assumes you're using opsman as a jumpbox)

## Copyright and license

All code is Apache-2.0 all rights reserved Pivotal 2019

## Support

This is not officially supported by Pivotal. Support is on a best efforts basis via the GitHub repository and Issues tracking for this repository.

