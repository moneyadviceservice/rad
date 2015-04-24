#!/bin/bash

set -e

source 'lib/fca_conversion.sh'

clear_data
extract_archives
convert_to_utf8
convert_to_sql
write_batch_sql
report_done
