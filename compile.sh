#!/bin/bash
# compile.sh – Compile and run MovieRater
# Requirements: Java JDK 17+ and the sqlite-jdbc jar in lib/

set -e

JAR="lib/sqlite-jdbc.jar"
SRC=$(find src -name "*.java")
OUT="out"
MAIN_CLASS="movierater.Main"

echo "==> Compiling..."
mkdir -p "$OUT"
javac -cp "$JAR" -d "$OUT" $SRC

echo "==> Compilation successful."
echo "==> Starting MovieRater..."
java -cp "$OUT:$JAR" "$MAIN_CLASS"
