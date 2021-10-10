pipeline {
    environment {
        registry = "thecountt/docker-php-todo"
        registryCredential = "docker-hub-cred"
        PATH = "$PATH:/usr/local/bin"
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

        
        // stage('Build Image') {
        //     steps{
        //         script {
        //             dockerImage = docker.build registry + ":$BUILD_NUMBER"
        //         }
        //     }
        // }

        
        stage("Start the app") {
            steps {
                echo "PATH is: $PATH"
                sh "/usr/local/bin/docker-compose up -d"
		    }
        }
     	
        stage("Test endpoint") {
            steps {
                script {
                    while (true) {
                        def response = httpRequest 'http://localhost:8000'

                        if (http.responseCode == 200) {
                        sh 'echo "HttpRequest Successsful"'

                        }
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