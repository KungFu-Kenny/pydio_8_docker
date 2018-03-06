#!/bin/bash

chemin=/etc/php/7.0/cli/php.ini

echo $chemin

sed -i -e "s/output_buffering\s*=\s*4096/output_buffering = Off/g" $chemin

sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 5G/g" $chemin

sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 6G/g" $chemin

sed -i -e "s/memory_limit\s*=\s*-1/memory_limit = 7G/g" $chemin

cat $chemin | grep -e "output_buffering = " -e upload_max_filesize -e post_max_size -e memory_limit
