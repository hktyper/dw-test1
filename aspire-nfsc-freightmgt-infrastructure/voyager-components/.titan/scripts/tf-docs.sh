#! /bin/bash

status=0

for dir in */;do
  if [[ -f "$dir/.terraform-docs.yml" ]];then
    cd $dir
    terraform-docs . > README.md
    git diff --exit-code -s README.md
    code=$?
    if [[ $code != 0 ]];then
      echo "$dir: README not up to date";
      status=1
    fi;
    cd ..
  fi;
done

exit $status
