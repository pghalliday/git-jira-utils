#!/bin/bash

head=$1
release_branch_prefix=$2
version_regex=$3
release_tag_prefix=$4
release_regex=$5

function get_data {
  git branch -r | grep -Po "^[[:space:]]*${release_branch_prefix}\K${version_regex}$" | while read version; do
    tag_dates=$(git log --tags --simplify-by-decoration --pretty="format:%aI %d" | grep -Po "^[0-9T\-\:\+]*(?=[[:space:]]*\(tag: ${release_tag_prefix}${version//\./\\\.}${release_regex}\)$)" | sort)
    tag_count=$(echo "$tag_dates" | wc -l)
    start_date=$(echo "$tag_dates" | head -n 1)
    end_date=$(echo "$tag_dates" | tail -n 1)
    if [ "$start_date" != "" ]
    then
      commit_count=$(git log --oneline --before=end_date ${head}..${release_branch_prefix}${version} | wc -l)
      start_date_seconds=$(date -d $start_date +%s)
      end_date_seconds=$(date -d $end_date +%s)
      seconds_to_stabilize=$(($end_date_seconds-$start_date_seconds))
      days_to_stabilize=$(($seconds_to_stabilize/(60*60*24)))
      echo \"$start_date\",\"$end_date\",\"$version\",\"$commit_count\",\"$tag_count\",\"$days_to_stabilize\"
    fi
  done
}

echo \"start_date\",\"end_date\",\"version\",\"commit_count\",\"tag_count\",\"days_to_stabilize\"
get_data | sort
