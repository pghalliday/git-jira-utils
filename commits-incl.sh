function csv_quote {
  echo -en \"${@//\"/\"\"}\"
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

  branch=${1//\\//\\\\}
  commit_ref=${2//\\//\\\\}
  commit_message=${3//\\/\\\\}
  jira_user=$4
  jira_password=$5
  jira_host=$6
  jira_protocol=$7
  jira_key_regex=$8

  jira_browse_url=$jira_protocol://$jira_host/browse
  jira_issue_url=$jira_protocol://$jira_user:$jira_password@$jira_host/rest/api/2/issue

  jira_url=
  jira_type=
  jira_summary=
  for word in $commit_message
  do
    if [[ $word =~ $jira_key_regex ]]
    then
      jira_ref="$BASH_REMATCH"
      jira_issue=$(curl $CURL_OPTS $jira_issue_url/$jira_ref?$JIRA_QS)
      if [ "$jira_url" != "" ]
      then
        jira_url="$jira_url\n"
        jira_type="$jira_type\n"
        jira_summary="$jira_summary\n"
      fi
      temp_url=$jira_browse_url/$jira_ref
      jira_url=$jira_url${temp_url//\\/\\\\}
      temp_type=$(echo $jira_issue | parse_json fields.issuetype.name)
      jira_type=$jira_type${temp_type//\\//\\\\}
      temp_summary=$(echo $jira_issue | parse_json fields.summary)
      jira_summary=$jira_summary${temp_summary//\\/\\\\}
    fi
  done 
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
