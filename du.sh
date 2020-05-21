#! /bin/bash


###  Recursively adds up block_size of all files in root_dir
function calculate_size_recursive {
  local directory="$1"
  local total_size=0

  while read filename ; do
    if [ ! -z "$filename" ] ; then
      local filepath="$directory/$filename"
      local size=$( stat -f %b "$filepath" )

      if [ -d "$filepath" ] ; then
        local dir_size=$( calculate_size_recursive "$filepath" )
        size=$(( size + dir_size ))
      fi

      # >&2 echo "$size $filepath"

      total_size=$(( total_size + size ))
    fi
  done <<< "$( ls -1 -A -v "$directory" )"

  echo $total_size
  return 0
}


###  Main

# Checking, if we got a path to file
if [ -z "$1" ] ; then
  root_dir=$( realpath '.' )
else
  root_dir=$( realpath $1 )
fi


size=$( calculate_size_recursive $root_dir )
echo $size
