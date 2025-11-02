Tomcat deployment steps (macOS / Homebrew)

This file contains the exact commands used to deploy the `AzurePipelineDemo` project to a local Tomcat instance installed via Homebrew on macOS.

Find your Tomcat home (Homebrew):

```bash
brew --prefix tomcat        # e.g. /usr/local/opt/tomcat or /opt/homebrew/opt/tomcat
TOMCAT_HOME="$(brew --prefix tomcat)/libexec"
echo "$TOMCAT_HOME"
```

Fast exploded deploy (what was used for the project):

```bash
PROJECT_DIR="/Users/winsensid/AzurePipelineDemo"     # adjust if different
TOMCAT_HOME="$(brew --prefix tomcat)/libexec"

# remove old app and copy files
rm -rf "$TOMCAT_HOME/webapps/azure-pipeline-demo"
mkdir -p "$TOMCAT_HOME/webapps/azure-pipeline-demo"
cp -R "$PROJECT_DIR"/* "$TOMCAT_HOME/webapps/azure-pipeline-demo/"

# open in browser
open "http://localhost:8080/azure-pipeline-demo/"
```

WAR deploy (alternative):

```bash
cd /Users/winsensid/AzurePipelineDemo
jar -cvf azure-pipeline-demo.war -C . .
cp azure-pipeline-demo.war "$(brew --prefix tomcat)/libexec/webapps/"
open "http://localhost:8080/azure-pipeline-demo/"
```

Deploy to root (optional):

```bash
TOMCAT_HOME="$(brew --prefix tomcat)/libexec"
# backup ROOT
mv "$TOMCAT_HOME/webapps/ROOT" "$TOMCAT_HOME/webapps/ROOT.bak.$(date +%s)" 2>/dev/null || true
rm -rf "$TOMCAT_HOME/webapps/ROOT"
mkdir -p "$TOMCAT_HOME/webapps/ROOT"
cp -R "/Users/winsensid/AzurePipelineDemo"/* "$TOMCAT_HOME/webapps/ROOT/"
open "http://localhost:8080/"
```

Start/stop Tomcat:

```bash
# Homebrew
brew services start tomcat
brew services stop tomcat

# Manual
TOMCAT_HOME="$(brew --prefix tomcat)/libexec"
"$TOMCAT_HOME/bin/startup.sh"
"$TOMCAT_HOME/bin/shutdown.sh"
```

Logs and verification:

```bash
ls -la "$(brew --prefix tomcat)/libexec/webapps/"
ls -la "$(brew --prefix tomcat)/libexec/webapps/azure-pipeline-demo"

# tail logs if something fails
tail -n 200 "$(brew --prefix tomcat)/libexec/logs/catalina.out"
```

Troubleshooting tips:

- If you get a 404 for `/azure-pipeline-demo/`, check that `index.html` is at the top level of the deployed folder (not nested).
- Use `find "$(brew --prefix tomcat)/libexec/webapps/azure-pipeline-demo" -maxdepth 2 -type f -print` to inspect layout.
- Fix permission issues with `sudo chown -R $(whoami) "$(brew --prefix tomcat)/libexec/webapps/azure-pipeline-demo"`.
- If Tomcat doesn't auto-deploy, restart it and watch `catalina.out` for errors.

If you'd like, I can add a `deploy.sh` to the repo that automates the exploded deploy (with ROOT backup) and a simple diagnostic command.
