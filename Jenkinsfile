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
                sh "/usr/bin/docker run --network tooling_app_network --name php-website -p 8000:80 -d -it thecountt/php-todo:1.0.0"
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