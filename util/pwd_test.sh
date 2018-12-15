#!/usr/bin/env bash
set -eu
function run_test() {
    local got=$(./pwd.py "$1")
    if [ "$2" != "$got" ]; then
	echo "$2 exptected, but got $got"
    fi
}

run_test "/abc/def/ghi/jkl/mno/pqr/stu/vwx/yz0/123/456/789" "/a/d/g/j/m/p/s/v/y/1/456/789"
run_test "/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" "/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
run_test "/1234567890/1234567890//1234567890" "/1/1//1234567890"
run_test "/1234567890//1234567890/1234567890" "/1//1234567890/1234567890"
echo Success
