#!/bin/bash

TIMEOUT="60s"

function kompile_semantics ()
{ # argument $1: programming language
  echo "kompiling $1..."
  kompile $1/$1.k -O3
}

function kompile_semantics_if_not_yet ()
{ # argument $1: programming language
  local lang_kompiled_dir="$1/$1-kompiled"
  if [ ! -d "$lang_kompiled_dir" ]
  then kompile_semantics "$1"
  fi
}

function time_program ()
{ # argument $1: test program
  # argument $2: programming language
  local prog=$1
  local lang=$2
  local prog_path=$lang/test-programs/$prog.$lang
  local lang_kompiled_dir=$lang/$lang-kompiled
  local kore_file_path=$prog-$lang.kore
  kast $prog_path -d $lang -o kore > $kore_file_path
  local time_result=`( timeout $TIMEOUT /usr/bin/time -f "%e %U %S" llvm-krun -d $lang_kompiled_dir -c PGM $prog-$lang.kore Pgm korefile ) 2>&1 1>/dev/null`
  rm -f $kore_file_path
  if [[ "$time_result" == *"Terminated"* ]]; 
  then echo "$prog.$lang" ">=$TIMEOUT"
  else echo "$prog.$lang" "$time_result"
  fi
}

function remove_kompiled_definitions ()
{ # argument $1: test profile
  local test_profile=$1
  while read -r lang prog; do
    local lang_kompiled_dir=$lang/$lang-kompiled
    rm -rf $lang_kompiled_dir
  done < "$test_profile"
}

function run_profile ()
{ # argument $1: test profile
  local test_profile=$1
  local output_file=$1-result
  while read -r lang prog; do
    kompile_semantics_if_not_yet $lang
    echo "running $prog.$lang..."
    time_program $prog $lang >> $output_file
  done < $test_profile
}

echo "running profile \"$1\"..."
echo "removing all kompiled definitions..."
remove_kompiled_definitions $1
run_profile $1
