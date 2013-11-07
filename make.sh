#! /bin/bash

set -e

echo "----> Remove a rock"
sudo luarocks remove --force luamarca || true

echo "----> Making rocks"
sudo luarocks make rockspec/luamarca-scm-1.rockspec

echo "----> OK"
