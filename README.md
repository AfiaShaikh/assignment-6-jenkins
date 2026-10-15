# Assignment 6 — Jenkins integration with GitHub

This is a standalone project for source checkout and continuous integration.
It contains only the Jenkins assignment. Kubernetes and Helm are not required.

## Start here

1. Extract as `C:\personal\afia\Assignment_6_Jenkins_GitHub`.
2. Create a separate GitHub repository named **assignment-6-jenkins**.
3. Follow `GUIDE.md` for uploading the source, creating a Freestyle job and demonstrating an automatic build.
4. Save your own screenshots under `Evidence/`.

If you already completed Jenkins setup from the earlier combined package, keep that instance running at **http://localhost:8081**. Do not repeat the setup wizard. Upload the files from this new folder to GitHub and use that repository in your Jenkins job.
The supplied Compose file keeps the same project name and Jenkins volume, so future Compose commands from this folder address the same local Jenkins service.

## Files

| Path | Purpose |
| --- | --- |
| app.py / index.html | Small Flask sample application |
| requirements.txt | Application dependency |
| ci/build.sh | Isolated environment, source compilation and application checks |
| Jenkinsfile | Optional Pipeline with checkout, build/check and archived artifacts |
| jenkins/ | Jenkins Docker image with Java, Git and Python, and Compose configuration |
| GUIDE.md | Complete implementation procedure and troubleshooting |
| Submission_Notes.md | Aim, implementation, observations and viva notes |
| Evidence/README.md | Screenshots to capture during your own run |

The required Freestyle job is **GitHub-Jenkins-Demo**. It retrieves branch `main`, runs `sh ci/build.sh` and archives `artifacts/*.txt`. SCM polling demonstrates automatic retrieval after a new GitHub commit. The optional Pipeline is a separate job.

Your application source and Jenkins setup are independent of Assignment 7. Internet is required for initial downloads and GitHub access. This package does not contain a captured successful Jenkins run; record your own execution evidence.

SCM polling demonstration — second commit.

References:
- https://www.jenkins.io/doc/book/installing/docker/
- https://www.jenkins.io/doc/book/pipeline/syntax/
- https://plugins.jenkins.io/git/
