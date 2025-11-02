#!/usr/bin/env bash
set -euo pipefail

# Simple deploy helper for local Tomcat (Homebrew) on macOS
# Usage:
#   ./deploy.sh         -> sync files
#   ./deploy.sh -o      -> sync and open browser
#   ./deploy.sh -t      -> sync and tail catalina.out
#   ./deploy.sh -ot     -> sync, open browser and tail logs

PROJECT_DIR="/Users/winsensid/AzurePipelineDemo"
TOMCAT_HOME="$(brew --prefix tomcat)/libexec"
APP_NAME="azure-pipeline-demo"
DEST="$TOMCAT_HOME/webapps/$APP_NAME"
URL="http://localhost:8080/$APP_NAME/"

OPEN=false
TAIL=false

while getopts "ot" opt; do
  case "$opt" in
    o) OPEN=true ;;
    t) TAIL=true ;;
    *) echo "Usage: $0 [-o] [-t]"; exit 1 ;;
  esac
done

echo "Project: $PROJECT_DIR"
echo "Tomcat: $TOMCAT_HOME"
echo "Deploying to: $DEST"

# ensure destination exists
mkdir -p "$DEST"

# sync (fast incremental)
rsync -av --delete "$PROJECT_DIR"/ "$DEST"/

echo "Deployed. $PROJECT_DIR -> $DEST"

if [ "$OPEN" = true ]; then
  echo "Opening $URL"
  open "$URL"
fi

if [ "$TAIL" = true ]; then
  echo "Tailing logs (press Ctrl+C to stop)"
  tail -f "$TOMCAT_HOME/logs/catalina.out"
fi
