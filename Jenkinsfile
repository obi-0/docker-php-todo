pipeline {
    environment {
        registry = "thecountt/docker-php-todo"
        registryCredential = 'docker-hub-cred'
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

        stage('Cloning Git repository') {
          steps {
                git branch : 'main', url: 'https://github.com/TheCountt/docker-php-todo.git'
            }
        }

        stage('Build Image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }

        stage("Start the app") {
            steps {
                sh "docker-compose up -d"
            }
        }


        stage("Test endpoint") {
            steps {
                script {
                    while (true) {
                        def response = httpRequest 'http://localhost:8000'

                        if (http.responseCode == 200) {
                        response = new JsonSlurper().parseText(http.inputStream.getText('UTF-8'))
                        }
                        else {
                        response = new JsonSlurper().parseText(http.errorStream.getText('UTF-8'))
                         }

                        println "response: ${response}"
                    }
                }
            }
        }


        stage('Push Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}