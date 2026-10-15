pipeline {
    agent any
    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    triggers { pollSCM('H/2 * * * *') }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git log -1 --oneline'
            }
        }
        stage('Build and Check') {
            steps { sh 'sh ci/build.sh' }
        }
    }
    post {
        always { archiveArtifacts artifacts: 'artifacts/*.txt', allowEmptyArchive: true }
        success { echo 'GitHub source checked out and application checks passed.' }
        failure { echo 'Build failed. Inspect Console Output for the failing command.' }
    }
}
