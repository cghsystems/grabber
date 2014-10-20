#!/bin/bash

extensions=(*.csv *.rb *.json)

echo "Please enter sort code to obfuscate"
read sort_code

echo "Please enter account number to obfuscate"
read account_number

obfuscate_sort_code() {
  local ext=$1 
  find ../ -type f -name ${ext} -exec sed -i '' s/${sort_code}/99-99-99/g {} +
}

obfuscate_account_number() {
  local ext=$1 
  find ../ -type f -name ${ext} -exec sed -i '' s/${account_number}/1234567/g {} +
}

for ext in "${extensions[@]}"
do
  echo "Will obfuscate extension ${ext}"
  obfuscate_sort_code ${ext}
  obfuscate_account_number ${ext}
done
