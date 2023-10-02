#!/bin/bash

commit_hash=${1:0:7}
git show --color=always $commit_hash
