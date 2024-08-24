#!/bin/bash

# Directory where the secret is mapped
SECRET_DIR="/users"

# Iterate over all files in the directory
for file in "$SECRET_DIR"/*; do
    # Check if the file is non-zero in size
    if [ -s "$file" ]; then
        # Print the filename and its contents
        echo "$(basename "$file"):$(cat "$file")"
    fi
done
