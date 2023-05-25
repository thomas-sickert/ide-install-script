#!/bin/sh

# Check for valid input
if [ "$#" -lt 1 ]; then
    echo "Missing IDE Code argument in position 1. Use one of: IU, RM, PY, PS, WS, RD, GO"
    echo "Usage: $0 IDE_CODE"
    exit 1
fi

# Pull the manifest
echo "Fetching the IDE download link from the JetBrains IDE manifest"
DOWNLOAD_LINK=$(curl -s 'https://vsoprodrelusejbuse.blob.core.windows.net/ide-cache/manifest.json' | jq -r --arg CODE $1 '.[] | select(.code==$CODE).release.downloadLink')

# Get the compressed file name from DOWNLOAD_LINK
COMPRESSED_NAME=$(echo $DOWNLOAD_LINK | rev | cut -d '/' -f 1 | rev)

# Prepare the installation destination
IDE_INSTALL_DIR=${2:-/opt/jetbrains}
COMPRESSED_FILE_PATH=$IDE_INSTALL_DIR/$COMPRESSED_NAME

echo "Ensuring install location exists"
mkdir -p "$IDE_INSTALL_DIR" || exit

# Download the IDE from the public blob store
echo "Downloading IDE ($1)"
curl "$DOWNLOAD_LINK" --output "$COMPRESSED_FILE_PATH" || exit

# Extract the IDE from the compressed artifact
echo "Extracting $COMPRESSED_NAME"
tar -xvzf "$COMPRESSED_FILE_PATH" || exit

# Remove the compressed artifact after extraction
echo "Cleaning up $COMPRESSED_NAME"
rm -rf "$COMPRESSED_FILE_PATH" || exit

echo "Successfully installed $1"