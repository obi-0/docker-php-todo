# PHP-TODO Application Containerization using Docker

- Download or clone php-todo repository using `wget`(and unzip it) or `git clone`

![{D9F51F4D-6434-4212-860E-E12F75E0DEF4} png](https://user-images.githubusercontent.com/76074379/137538985-828c6b19-fe13-43c7-8e0c-44fb44455dc3.jpg)

![{DE7ACA34-86E0-4EBA-8F71-0E86E4B6E4D4} png](https://user-images.githubusercontent.com/76074379/137539144-d7914bad-072c-4b60-8d1e-7672221c4926.jpg)


- Write a dockerfile for php-todo app and save it in the php-todo directory
```
FROM php:7.4.24-apache
LABEL Dare=dare@zooto.io

#install zip, unzip extension, git, mysql-client
RUN apt-get update --fix-missing && apt-get install -y \
  default-mysql-client \
  git \
  unzip \
  zip \
  curl \
  wget
  
# Install docker php dependencies
RUN docker-php-ext-install pdo_mysql mysqli

# Add config files and binary file and enable webserver
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
COPY start-apache /usr/local/bin
RUN a2enmod rewrite

RUN curl -sS https://getcomposer.org/installer |php && mv composer.phar /usr/local/bin/composer

# Copy application source
COPY . /var/www
RUN chown -R www-data:www-data /var/www

EXPOSE 80

CMD ["start-apache"]
```
![{6A42FDDB-8B8D-4009-BD0F-4487E92250E7} png](https://user-images.githubusercontent.com/76074379/137537100-b2e6264f-0e10-4b97-b5f2-b34c37e5921f.jpg)

- Create a docker-compose.yml in the php-todo directory and paste the code below:

```
version: "3.9"
services:
 app:
    build:
      context: .
    container_name: php-website
    network_mode: tooling_app_network
    restart: unless-stopped
    volumes:
      - app:/php-todo
    ports:
      - "${APP_PORT}:80"
    depends_on:
      - db

 db:
    image: mysql/mysql-server:latest
    container_name: php-db-server
    network_mode: tooling_app_network
    hostname: "${DB_HOSTNAME}"
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: "${DB_DATABASE}"
      MYSQL_USER: "${DB_USERNAME}"
      MYSQL_PASSWORD: "${DB_PASSWORD}"
      MYSQL_ROOT_PASSWORD: "${DB_ROOT_PASSWORD}"
    
    ports:
      - "${DB_PORT}:3306"

    volumes:
      - db:/var/lib/mysql

volumes:
  app:
  db:
  ```
![{2CB63BFB-700B-45F6-B8F7-D7CA37EC2162} png](https://user-images.githubusercontent.com/76074379/137538344-9d176fa3-86f1-4501-a776-4c92a8b884b2.jpg)


![{0E92F415-2FD2-4B80-8668-C99478FFFF57} png](https://user-images.githubusercontent.com/76074379/137549207-c6d38474-94a9-482c-9034-fcf61a3555a3.jpg)



- Update the `.env` file
```
APP_PORT=8000
APP_ENV=local
APP_DEBUG=true
APP_KEY=SomeRandomString
APP_URL=http://localhost

DB_HOSTNAME=mysqlserverhost
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=sePret^1
DB_ROOT_PASSWORD=Qwerty123@
DB_PORT=3306

CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```
![{935414C1-7099-4F52-9EBF-24FA2D1B85B8} png](https://user-images.githubusercontent.com/76074379/137537533-8e6079a2-2aa6-46c4-95cc-6f91b1e90290.jpg)

- Make sure you change directory to php-todo directory. Build image using this command:
```
docker build -t php-todo:latest .
```

- Make sure you change directory to php-todo directory. Deploy the containers:
```
docker-compose up -d
```
![{6E56E0A6-D362-4ED3-ABB6-C6B097B2BF50} png](https://user-images.githubusercontent.com/76074379/137554026-2a2d501d-98ac-4d81-88d9-d629acb1c83e.jpg)

- We are going to open a docker hub account if we do not have already. Go to  your bbroswer and open a dockerhub account
- On your terminal/editor, create a new tag for the image you want to push using the
proper syntax.

```
docker tag php-todo:latest thecountt/php-todo:1.0.0
```
![{A380BC13-5CC6-40ED-A34C-00FCC569E189} png](https://user-images.githubusercontent.com/76074379/137539643-637ca9c4-7737-433b-97c5-688db1dfed1d.jpg)
- Run this command to see the image with the newly created tag

```
docker ps -a
```

Login to your dockerhub account and type in your credentials

```
docker login
```
![{C8CA5105-2713-4511-9AEC-A46B41BFB7E1} png](https://user-images.githubusercontent.com/76074379/137540418-2a9d026d-89fb-4276-968d-95961566f74d.jpg)

- Push the docker image from the local machine to the dockerhub repository
```
docker push thecountt/php-todo:1.0.0
```
![{80B6ABB2-FF9E-48E7-84CD-6FECF1CD5143} png](https://user-images.githubusercontent.com/76074379/137539999-fa21ec99-e1ac-4c4c-a609-bb666eaafa2f.jpg)

## CI/CD with Jenkins (Machine or Container)

### 1. Using Local Machine

- Run the following command in your home directory to install java runtime:
```
sudo apt update -y
sudo apt install openjdk-11-jdk
```
- Run the following commands to install jenkins:
```
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
```

#### Unlocking Jenkins
- When you first access a new Jenkins instance, you are asked to unlock it using an automatically-generated password.

- Browse to http://localhost:8080 (or whichever port you configured for Jenkins when installing it) and wait until the Unlock Jenkins page appears and you can use

`sudo cat /var/lib/jenkins/secrets/initialAdminPassword` to print the password on the terminal.

![{19CD1653-CEAF-4F90-81E5-256330E7448E} png](https://user-images.githubusercontent.com/76074379/137549596-27a14fa9-9a86-4039-bfc4-8be9adb1a76a.jpg)

#### Jenkins Pipeline
- First we will install the plugins needed
  - On the Jenkins Dashboard, click on `Manage Jenkins` and go to `Manage Plugins`.
  - Search and install the following plugins:
    - Blue Ocean
    - Docker
    - Docker Compose Build Steps
    - HttpRequest
    
- Create a new repository in your dockerhub account to push image into

![{6782567F-DE5D-4C06-83D8-07E392117EFE} png](https://user-images.githubusercontent.com/76074379/137549931-c60f0b5b-4fb8-4fa1-af38-33404263e198.jpg)

- We need to create credentials that we will reference so as to be able to push our image to the docker hub repository

  - Click on  `Manage Jenkins` and go to `Manage Credentials`.
  - Click on `global`
  - Click on `add credentials` and choose `username with password`
  - Input your dockerhub username and password

![{F069636D-EE64-4502-B73A-781C822FC9F8} png](https://user-images.githubusercontent.com/76074379/137545904-b1fa454c-cb1d-4866-bd97-157fd7a4f143.jpg)

- Create a Jenkinsfile in the php-todo directory that will build image from context in the github repo; deploy application; make http request to see if it returns the status code 200 & push the image to the dockerhub repository and finally clean-up stage where the  image is deleted on the Jenkins server

```
pipeline {
    environment {
    REGISTRY = credentials('docker-hub-cred-2')
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
                                sh "docker push thecountt/docker-php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
                            break 
                        }
                    }
                }
            }
        }
 
        stage ("Remove images") {
            steps {
                sh "docker rmi thecountt/docker-php-todo:${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
            }
        }
    }
}
```
![{6683D9F0-2C19-470D-8389-F1A0BAFE7751} png](https://user-images.githubusercontent.com/76074379/137546716-7f0ddf18-b05f-45cf-b95c-6e2dfac56a91.jpg)


**Note: the docker compose package is in `usr/bin`, that is why it is specified in the jenkinsfile**

- Click on "Scan Repository Now" 

- A build will start. The pipeline should be successful now


![{1E38ABFB-5A45-4D94-A9C6-B95015D8E35F} png](https://user-images.githubusercontent.com/76074379/137547662-f7d58d0c-c95a-465c-ac3d-952b235ec1d4.jpg)

![{C9FB3404-990A-4F72-9F98-893661BE041F} png](https://user-images.githubusercontent.com/76074379/137547562-13fb1d7f-05ab-4dde-8cf4-13aed5e22ab0.jpg)

#### Github Webhook
We need to create  a webhook so that Jenkins will automatically pick up changes in our github repo and trigger a build instead of havinf to click "Scan Repository Now" all the time on jenkins. However, we cannot connect to our localhost because it i in a private network. We will have to use a proxy server. We will map our localhost to our proxy server. The proxy server will then generate a URL for us. We will input that URL in github webhooks so any changes we make to our github repo will automatically trigger a build.

We will use **localtunnel**, a nodejs proxy server

- Install nodejs npm nodejs-legacy if you do not have it installed already on your local machine
```
sudo apt install nodejs npm nodejs-legacy
```

- Install Localtunnel

```
npm install -g localtunnel
```
![{47A4268B-D9A9-453A-A7AE-26A6D947006B} png](https://user-images.githubusercontent.com/76074379/137554552-04197c7f-de48-4c4a-af8d-826b95715909.jpg)

- Run the following command to get our unique url mapped to our jenkins port

```
lt --port 8080 --subdomain docker-projects
```
![{984D3080-5EDD-463C-8421-CE5D7DAF728A} png](https://user-images.githubusercontent.com/76074379/137554885-5712c622-89d5-4d98-a1d1-5c596316d350.jpg)

- Go to github repository and click on `Settings`
	- Click on `Webhooks`
	- Click on `Add Webhooks`
	- Input the generated URL with /postreceive as shown in the Payroad URL space
	- Select application/json as the Content-Type
	- Click on `Add Webhook` to save the webhook

![{EF2FCB11-2154-44E8-BF4F-7F724E5DA095} png](https://user-images.githubusercontent.com/76074379/137589297-5b6e45d5-1dc6-40a7-a10b-294c951ce82f.jpg)

- Go to your terminal and change something in your jenkinsfile and save and push to your github repo. If everything works out fine, this will trigger a build which you can see on your Jenkins Dashboard.

![{C5521131-DCAF-4DFB-A3FC-36D6770938D6} png](https://user-images.githubusercontent.com/76074379/137589378-1c02fab0-e171-4b14-b8e7-65b9416a87f4.jpg)

![{1739C86D-67AC-4BC6-B48E-7D2CBA9685A8} png](https://user-images.githubusercontent.com/76074379/137589448-187d860b-852e-4862-a0e5-05be21b5f5b3.jpg)


**Note: Your localtunnel generated URL might be unable to load on your browser if you do not specify the HTTPS port in the URL. So you may do this `generated URL:443 e.g https://docker-experiment.loca.lt:443. Though, it is strongly adviced never to use this strategy for anything that has personally identifying information or anything sensitive.
The best way to use localtunnel is to build your own server because that is far safer. To do that, click [her](https://github.com/localtunnel/server#deploy)**

### 2. Using Docker Container
- Create a directory and name it `jenkins` and change into the directory.
- Create a bridge network in Docker using the following docker network create command. We will use the network we have created earlier(tooling_app_network)

- In order to execute Docker commands inside Jenkins nodes, download  the `docker:dind` Docker image so we can use it in our docker-compose file we will create:

```
docker pull docker:dind
```

- Customise official Jenkins Docker image, by executing the two steps below:

    a. Create Dockerfile with the following content:

```
FROM jenkins/jenkins:2.303.1-jdk11
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN curl -L \  
  "https://github.com/docker/compose/releases/download/v2.0.0-beta.6/docker-compose-$(uname -s)-$(uname -m)" \  
  -o /usr/local/bin/docker-compose \  
  && chmod +x /usr/local/bin/docker-compose
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.0 docker-workflow:1.26"

```

   b. Build a new docker image from this Dockerfile and assign the image a meaningful name, e.g. "myjenkins-blueocean:1.1":
```
docker build -t myjenkins-blueocean:1.1 . 
```
- Create a file and name it jenkins.yml. Paste the code below:

```
version: "3.9"
services:
    docker:
        image: "docker:dind"
        container_name: jenkins-docker
        privileged: true
        network_mode: tooling_app_network
        
        environment:
            - DOCKER_TLS_CERTDIR=/certs
            - DOCKER_DRIVER=overlay2
        volumes:
            - 'jenkins-docker-certs:/certs/client'
            - 'jenkins-data:/var/jenkins_home'
        ports:
            - "2376:2376"

    myjenkins-blueocean:
        image: "myjenkins-blueocean:1.1"
        container_name: jenkins-blueocean
        network_mode: tooling_app_network
        environment:
            - DOCKER_HOST=tcp://docker:2376
            - DOCKER_CERT_PATH=/certs/client
            - DOCKER_TLS_VERIFY=1
        ports:
            - "8080:8080"
            - "50000:50000"
        
        volumes:
            - "jenkins-data:/var/jenkins_home"
            - "jenkins-docker-certs:/certs/client:ro"
        
volumes:
   docker:
   myjenkins-blueocean:
   jenkins-docker-certs:
   jenkins-data:
```
- Spin up jenkins container:
```
docker-compose -f jenkins.yml up -d
```

### Unlocking Jenkins
- When you first access a new Jenkins instance, you are asked to unlock it using an automatically-generated password.

- Browse to http://localhost:8080 (or whichever port you configured for Jenkins when installing it) and wait until the Unlock Jenkins page appears

- If you are running Jenkins in Docker using the official jenkins/jenkins image you can use:

`sudo docker exec jenkins-blueocean cat /var/jenkins_home/secrets/initialAdminPassword` to print the password in the console without having to exec into the container.


### Jenkins Pipeline

- Download plugins: **HttpRequest; Docker; Docker Compose Build Steps**

- Create a new repository in your dockerhub account to push image into

- Create a Jenkinsfile in the php-todo directory. Write a Jenkinsfile that will pick up the build context from the referenced github repo branch, deploy application; make http request to see if it returns the status code 200 & push the image to the dockerhub repository and finally clean-up stage where the image is deleted on the Jenkins server


```
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

        
        stage('Build Image') {
            steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }

        
        stage("Start the app") {
            steps {
	      sh 'docker-compose --version'
              sh 'docker-compose -f jenkins.yml up -d'
            }
    }	
      
      stage("Test endpoint") {
            steps {
                script {
                    while (true) {
                        def response = httpRequest 'http://localhost:8000'

                        if (http.responseCode == 200) {
                        sh 'echo "httpRequest Successsful"'
                        break
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
```


- Create a  Pipeline using Blue Ocean.

- If you run a build, the pipeline will fail because we have not configured our dockerhub
(registryCredential) in jenkins.
  a. Go to jenkins home, click on your pipeline. On the left-hand side, click on "configure"
  b. Click on "Properties".
  c. Fill the "Docker registry URL"
  c. In the "Registry credentials", click on "Add". Put your dockerhub account credentials
     (Username and Password) and save it.

- We need to change the name of the path of the Jenkinsfile correctly on Jenkins or Jenkins pipeline will not run
	a. Click on `Dashboard`
	b. To the left, click on `Configure` and Scroll down to `Build Confugration` and make sure the path to the Jenkinsfile and is correct.
	c. Click 'Save` at the bottom.

- Click on "Scan Repository"

- Run a build now. The  pipeline should be successful

- Create a github webhook so jenkins can automatically pickup changes and run a build. But we cannot connect to a localhost in a private network. So we will use a proxy server called **localtunnel.**

- Create a folder and name it localtunnel. Create a file in the folder and name it Dockerfile.lt
- Paste the following code in the Dockerfile.lt
```
FROM node:lts-alpine3.14

RUN npm install -g localtunnel

ENTRYPOINT ["lt"]
```

- Go to the jenkins directory and in our jenkins.yml file, paste the localtunnel block of code into the file

```
version: "3.9"
services:
    docker:
        image: "docker:dind"
        container_name: jenkins-docker
        privileged: true
        network_mode: tooling_app_network
        
        environment:
            - DOCKER_TLS_CERTDIR=/certs
            - DOCKER_DRIVER=overlay2
        volumes:
            - 'jenkins-docker-certs:/certs/client'
            - 'jenkins-data:/var/jenkins_home'
        ports:
            - "2376:2376"

    myjenkins-blueocean:
        image: "myjenkins-blueocean:1.1"
        container_name: jenkins-blueocean
        network_mode: tooling_app_network
        environment:
            - DOCKER_HOST=tcp://docker:2376
            - DOCKER_CERT_PATH=/certs/client
            - DOCKER_TLS_VERIFY=1
        ports:
            - "8080:8080"
            - "50000:50000"
        
        volumes:
            - "jenkins-data:/var/jenkins_home"
            - "jenkins-docker-certs:/certs/client:ro"
        

    localtunnel:
        build:
          context: ~/localtunnel
          dockerfile: Dockerfile.lt
        network_mode: tooling_app_network
        
        command: --local-host myjenkins-blueocean --port 8080 --subdomain jenkins-container

volumes:
   docker:
   myjenkins-blueocean:
   jenkins-docker-certs:
   jenkins-data:
```

- Go to the Jenkins dashboard and click on "Scan Repository Now" to trigger a build
- Go to your terminal and run command 	`docker ps -a`. Copy the name of the or ID of the localtunnel.
- Pass the name or the ID of the localtunnel container in this command below to get the generated URL
```
docker logs <name-of-container or ID>
```
- Copy the generated URL and load it on a browser to see if it is reachable
- Go to github repository and click on `Settings`
	- Click on `Webhooks`
	- Click on `Add Webhooks`
	- Input the generated URL with /postreceive as shown in the Payroad URL space
	- Select application/json as the Content-Type
	- Click on `Add Webhook` to save the webhook
- Go to your terminal and change something in your jenkinsfile and save and push to your github repo. If everything works out fine, this will trigger a build which you can see on your Jenkins Dashboard.

**Note: Your localtunnel generated URL might be unable to load on your browser if you do not specify the HTTPS port in the URL. So you may do this `generated URL:443 e.g https://docker-experiment.loca.lt:443. Though, it is strongly adviced never to use this strategy for anything that has personally identifying information or anything sensitive.
The best way to use localtunnel is to build your own server because that is far safer. To do that, click [here](https://github.com/localtunnel/server#deploy)**


