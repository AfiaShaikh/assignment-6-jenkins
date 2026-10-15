# Assignment 6 — Jenkins integration with GitHub

## 1. Start Jenkins

Extract this assignment separately to `C:\personal\afia\Assignment_6_Jenkins_GitHub`.

In WSL, enter:

```bash
cd /mnt/c/personal/afia/Assignment_6_Jenkins_GitHub
```

Run from this project root:

```bash
docker compose -f jenkins/compose.yaml up -d --build
docker compose -f jenkins/compose.yaml ps
docker compose -f jenkins/compose.yaml logs --tail=40 jenkins
```

Open **http://localhost:8081** in Windows Chrome/Edge. Wait for Jenkins to finish starting.

Get the initial unlock password:

```bash
docker compose -f jenkins/compose.yaml exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Enter it in the browser. Choose **Install suggested plugins**, create your administrator account, and finish setup. Keep passwords out of screenshots.
The named Docker volume retains Jenkins jobs and settings across restarts.

Inside **Manage Jenkins > Plugins > Installed plugins**, confirm:

- Git (plugin ID `git`)
- GitHub (`github`)
- Pipeline (`workflow-aggregator`)

If missing, use **Available plugins** to install them and restart Jenkins when no builds are running.
Suggested plugins may already include them; do not reinstall unnecessarily.

Check tools inside Jenkins, not just inside WSL:

```bash
docker compose -f jenkins/compose.yaml exec jenkins git --version
docker compose -f jenkins/compose.yaml exec jenkins python3 --version
docker compose -f jenkins/compose.yaml exec jenkins java -version
```

Java is already inside the Jenkins image. No separate host Java installation is needed for this setup.

## 2. Put this project on GitHub

Create a new **empty** repository named `assignment-6-jenkins` on GitHub.
For the simplest lab use a public repository containing only these sample files.
Do not add a README, licence or .gitignore during GitHub repository creation: the ZIP already contains project files.

From the project root:

```bash
git init -b main
git add .
git commit -m "Add Jenkins CI and Helm assignment demo"
git remote add origin https://github.com/YOUR_USERNAME/assignment-6-jenkins.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username before running the remote command.
If Git requests your identity, set your own name and email with `git config user.name` and `git config user.email`, then retry the commit.
Use GitHub CLI/browser authentication or a token when pushing over HTTPS; GitHub account passwords do not work for Git pushes.
An alternative is GitHub's **Add file > Upload files**: upload the contents so `app.py` and `Jenkinsfile` appear at repository root, not inside an extra folder. For the later automatic-build demonstration you can edit README directly on GitHub.

Open the repository page and verify all files are present on branch `main`.

## 3. Create the required Freestyle job

1. Jenkins dashboard > **New Item**.
2. Name: **GitHub-Jenkins-Demo**.
3. Choose **Freestyle project**, then OK.
4. Under **Source Code Management**, choose **Git**.
5. Repository URL: `https://github.com/YOUR_USERNAME/assignment-6-jenkins.git`.
6. Public repository: leave **Credentials** blank.
7. Branches to build / Branch Specifier: `*/main`.
8. Under **Build Triggers**, tick **Poll SCM**, schedule: `H/2 * * * *`.
9. Add **Build Steps > Execute shell**, paste:

```sh
set -eu
git log -1 --oneline
ls -la
sh ci/build.sh
```

10. Under **Post-build Actions**, add **Archive the artifacts**. File pattern: `artifacts/*.txt`.
11. Save, then click **Build Now**.
12. Open the build number > **Console Output**.

Check for repository fetching/checkout, the actual commit ID, the application `PASS` line and **Finished: SUCCESS**.
The build uses `--check`, so it finishes. Running only `python app.py` would leave the web server running and the build would not complete.

The console displays the actual workspace path, commonly `/var/jenkins_home/workspace/GitHub-Jenkins-Demo`.
You can also inspect it directly:

```bash
docker compose -f jenkins/compose.yaml exec jenkins ls -la /var/jenkins_home/workspace/GitHub-Jenkins-Demo
```

Job files live inside the Jenkins container/volume, not in your WSL working directory.

## 4. Prove automatic retrieval of a new commit

1. Save screenshots of build #1, including its commit ID.
2. Edit `README.md` on GitHub, append `Automatic Jenkins polling demonstration`, and commit to `main`.
3. Do **not** click Build Now this time.
4. Wait roughly 2–3 minutes while Jenkins polls GitHub.
5. Open the new build and capture its trigger cause, new commit ID and successful output.

Polling checks for changes about every two minutes and schedules a build when it finds a new commit. It is not an immediate webhook. A localhost Jenkins URL cannot normally receive GitHub webhooks from the internet, so polling avoids that extra setup.

## 5. Optional Pipeline job using the supplied Jenkinsfile

The Freestyle job above meets the required procedure. Use this extra job to demonstrate Pipeline stages.

1. New Item > **GitHub-Jenkins-Pipeline** > **Pipeline**.
2. Definition: **Pipeline script from SCM**.
3. SCM: Git; use the same repository URL and credentials policy.
4. Branch: `*/main`. Script Path: `Jenkinsfile`.
5. Save, then **Build Now** once. Its first run registers the polling trigger.
6. Inspect the Checkout and Build and Check stages, Console Output and archived artifacts.

`checkout scm` uses the Git configuration from this job. There is no hard-coded username in the Jenkinsfile.
If both jobs poll the same repository, each will build a new commit. You can disable the Freestyle job's polling after recording its evidence.

## Private repository credentials, if needed

Create a fine-grained GitHub token scoped only to this repository, with repository **Contents: Read-only**, and the required organisation approval if applicable.
In Jenkins add a **Username with password** credential: username = your GitHub username, password = that token. Select this credential in the job's Git SCM configuration.
Do not put the token in the repository URL, source code or shell command.
Write access used to push from WSL is a separate permission from Jenkins' checkout access.

## Capture evidence and stop

Use `Evidence/README.md` for the screenshot checklist. Save the successful build console using its **View as plain text** option and save the two archived text artifacts.

When finished, you can free memory when you are not using Jenkins:

```bash
docker compose -f jenkins/compose.yaml stop
```

Resume later with `docker compose -f jenkins/compose.yaml start`.
Do not use `down -v` unless you deliberately want to delete the saved Jenkins setup.

## Troubleshooting

| Symptom | What to check |
| --- | --- |
| Docker daemon unavailable | Start Docker Desktop and enable integration for this WSL distribution. |
| localhost:8081 unavailable | Check `docker compose ... ps` and logs; ensure port 8081 is free. |
| Password file not present yet | Wait for Jenkins startup and retry the password command. |
| `Couldn't find any revision to build` | Repository has an initial commit and the configured branch is `*/main`. |
| Checkout authentication failed | Public repo needs no credential; private repo needs correct username/token and repository access. |
| `python3` or `venv` missing | Run the build using the custom Jenkins image in this package; rebuild the Compose service if needed. |
| `externally-managed-environment` | The script installs into `.venv-ci`; do not replace it with a system-wide `pip install`. |
| `set: Illegal option` or CRLF errors | Convert edited shell files to LF in VS Code and commit the fix. |
| No automatic build | Ensure Poll SCM is saved, a new commit is on `main`, and inspect the job's Polling Log. |
| Plugin/package downloads fail | Inspect the actual TLS/proxy/network error; use your organisation's approved proxy/CA configuration if required. |
