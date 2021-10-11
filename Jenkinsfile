pipeline {
    environment {
    REGISTRY = "docker-hub-cred-2"
    PATH = "$PATH:/usr/bin"

    }
    
   
    agent any

    stages {

        stage('Initial Cleanup') {
            steps {
                dir("${WORKSPACE}") {
                deleteDir()
                }
            }
        }
  
        stage('Checkout SCM') {
            steps {
                git branch: 'main', url: 'https://github.com/TheCountt/docker-php-todo.git'
            }
        }
        
        stage('Build image') {
            steps {
                sh "docker build -t thecountt/docker-php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER} ."
            }
        }
        stage("Start application") {
            steps {
                sh "docker-compose --version"
                sh "docker-compose up -d"
            }
        }
        stage("Test Endpoint and Push Image to Registry") {
            steps {
                script {
                    while (true) {
                        def response = httpRequest 'http://localhost:8000'
                        if (response.status == 200) {
                           withCredentials([usernameColonPassword(credentialsId: '', variable: 'Registry')]) {
                                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
                                sh "docker push thecountt/docker-php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
                            }
                            break 
                        }
                    }
                }
            }
        }
 
        stage ("Remove images") {
            steps {
                sh "docker system prune -af"
            }
        }
    }
}