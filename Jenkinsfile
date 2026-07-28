pipeline {
    agent none

    environment {
        DB_PASSWORD = '1234'
        NETWORK_NAME = 'tp-net'
        DB_CONTAINER = 'mariadb-server'
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
                sh 'docker network create $NETWORK_NAME || true'
                sh 'docker rm -f $DB_CONTAINER || true'
                sh 'docker run -d --name $DB_CONTAINER --network $NETWORK_NAME -e MARIADB_ROOT_PASSWORD=$DB_PASSWORD mariadb:11'
                sh '''
                    for i in $(seq 1 15); do
                        docker exec $DB_CONTAINER mariadb-admin ping -uroot -p$DB_PASSWORD --silent && break
                        echo "En attente de MariaDB..."
                        sleep 2
                    done
                '''
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
                    args "--network $NETWORK_NAME"
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
                    args "--network $NETWORK_NAME"
                }
            }
            steps {
                sh 'mariadb -h $DB_CONTAINER -uroot -p$DB_PASSWORD < select-db.sql'
            }
        }
    }

    post {
        always {
            node('') {
                sh 'docker rm -f $DB_CONTAINER || true'
                sh 'docker network rm $NETWORK_NAME || true'
            }
        }
    }
}
