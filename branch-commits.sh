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

source $dir/commits-incl.sh

echo_headers

git log $head..$upstream --oneline --before=$before | while read commit_ref commit_message; do
  echo_commit "$upstream" "$commit_ref" "$commit_message" "$jira_user" "$jira_password" "$jira_host" "$jira_protocol" "$jira_key_regex"
done
