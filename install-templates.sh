#!/usr/bin/env sh

SOURCE_DIR=$(dirname $0)
TEMPLATES_DIR="$HOME/Library/Developer/Xcode/Templates"
FILE_TEMPLATES_DIR="$TEMPLATES_DIR/File Templates"
KIWI_TEMPLATES_DIR="$FILE_TEMPLATES_DIR/Kiwi"


echo "Installing templates to $KIWI_TEMPLATES_DIR"
mkdir -p "$KIWI_TEMPLATES_DIR"
cp -R "$SOURCE_DIR/Templates/" "$KIWI_TEMPLATES_DIR"
echo "Finished"
