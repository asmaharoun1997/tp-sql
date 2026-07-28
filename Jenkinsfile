pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Init DB') {
            agent {
                docker {
                    image 'mariadb:11'
                    args '--network tp-net'
                }
            }
            steps {
                sh 'mariadb -h mariadb-server -uroot -p1234 < init-db.sql'
            }
        }
    }
}
