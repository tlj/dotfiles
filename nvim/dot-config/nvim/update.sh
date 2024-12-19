#!/usr/bin/env sh

git submodule update --remote

cd pack/vendor/opt/blink.cmp
git checkout v0.7.6
cd - > /dev/null

cd pack/vendor/opt/CopilotChat 
make tiktoken
cd - > /dev/null




