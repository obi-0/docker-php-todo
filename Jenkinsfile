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
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }

        
        stage("Start the app") {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        echo "PATH is: $PATH"
                        sh "docker-compose --version"
                        sh "docker-compose up -d"
                    }
		        }
            }
        }
        
        stage("Test endpoint and Push Image") {
            steps {
                script {
                        while (true) {
                        def response = httpRequest "http://localhost:8000"
                        println("Status: "+response.status)
                        println("Content: "+response.content)
                        if (response.status == 200) {
                            docker.withRegistry( '', registryCredential ) {
                            dockerImage.push()
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
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}