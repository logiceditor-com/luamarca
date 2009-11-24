#!/bin/bash

# Script to smoke-check benchmarks for errors

if [ -z "$1" ]; then
  echo "Usage: $0 <benchmarks>" >&2
  exit 1
fi

LUA=lua
LUAC=luac

SYNTAX="${LUAC} -p"
BENCH="${LUA} bench.lua"

NUM_ITER=1

errors=""

for bench_file in $@; do
  echo "--> Checking file '${bench_file}'"

  ${SYNTAX} ${bench_file} || {
      echo "--> FAIL (syntax check)"
      errors="${errors}\n* ${bench_file}: syntax error"
      continue
    }

  methods=`${BENCH} ${bench_file} | grep '^\* ' | awk '{ print $2; }'` || {
      echo "--> FAIL (methods list exec)"
      errors="${errors}\n* ${bench_file}: methods list error or list empty"
      continue
    }

  if [ -z "${methods}" ]; then
    echo "--> FAIL (methods list)"
    errors="${errors}\n* ${bench_file}: methods list error or list empty"
    continue
  fi

  have_bad_methods=0
  for method in ${methods}; do
    echo "----> Checking method '${method}'"

    ${BENCH} ${bench_file} ${method} ${NUM_ITER} || {
        echo "----> FAIL (method run)"
        errors="${errors}\n* ${bench_file}: ${method}: method failed"
        have_bad_methods=1
        continue
      }

    echo "----> OK"
  done

  if [ $have_bad_methods == 1 ]; then
    echo "--> FAIL (method run)"
    #errors="${errors}\n* ${bench_file}: has faulty methods"
    continue
  fi

  echo "--> OK"
done

if [ ! -z "${errors}" ]; then
  echo -e "\nSmoke tests failed:" >&2
  echo -e "${errors}" >&2
  exit 2
else
  echo -e "\nAll smoke tests passed!"
fi
