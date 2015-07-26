#!/bin/sh
BASE_DIR=`pwd`
SRC_DIR=$BASE_DIR/test_cpp_files/src
OUT_DIR=$BASE_DIR/test_cpp_output

gcc -std=c++98 -E -C -P -I$SRC_DIR/arduino-nanopb \
      -I$SRC_DIR/tentacle \
      -I$SRC_DIR/tentacle-arduino \
      -I$SRC_DIR/tentacle-pseudopod \
      -nostdinc \
      $SRC_DIR/tentacle-build.hpp > $OUT_DIR/test.cpp