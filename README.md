# git-jira-utils

Tools to generate CSV lists of git commits, looking up the first JIRA issue mentioned in the commit message

usage
-----

where:

```
UPSTREAM : The upstream branch (typically a tag or release branch)
HEAD : The head branch (typically master)
JIRA_USER : The JIRA user name (for HTTP Basic Authentication)
JIRA_PASSWORD : The JIRA password (for HTTP Basic Authentication)
JIRA_HOST : The JIRA host (eg. jira.myhost.com)
JIRA_PROTOCOL : The JIRA protocol (eg. https)
```

To generate a CSV list with all commits on UPSTREAM branch since it was branched from HEAD

```
./branch-commits.sh UPSTREAM HEAD JIRA_USER JIRA_PASSWORD JIRA_HOST JIRA_PROTOCOL
```

To generate a CSV list with the difference in commits on UPSTREAM and HEAD branches

```
./diff-commits.sh UPSTREAM HEAD JIRA_USER JIRA_PASSWORD JIRA_HOST JIRA_PROTOCOL
```
