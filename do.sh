#!/usr/bin/env bash
function create_repo() {
  curl -X POST -u <USER NAME>:<PASS WORD> \
    -H "Content-type: application/json" \
    https://api.bitbucket.org/2.0/repositories/<REPOS OWNER>/$1 \
    -d '{"scm":"git", "is_private":true, "fork_policy":"no_forks" }'
}

function add_group() {
    curl -X PUT -u <USER NAME>:<PASS WORD> \
      https://bitbucket.org/api/1.0/group-privileges/<REPOS OWNER>/$1/<REPOS OWNER>/<GROUP> \
      --data write
}

github='git@github.com:<GITHUB USER NAME>/'
repos=(
  <REPOS>,
  <REPOS>,
  <REPOS>,
  <REPOS>,
  <REPOS>,
  <REPOS>,
  .
  .
  .
)

for repo in ${repos[@]}
do
  echo "Cloning... ${github}${repo}.git"
  git clone ${github}${repo}.git repos/${repo}
  echo "Clone end."

  echo "Create repo on Bitbucket."
  create_repo $repo
  cd repos/$repo

  git remote rm origin
  git remote add origin git@bitbucket.org:<REPOS OWNER>/${repo}.git
  git push origin master
  echo "Add access control."
  add_group $repo

  echo "Done(${repo})"
  cd /Users/nabetama/git/toBB # REPOS ROOT.
done
