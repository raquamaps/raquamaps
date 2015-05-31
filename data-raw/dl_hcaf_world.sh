#!/bin/bash

# Adding ?dl=1 to Kathy's dropbox link in accordance with ...
# https://superuser.com/questions/470664/how-to-download-dropbox-files-using-wget-command
wget -O hcaf.zip "https://www.dropbox.com/s/eaypumtswp3plro/HCAF_fw_AquaMaps.zip?dl=1"

echo "Recompressing"
unzip hcaf.zip
gzip HCAF_fw_AquaMaps.mdb
mv HCAF_fw_AquaMaps.mdb.gz hcaf.mdb.gz.original
rm hcaf.zip
