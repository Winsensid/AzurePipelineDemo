```markdown# AzurePipelineDemo

# AzurePipelineDemo

A tiny static web project you can deploy to Tomcat and use to practice Azure Pipeline.

A tiny static web project you can deploy to Tomcat and use to practice Azure Pipelines.

Files created:

Files in this repo

- `index.html` - simple page showing **AzurePipeline**.

- `index.html` - simple static page (project root)- `azure-pipelines.yml` - example pipeline that zips `AzurePipelineDemo` and publishes an artifact.

- `README.md` - this file (local deploy + pipeline notes)

- `DEPLOYMENT.md` - detailed Tomcat deployment commands used on macOS/Homebrew## Run locally with Tomcat (macOS)



- Deployed the project as an exploded webapp to Tomcat at `/usr/local/opt/tomcat/libexec/webapps/azure-pipeline-demo/` (Homebrew Tomcat). The app is now available at: http://localhost:8080/azure-pipeline-demo/Copy the project into Tomcat `webapps` and start Tomcat:



Run locally with Tomcat (macOS)```bash

# from your home (adjust paths if needed)

This section gives a few safe ways to deploy the site to Tomcat on macOS. The Homebrew path is the most common on macOS; if your Tomcat is installed somewhere else, replace the paths below with your `TOMCAT_HOME`.cp -R "$HOME/AzurePipelineDemo" /path/to/tomcat/webapps/AzurePipelineDemo

cd /path/to/tomcat/bin

Find your Tomcat Home (Homebrew):# make script executable if needed

chmod +x *.sh

```bash./catalina.sh start

brew --prefix tomcat        # shows e.g. /usr/local/opt/tomcat or /opt/homebrew/opt/tomcat```

TOMCAT_HOME="$(brew --prefix tomcat)/libexec"

echo "$TOMCAT_HOME"Then open http://localhost:8080/AzurePipelineDemo/ in your browser.

```

To stop Tomcat:

1) Exploded directory (fast, used here)

```bash

This copies the repository files into a webapp folder Tomcat will serve immediately.cd /path/to/tomcat/bin

./catalina.sh stop

```bash```

PROJECT_DIR="$HOME/AzurePipelineDemo"                     # adjust if different

TOMCAT_HOME="$(brew --prefix tomcat)/libexec"If you installed Tomcat via Homebrew, start it with:



# remove old app (if any) and copy files```bash

rm -rf "$TOMCAT_HOME/webapps/azure-pipeline-demo"brew services start tomcat

mkdir -p "$TOMCAT_HOME/webapps/azure-pipeline-demo"# or

cp -R "$PROJECT_DIR"/* "$TOMCAT_HOME/webapps/azure-pipeline-demo/"catalina run

```

# open in browser

open "http://localhost:8080/XXXXXXXX/"## Use the included Azure Pipelines YAML

```

The `azure-pipelines.yml` at the repository root packages the `AzurePipelineDemo` folder into `webapp.zip` and publishes it as an artifact named `drop`.

Notes:

Steps to run on Azure DevOps:

- Ensure `index.html` lives at the top level of the copied folder (Tomcat serves `index.html` by default).

- Tomcat usually auto-deploys new folders placed in `webapps/`. If it doesn't, restart Tomcat (commands below).1. Push this repository to Azure Repos or another Git host supported by Azure Pipelines.

2. In Azure DevOps, create a new pipeline and point it to this repository. Use the YAML pipeline option (it will detect `azure-pipelines.yml`).

2) Create a WAR and let Tomcat expand it3. Run the pipeline — it will produce a build artifact `webapp.zip` you can download.



```bashTo change which folder is packaged, edit the `rootFolderOrFile` in `azure-pipelines.yml`.

cd /Users/winsensid/AzurePipelineDemo

jar -cvf azure-pipeline-demo.war -C . .## Next ideas

cp azure-pipeline-demo.war "$(brew --prefix tomcat)/libexec/webapps/"

open "http://localhost:8080/azure-pipeline-demo/"- Add a small test (Selenium/Playwright) to run during pipeline for automation testing practice.

```- Add a simple shell step to copy the artifact to a Tomcat server (requires credentials).



3) Deploy to root (optional, for quick root testing)

Back up `ROOT` first, then copy files into `webapps/ROOT/` to serve at `http://localhost:8080/`:

```bash
TOMCAT_HOME="$(brew --prefix tomcat)/libexec"
mv "$TOMCAT_HOME/webapps/ROOT" "$TOMCAT_HOME/webapps/ROOT.bak.$(date +%s)" 2>/dev/null || true
rm -rf "$TOMCAT_HOME/webapps/ROOT"
mkdir -p "$TOMCAT_HOME/webapps/ROOT"
cp -R "/Users/winsensid/AzurePipelineDemo"/* "$TOMCAT_HOME/webapps/ROOT/"
open "http://localhost:8080/"
```

Start / Stop Tomcat (Homebrew and manual)

```bash
# Homebrew service
brew services start tomcat
brew services stop tomcat

# manual (from TOMCAT_HOME/bin)
TOMCAT_HOME="$(brew --prefix tomcat)/libexec"
"$TOMCAT_HOME/bin/startup.sh"
"$TOMCAT_HOME/bin/shutdown.sh"
```

Verify & logs

- Confirm your app folder exists under `webapps/`:

```bash
ls -la "$(brew --prefix tomcat)/libexec/webapps/"
ls -la "$(brew --prefix tomcat)/libexec/webapps/azure-pipeline-demo"
```

- Tail Tomcat logs if you see 404s or deployment errors:

```bash
tail -n 200 "$(brew --prefix tomcat)/libexec/logs/catalina.out"
tail -f "$(brew --prefix tomcat)/libexec/logs/catalina.out"   # live
```

Troubleshooting tips

- 404 for `/azure-pipeline-demo/` usually means Tomcat didn't find the folder or `index.html` is nested inside a subfolder. Use `find` to inspect:

```bash
find "$(brew --prefix tomcat)/libexec/webapps/azure-pipeline-demo" -maxdepth 2 -type f -print
```

- Permission errors while copying: run `sudo chown -R $(whoami) "$(brew --prefix tomcat)/libexec/webapps/azure-pipeline-demo"` or adjust ownership/permissions appropriately.
- If Tomcat doesn't auto-deploy, restart it and watch `catalina.out` for errors.
- Port conflicts: Tomcat listens on 8080 by default. If another process uses 8080, either stop it or change Tomcat's port in `conf/server.xml`.

Azure Pipelines notes

The `azure-pipelines.yml` (if present) in this repo is a simple example that packages the project into a zip artifact. Typical next steps:

1. Push this repo to Azure Repos or GitHub.
2. Create a Pipeline in Azure DevOps and point it at the repository using the YAML file.
3. Run, download the `webapp.zip` artifact, and deploy the artifact to your Tomcat server (manual copy, SSH script, or artifact-based deployment).

Next ideas

- Add a `WEB-INF/web.xml` only if you later add servlets. Static content doesn't require it.
- Create a small deployment script in the repo (Bash) that packages and copies the artifact to your Tomcat for easier repetition.

---

If you'd like, I can add a small `deploy.sh` script to this repo that does the exploded deploy (with backups) and a simple diagnostic command. Ask me to "add deploy script" and I'll add it and run a quick test.
```
