#!/usr/bin/env bash

git clone https://github.com/Valloric/ycmd.git
cd ycmd
git submodule update --init --recursive
echo 'You now probably want to run something like
./build.py --all'
