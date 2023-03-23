#!/bin/bash

# Get a list of all untagged images
untagged_images=$(docker images -f "dangling=true" -q)

# Check if there are any untagged images
if [ -z "$untagged_images" ]; then
    echo "No untagged images found."
else
    # Remove all untagged images
    docker rmi $untagged_images
fi

