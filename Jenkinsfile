pipeline {
    agent none

    environment {
        DB_PASSWORD  = '1234'
        NETWORK_NAME = 'tp-net'
        DB_CONTAINER = 'mariadb-server'
        IMAGE_NAME   = 'asmaharoun97/tp-sql'
    }

    stages {

        stage('Checkout') {
            agent any
            steps {
                checkout scm
            }
        }

        stage('List SQL files') {
            agent any
            steps {
                sh 'ls -la *.sql'
            }
        }

        stage('Start MariaDB') {
            agent any
            steps {
                sh 'docker rm -f $DB_CONTAINER || true'
                sh 'docker run -d --name $DB_CONTAINER --network $NETWORK_NAME -e MARIADB_ROOT_PASSWORD=$DB_PASSWORD mariadb:11'
                sh 'sleep 10'
            }
        }

        stage('Init DB') {
            agent {
                docker {
                    image 'mariadb:11'
                    args "--network $NETWORK_NAME"
                }
            }
            steps {
                sh 'mariadb -h $DB_CONTAINER -uroot -p$DB_PASSWORD < init-db.sql'
            }
        }

        stage('Insert DB') {
            agent {
                docker {
                    image 'mariadb:11'
                }
            }
            steps {
                sh 'mariadb -h $DB_CONTAINER -uroot -p$DB_PASSWORD < insert-db.sql'
            }
        }

        stage('Select DB') {
            agent {
                docker {
                    image 'mariadb:11'
                }
            }
            steps {
                sh 'mariadb -h $DB_CONTAINER -uroot -p$DB_PASSWORD < select-db.sql'
            }
        }

        stage('Build Docker image') {
            agent any
            steps {
                sh 'docker build -t $IMAGE_NAME:1 .'
            }
        }

        stage('Push sur Docker Hub') {
            agent any
            environment {
                DOCKERHUB_CREDENTIALS = credentials('dockerhub-sql')
            }
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push $IMAGE_NAME:1'
            }
        }
    }
}
