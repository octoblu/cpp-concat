#!/bin/sh
LIB_NAME=tentacle-build

BASE_DIR=`pwd`
SRC_DIR=$BASE_DIR/test_cpp_files/src
OUT_DIR=$BASE_DIR/test_cpp_output
TMP_DIR=$BASE_DIR/tmp
CONCAT_CMD="gcc -std=c++98 -E -C -P -nostdinc "
COMBINED_H_FILE=""

rm -rf $TMP_DIR
mkdir -p $TMP_DIR

for dir in $SRC_DIR/*/
do
    dir=${dir%*/}
    CONCAT_CMD+=" -I$SRC_DIR/${dir##*/} "
    COMBINED_H_FILE+="#include \"${dir##*/}.h\"\n"
done
echo $COMBINED_H_FILE >> $TMP_DIR/$LIB_NAME.hpp
CONCAT_CMD+=" $TMP_DIR/$LIB_NAME.hpp > $OUT_DIR/$LIB_NAME.hpp 2> $TMP_DIR/errors.txt"

echo $CONCAT_CMD



# gcc -std=c++98 -E -C -P -I$SRC_DIR/arduino-nanopb \
#       -I$SRC_DIR/tentacle \
#       -I$SRC_DIR/tentacle-arduino \
#       -I$SRC_DIR/tentacle-pseudopod \
#       -nostdinc \
#       $SRC_DIR/tentacle-build.hpp > $OUT_DIR/test.cpp 2> errors.txt