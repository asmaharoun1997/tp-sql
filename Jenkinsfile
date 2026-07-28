pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('List SQL files') {
            steps {
                sh 'ls -la *.sql'
            }
        }
    }
}
