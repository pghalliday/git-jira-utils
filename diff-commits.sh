#!/bin/bash

set -e

dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

upstream=$1
head=$2
jira_user=$3
jira_password=$4
jira_host=$5
jira_protocol=$6

source $dir/commits-incl.sh

echo_headers

git cherry -v $upstream $head | while read merged commit_ref commit_message; do
  if [ "$merged" == "+" ]
  then
    branch=$head
  else
    branch=$head/$upstream
  fi
  echo_commit "$jira_user" "$jira_password" "$jira_host" "$jira_protocol" "$branch" "$commit_ref" "$commit_message"
done

git cherry -v $head $upstream | while read merged commit_ref commit_message; do
  if [ "$merged" == "+" ]
  then
    echo_commit "$jira_user" "$jira_password" "$jira_host" "$jira_protocol" "$upstream" "$commit_ref" "$commit_message"
  fi
done
