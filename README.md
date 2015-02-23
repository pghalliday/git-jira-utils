# git-jira-utils

Bash scripts to generate CSV lists of git commits, looking up the JIRA issues mentioned in the commit message

Dependencies
------------

- [NodeJS](http://nodejs.org/) for parsing JSON responses from JIRA
- git
- curl
- echo
- date
- wc
- head
- tail
- etc...

Usage
-----

### Commit tools

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

#### Output

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

### Release tools

where:

```
HEAD : the head branch from which all release branches are made (eg. "master")
RELEASE_BRANCH_PREFIX : the prefix for release branches (eg. "origin/release/")
VERSION_REGEX : Regular expression to match release versions (eg. "v[0-9]+\\.[0-9]+\\.[0-9]+")
RELEASE_TAG_PREFIX : the prefix for release tags (eg. "release/")
RELEASE_REGEX : Regular expression to match the release suffix on tagged versions (eg. "\\.[a-z]")
```

To generate a CSV summary of stats about all the previous releases matching a process of creating a release branch from HEAD, then repeatedly making changes to stabilise that branch and tagging releases with a suffix.

```
./release-analysis.sh HEAD RELEASE_BRANCH_PREFIX VERSION_REGEX RELEASE_TAG_PREFIX RELEASE_REGEX
```

#### Output

```
"start_date","end_date","version","commit_count","tag_count","days_to_stabilize"
"2014-09-23T08:31:29+02:00","2014-09-26T12:23:38+02:00","v0.1.7","1","4","3"
"2014-09-29T12:34:11+02:00","2014-09-29T13:37:38+02:00","v0.1.8","4","3","0"

...
```
