function csv_quote {
  echo -n \"${@//\"/\"\"}\"
}

function csv_field {
  csv_quote $@
  echo -n ,
}

function csv_last_field {
  csv_quote $@
  echo
}

function parse_json {
  JIRA_NODE_JSON_PARSE_COMMAND="var json='';process.stdin.on('readable',function(){json+=process.stdin.read()||'';}).on('end',function(){console.log(JSON.parse(json).QUERY);})"
  node -e "${JIRA_NODE_JSON_PARSE_COMMAND//QUERY/$1}"
}

function echo_commit {
  CURL_OPTS=-sk
  JIRA_QS=fields=summary,issuetype
  JIRA_REF_REGEX='(HEL\-[0-9]*)'

  jira_user=$1
  jira_password=$2
  jira_host=$3
  jira_protocol=$4
  branch=$5
  commit_ref=$6
  commit_message=$7

  jira_browse_url=$jira_protocol://$jira_host/browse
  jira_issue_url=$jira_protocol://$jira_user:$jira_password@$jira_host/rest/api/2/issue

  jira_url=
  jira_type=
  jira_summary=
  if [[ $commit_message =~ $JIRA_REF_REGEX ]]
  then
    jira_ref="$BASH_REMATCH"
    jira_issue=$(curl $CURL_OPTS $jira_issue_url/$jira_ref?$JIRA_QS)
    jira_url=$jira_browse_url/$jira_ref
    jira_type=$(echo $jira_issue | parse_json fields.issuetype.name)
    jira_summary=$(echo $jira_issue | parse_json fields.summary)
  fi
  csv_field $branch
  csv_field $commit_ref
  csv_field $commit_message
  csv_field $jira_url
  csv_field $jira_type
  csv_last_field $jira_summary
}

function echo_headers {
  csv_field branch
  csv_field commit_ref
  csv_field commit_message
  csv_field jira_url
  csv_field jira_type
  csv_last_field jira_summary
}
