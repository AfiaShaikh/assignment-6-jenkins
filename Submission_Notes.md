# Assignment 6 — submission notes

Student name: ____________________

PRN / roll number: ____________________

Date: ____________________


**Title:** Integrate Jenkins with a Git Repository and Automate Source Code Retrieval from GitHub.

**Aim:** Configure Jenkins to retrieve source from GitHub and execute a simple CI build.

**Implementation:** A Docker-hosted Jenkins instance includes Java, Git and Python. Its Freestyle job checks out the main branch, runs the shared build script and archives build metadata. Poll SCM checks for new commits approximately every two minutes. An optional Pipeline stores the same workflow as a Jenkinsfile in the repository.

**Flow:** A developer pushes a commit to GitHub. Jenkins polling notices the changed revision, schedules a build, checks it out into a workspace, creates an isolated Python environment, checks the application and records the build result.

**Observation fields:**

| Item | Actual observation |
| --- | --- |
| Jenkins / Java / Git / Python versions | Fill from your environment |
| Repository and branch | Fill |
| Build #1 / commit / result | Fill |
| Build #2 / commit / trigger / result | Fill |
| Workspace path | Fill |

**Conclusion to complete after execution:** Jenkins retrieved commit ______ from GitHub branch ______. Build ______ completed with result ______. A later commit ______ caused automatic build ______ through SCM polling.


## Viva notes

| Question | Answer |
| --- | --- |
| What is CI? | Automatically integrating and checking source changes so failures are detected early. |
| Jenkins vs GitHub? | GitHub hosts the repository; Jenkins executes automated jobs against its source. |
| Git plugin vs GitHub plugin? | Git plugin performs Git SCM operations; GitHub plugin adds GitHub integration features. Basic public Git checkout can work with the Git plugin alone. |
| Freestyle vs Pipeline? | Freestyle stores steps mainly in job configuration; Pipeline expresses the workflow in code, usually a versioned Jenkinsfile. |
| Poll SCM vs Build periodically? | Poll SCM builds when it finds a new source revision; a periodic schedule builds regardless of changes. |
| Polling vs webhook? | Jenkins periodically asks GitHub for changes; a webhook is a request GitHub sends to a reachable Jenkins endpoint. |
| What does a successful build prove? | The configured checkout and checks passed for that commit; it does not prove the application has no bugs. |
| Why a virtual environment? | It isolates Python packages and avoids system-managed Python installation conflicts. |

Attach screenshots from your own execution.
