#!/bin/bash

for adviser in "$@"; do
    STATUS_CODE=$(grep "$adviser" ext/advisers-utf8.ext | cut -d "|" -f 5)

    echo -n "$adviser: "
    if [ "$STATUS_CODE" == "1" ]; then
      echo "Banned"
    elif  [ "$STATUS_CODE" == "2" ]; then
      echo "Applied"
    elif  [ "$STATUS_CODE" == "3" ]; then
      echo "Inactive"
    elif  [ "$STATUS_CODE" == "4" ]; then
      echo "Active"
    elif  [ "$STATUS_CODE" == "5" ]; then
      echo "Deceased"
    else
      echo "NOT FOUND"
    fi
done
