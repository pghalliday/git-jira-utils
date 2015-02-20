# git-jira-utils

Bash scripts to generate CSV lists of git commits, looking up the JIRA issues mentioned in the commit message

Dependencies
------------

- [NodeJS](http://nodejs.org/) for parsing JSON responses from JIRA

Usage
-----

where:

```
UPSTREAM : The upstream branch (typically a tag or release branch)
HEAD : The head branch (typically master)
JIRA_USER : The JIRA user name (for HTTP Basic Authentication)
JIRA_PASSWORD : The JIRA password (for HTTP Basic Authentication)
JIRA_HOST : The JIRA host (eg. jira.myhost.com)
JIRA_PROTOCOL : The JIRA protocol (eg. https)
JIRA_KEY_REGEX : Regular expression to use when matching JIRA issue keys (eg. "KEY-[0-9]*")
```

To generate a CSV list with all commits on UPSTREAM branch since it was branched from HEAD

```
./branch-commits.sh UPSTREAM HEAD JIRA_USER JIRA_PASSWORD JIRA_HOST JIRA_PROTOCOL JIRA_KEY_REGEX
```

To generate a CSV list with the difference in commits on UPSTREAM and HEAD branches

```
./diff-commits.sh UPSTREAM HEAD JIRA_USER JIRA_PASSWORD JIRA_HOST JIRA_PROTOCOL JIRA_KEY_REGEX
```

Output
------

```
"branch","commit_ref","commit_message","jira_url","jira_type","jira_summary"
"master","3ef025c773b3d93572b1a0af8383d41e579e0a7d","fix KEY-1324","https://jira.myhost.com/browse/KEY-1234","Bug","Application is broken"
"master","21e662f65125a3782c1918736d9190108279e277","fix KEY-2341 and implement KEY-754","https://jira.myhost.com/browse/KEY-2341
https://jira.myhost.com/browse/KEY-754","Bug
Story","Application is broken again
Application should have a new feature"

...
```

Note that multiple JIRA issues for the same commit will be listed with line breaks in the corresponding fields
