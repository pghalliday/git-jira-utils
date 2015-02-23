#!/bin/bash

set -e

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

upstream=$1
head=$2
jira_user=$3
jira_password=$4
jira_host=$5
jira_protocol=$6
jira_key_regex=$7
before=$8
if [ "$before" == "" ]
then
  before=$(date -Iseconds)
fi
before_seconds=$(date -d $before +%s)

source $dir/commits-incl.sh

echo_headers

git cherry -v $upstream $head | while read merged commit_ref commit_message; do
  commit_seconds=$(git show $commit_ref -s --pretty="format:%at")
  if [ "$before_seconds" -gt "$commit_seconds" ]
  then
    if [ "$merged" == "+" ]
    then
      branch=$head
    else
      branch="$head + $upstream"
    fi
    echo_commit "$branch" "$commit_ref" "$commit_message" "$jira_user" "$jira_password" "$jira_host" "$jira_protocol" "$jira_key_regex"
  fi
done

git cherry -v $head $upstream | while read merged commit_ref commit_message; do
  commit_seconds=$(git show $commit_ref -s --pretty="format:%at")
  if [ "$before_seconds" -gt "$commit_seconds" ]
  then
    if [ "$merged" == "+" ]
    then
      echo_commit "$upstream" "$commit_ref" "$commit_message" "$jira_user" "$jira_password" "$jira_host" "$jira_protocol" "$jira_key_regex"
    fi
  fi
done
