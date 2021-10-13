#!/bin/sh
# gcbh - A simple helper for cloning a repo and all its branches
# Copyright (C) 2021: takusuman; kindly given for Arquivotheca
# SPDX-License-Identifier: Unlicense

main(){
  while getopts ":c:M:h" option; do
    case "$option" in
      M) export master_branch="$OPTARG" ;;
      c) clone_all "$OPTARG";;
      \?|h) print_help ;;
    esac
  done
}

clone_all(){
  repo=$1
  repodir="$(basename $repo)"
  printf 'cloning %s (%s) into %s...\n' "$repo" "$master_branch" \
  "$PWD/$repodir"
  git clone -v $repo "$repodir" \
    && cd $repodir 
    bs=$(git branch -a | grep remotes | grep -v HEAD \
        | grep -v $master_branch | sort)
    for i in $bs; do
      b=$(basename $i)
      git clone -v -b $b --single-branch $repo $b
    done
  return 0
}

print_help(){
  printf '[usage]: %s -M master-branch -c http://git.example.net/repo.git' $0
}

main $@
