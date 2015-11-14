#!/bin/sh

directory=$(dirname "$0")
"$directory/../app/zpm/bin/node.exe" "$directory/../app/zpm/lib/cli.js" "$@"