#!/bin/bash
for (( i=0; i <= "$#"; i++ )); do
  echo "$i: ${!i}"
done
