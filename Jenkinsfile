pipeline {
    environment {
        registry = "thecountt/docker-php-todo"
        registryCredential = "docker-hub-cred"
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

        
        stage('Cloning Git repository') {
          steps {
                git branch : 'main', url: 'https://github.com/TheCountt/docker-php-todo.git'
            }
        }

        
        stage('Build Image') {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage = docker.build registry + ":$BUILD_NUMBER"
                    }
                }
            }
        }

        
        stage("Start the app") {
            steps {
                sh "docker-compose --version"
                sh "docker-compose up -d"
                    
            }
        }


        stage("Test endpoint and Push Image to registry") {
            steps {
                script {
                        while (true) {
                        def response = httpRequest "http://localhost:8000"
                        if (response.status == 200) {
                            docker.withRegistry( '', registryCredential ) {
                            dockerImage.push()
                        }
                        break 
                    }
                }
            }
        }
    }
        // stage('Push Image') {
        //     steps{
        //         script {
        //             docker.withRegistry( '', registryCredential ) {
        //                 dockerImage.push()
        //             }
        //         }
        //     }
        // }

        
        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}