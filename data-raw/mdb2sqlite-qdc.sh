#!/bin/bash
# This script converts an mdb data file into
# csv files and imports those into a sqlite3 db

# Dependencies:
# sudo apt-get install mdbtools
# see: http://nialldonegan.me/2007/03/10/converting-microsoft-access-mdb-into-csv-or-mysql-in-linux/

echo "Unpacking original mdb db"
cp qcaf.mdb.gz.original qcaf.mdb.gz
gunzip qcaf.mdb.gz

t=$(mdb-tables qcaf.mdb)
echo "Exporting mdb tables $t"
for i in $t; do
  mdb-export -H -Q -d "|" qcaf.mdb $i > $i.csv
done

echo "Exporting mdb schema DDL as .sql"
mdb-schema qcaf.mdb mysql \
| sed "s/Int8/int/" \
| sed "s/Char /varchar/" \
| sed "s/text /varchar/" \
| grep -v "^COMMENT ON" \
| sed "s/^-/#/" > schema.sql

grep -v "#" schema.sql > test.db.schema.sql

echo "Importing mdb csv into sqlite3 test.db"
rm -f test.db
cat test.db.schema.sql | sqlite3 test.db
sqlite3 test.db ".separator |"
#sqlite3 test.db ".mode csv"
for i in $t; do
  sqlite3 test.db ".import $i.csv $i"
  rm $i.csv
done

echo "Done, cleaning up"
mv test.db qcaf.db
rm test.db.schema.sql schema.sql qcaf.mdb
