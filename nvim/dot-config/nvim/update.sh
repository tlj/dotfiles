#!/usr/bin/env sh

git submodule init
git submodule update --remote

cd pack/vendor/opt/CopilotChat 
make tiktoken
cd - > /dev/null




