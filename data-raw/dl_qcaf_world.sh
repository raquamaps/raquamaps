#!/bin/bash

# Adding ?dl=1 to Kathy's dropbox link in accordance with ...
# https://superuser.com/questions/470664/how-to-download-dropbox-files-using-wget-command
wget -O qcaf.zip "https://www.dropbox.com/sh/u4ipvf1tfo4izhq/AACVIxriWFkMfoliMtIyRUDPa?dl=1"

echo "Recompressing"
unzip QCAF.zip
gzip QCAF.mdb
mv QCAF.mdb.gz qcaf.mdb.gz.original
rm QCAF.zip
