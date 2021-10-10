pipeline {
    environment {
        registry = "thecountt/docker-php-todo"
        registryCredential = "docker-hub-cred"
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
    agent any
            steps {
                git branch: 'main', url: 'https://github.com/TheCountt/docker-php-todo.git'
            }
        }


// stage('build image') {
//             steps {
//                 script {
//                     docker.withRegistry('https://registry.hub.docker.com/', 'docker-hub-cred') {
//                         def customImage = docker.build("${image}", 'docker-php-todo/')

// 		     }
// 	     }
//       }
//     }


//         stage('Build') {
//             agent any
// 	            environment {
//                    image = "thecountt/docker-php-todo"
//                    image_tag = "10"
//        }
// }

        stage("Start the app") {
            steps {
                script {
                    docker.withRegistry( '', registryCredential ){
                     sh "cd php-todo"
                     sh "docker-compose up -d --build"
            }
        }
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

    }
}