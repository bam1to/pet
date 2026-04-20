#!/bin/bash

if [ -f "composer.json" ]; then
    echo "INFO: composer.json found. Installing dependencies..."
    composer install --prefer-dist --no-scripts --no-progress
fi

# Set git user configuration if not already set
CURRENT_NAME=$(git config --global user.name 2>/dev/null)
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null)

if [ -n "$GIT_USERNAME" ] && [ -z "$CURRENT_NAME" ]; then
    git config --global user.name "$GIT_USERNAME"
fi

if [ -n "$GIT_EMAIL" ] && [ -z "$CURRENT_EMAIL" ]; then
    git config --global user.email "$GIT_EMAIL"
fi

# Start the Symfony server
echo "INFO: Starting Symfony server..."
symfony server:start --no-tls --allow-all-ip --port=8000

exec "$@"