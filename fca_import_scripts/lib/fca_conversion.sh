#!/bin/bash

CR='\033[33;31m'
CG='\033[33;32m'
CC='\033[33;36m'
RC='\033[0m'

clear_data() {
  rm -rf ext sql
  mkdir sql ext
}

extract_archives() {
  echo -e "• ${CC}Extracting archives.${RC}"
  ls archives/*.zip | xargs -Ifile unzip file -d ext/ > /dev/null
}

convert_to_utf8() {
  echo -e "• ${CC}Converting to UTF8.${RC}"
  iconv -f ISO8859-1 -t UTF8 ext/indiv_apprvd2*.ext > ext/advisers-utf8.ext
  iconv -f ISO8859-1 -t UTF8 ext/firms2*.ext        > ext/firms-utf8.ext
  iconv -f ISO8859-1 -t UTF8 ext/firm_names2*.ext   > ext/subsidiaries-utf8.ext
}

convert_to_sql() {
  echo -e "• ${CC}Converting to SQL.${RC}"

  ruby lib/convert.rb ext/advisers-utf8.ext > sql/advisers.sql
  ruby lib/convert.rb ext/firms-utf8.ext > sql/firms.sql
  ruby lib/convert.rb ext/subsidiaries-utf8.ext > sql/subsidiaries.sql
}

write_batch_sql() {
  echo -e "• ${CC}Writing batch import to sql/all.sql${RC}"

  echo "\\set ECHO all"                                   > sql/all.sql
  echo "BEGIN;"                                           >> sql/all.sql
  echo "TRUNCATE lookup_firms;"                           >> sql/all.sql
  echo "TRUNCATE lookup_advisers;"                        >> sql/all.sql
  echo "TRUNCATE lookup_subsidiaries;"                    >> sql/all.sql
  cat sql/advisers.sql sql/firms.sql sql/subsidiaries.sql >> sql/all.sql
  echo "COMMIT;"                                          >> sql/all.sql
  echo "\\unset ECHO"                                     >> sql/all.sql
}

report_done() {
  echo -e "• ${CG}Done.${RC}"
}
