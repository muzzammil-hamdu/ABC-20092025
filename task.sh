#!/bin/bash
#author - Muzzammil Hussain
#description - "take input and create or delete a folder"

INPUT=$1
target_dir=$HOME/foldermz

if [ "$INPUT" == "1" ]; then
   echo "create a folder and file"
   mkdir -p "$target_dir"
   echo "this is my file" > "$target_dir/myfilez.txt"
elif [ "$INPUT" == "0" ]; then
   echo "delete folder"
   rm -rf "$target_dir"
else
   echo "usage: $0 {0|1}"
   exit 1
fi

