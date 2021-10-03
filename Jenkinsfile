pipeline {
    environment {
        registry = "thecountt/docker-php-todo"
        registryCredential = 'docker-hub-cred'
    }
    agent any
    stages {
        
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

        stage('Push Image') {
            steps{
                script {
                    dcoker.withRegistry( 'https://registry.hub.docker.com/', 'docker-hub-cred' ) {
                        dockerImage.push( 'docker.build registry + ":$BUILD_NUMBER"' )
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