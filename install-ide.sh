#!/bin/sh

# Helper function to check if a required tool is installed. Exists if the command fails.
check_installed() {
    echo "Checking for '$1'"
    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found"
        exit
    fi
}

# Check for valid input
if [ "$#" -ne 1 ]; then
    echo "Missing IDE Code argument in position 1. Use one of: IU, RM, PY, PS, WS, RD, GO"
    echo "Usage: $0 IDE_CODE"
    exit 1
fi

# Check for required tools
check_installed curl
check_installed tar

# Pull the manifest
echo "Fetching the IDE download link from the JetBrains IDE manifest"
DOWNLOAD_LINK=$(curl -s 'https://vsoprodrelusejbuse.blob.core.windows.net/ide-cache/manifest.json' | jq -r --arg CODE $1 '.[] | select(.code==$CODE).release.downloadLink')

# Get the compressed file name from DOWNLOAD_LINK
COMPRESSED_NAME=$(echo $DOWNLOAD_LINK | rev | cut -d '/' -f 1 | rev)

# Prepare the installation destination
IDE_INSTALL_DIR=/opt/jetbrains
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