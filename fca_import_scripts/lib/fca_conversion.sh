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
  iconv -f ISO8859-1 -t UTF8 ext/indiv_apprvd2*.ext > ext/advisers-utf8.ext.tmp
  iconv -f ISO8859-1 -t UTF8 ext/firms2*.ext        > ext/firms-utf8.ext.tmp
  iconv -f ISO8859-1 -t UTF8 ext/firm_names2*.ext   > ext/subsidiaries-utf8.ext.tmp
}

repair_row() {
  cat | sed -E "s/\"(.*\".*)\"/\1/g" | sed -E "s/\"\"/\"/g" | sed -E "s/\"/\'/g"
}

report_broken_rows() {
  echo -e ""
  echo -e "${CC}Broken rows report:${RC}"
  echo -e ""

  echo -e "== ${CR}ADVISERS${RC} =="
  cat ext/advisers-utf8.ext.tmp     | grep \"
  echo -e "== ${CG}REPAIR PREVIEW${RC} =="
  cat ext/advisers-utf8.ext.tmp     | grep \" | repair_row | grep \'

  echo -e ""
  echo -e "== ${CR}FIRMS${RC} =="
  cat ext/firms-utf8.ext.tmp        | grep \"
  echo -e "== ${CG}REPAIR PREVIEW${RC} =="
  cat ext/firms-utf8.ext.tmp        | grep \" | repair_row | grep \'

  echo -e ""
  echo -e "== ${CR}SUBSIDIARIES${RC} =="
  cat ext/subsidiaries-utf8.ext.tmp | grep \"
  echo -e "== ${CG}REPAIR PREVIEW${RC} =="
  cat ext/subsidiaries-utf8.ext.tmp | grep \" | repair_row | grep \'
}

prompt_to_repair_broken_rows() {
  echo -e ""
  echo -en "${CC}Autorepair?${RC} [Y/n] "
  read -r response
  if [[ $response =~ ^([nN][oO]|[nN])$ ]]
  then
    drop_to_shell
  else
    repair_broken_rows
  fi
}

drop_to_shell() {
  # Move temp files to right location.
  mv ext/advisers-utf8.ext.tmp ext/advisers-utf8.ext
  mv ext/firms-utf8.ext.tmp ext/firms-utf8.ext
  mv ext/subsidiaries-utf8.ext.tmp ext/subsidiaries-utf8.ext

  echo -e "${CC}Dropping you to a shell to manually repair files."
  echo -e "They are ${RC}ext/advisers-utf8.ext"
  echo -e "         ext/firms-utf8.ext"
  echo -e "         ext/subsidiaries-utf8.ext"
  echo -e "When you're done, run exit to resume."

  `echo $SHELL`
}

repair_broken_rows() {
  echo -e "• ${CC}Repairing.${RC}"
  # Filter out broken rows
  cat ext/advisers-utf8.ext.tmp     | grep -v \" > ext/advisers-utf8.ext
  cat ext/firms-utf8.ext.tmp        | grep -v \" > ext/firms-utf8.ext
  cat ext/subsidiaries-utf8.ext.tmp | grep -v \" > ext/subsidiaries-utf8.ext

  cat ext/advisers-utf8.ext.tmp     | grep \" | repair_row >> ext/advisers-utf8.ext
  cat ext/firms-utf8.ext.tmp        | grep \" | repair_row >> ext/firms-utf8.ext
  cat ext/subsidiaries-utf8.ext.tmp | grep \" | repair_row >> ext/subsidiaries-utf8.ext
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
