#!/bin/bash
  
prog=$1
lang=$2
prog_path=$lang/test-programs/$prog.$lang
lang_kompiled_dir=$lang/$lang-kompiled
kore_file_path=$prog-$lang.kore
# kast $prog_path -d $lang --expand-macros -o program
kast $prog_path -d $lang --expand-macros -o kore > $kore_file_path
llvm-krun -p -d $lang_kompiled_dir -c PGM $kore_file_path Pgm korefile
rm -f $kore_file_path

