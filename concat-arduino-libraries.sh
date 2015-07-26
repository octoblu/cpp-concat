#!/bin/sh
LIB_NAME=tentacle-build

BASE_DIR=`pwd`
SRC_DIR=$BASE_DIR/test_cpp_files/src
DIST_DIR=$BASE_DIR/dist
TMP_DIR=$BASE_DIR/tmp
CONCAT_CMD="gcc -std=c++98 -E -C -P -nostdinc "
COMBINED_H_FILE=""

rm -rf $TMP_DIR
mkdir -p $TMP_DIR

rm -rf $DIST_DIR
mkdir -p $DIST_DIR

for dir in $SRC_DIR/*/
do
    dir=${dir%*/}
    CONCAT_CMD+=" -I$SRC_DIR/${dir##*/} "
    COMBINED_H_FILE+="#include \"${dir##*/}.h\"\n"
done
echo $COMBINED_H_FILE >> $TMP_DIR/$LIB_NAME.hpp
CONCAT_CMD+=" $TMP_DIR/$LIB_NAME.hpp > $DIST_DIR/$LIB_NAME.h 2> $TMP_DIR/errors.txt"

echo $CONCAT_CMD | sh