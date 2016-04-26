#!/bin/bash

set -e

source 'lib/fca_conversion.sh'

clear_data
warn_if_no incoming "Expecting to find FCA files in incoming."
warn_if_no archives
extract_incoming
convert_to_utf8
convert_to_sql
write_batch_sql
report_done
archive_incoming
