pipeline {
  agent none
  stages {
    stage('Checkout') {
      agent {
        docker { image 'maven:3-eclipse-temurin-21' }
      }
      steps {
        git branch: 'main', url: '<URL>'
      }
    }
    stage('Test Application') {
      agent {
        docker { image 'maven:3-eclipse-temurin-21' }
      }
      steps {
        sh 'mvn test'
      }
    }
    stage('Build Application') {
      agent {
        docker { image 'maven:3-eclipse-temurin-21' }
      }
      steps {
        sh 'mvn clean package -DskipTests=true'
      }
    }
    stage('Build Container Image') {
      agent { label 'controller' }
      steps {
        sh '<DOCKER_IMAGE_BUILD_COMMAND>'
      }
    }
    stage('Tag Container Image') {
      agent { label 'controller' }
      steps {
        sh '<DOCKER_IMAGE_TAGGING_COMMAND>' // Tagging with build number
        sh '<DOCKER_IMAGE_TAGGING_COMMAND>' // Tagging with latest
      }
    }
    stage('Push Container Image') {
      agent { label 'controller' }
      steps {
        withDockerRegistry(credentialsId: 'docker-registry-credential', url: 'https://index.docker.io/v1/') {
          sh '<DOCKER_IMAGE_PUSH_COMMAND>' // Tagging with build number
          sh '<DOCKER_IMAGE_PUSH_COMMAND>' // Tagging with latest
        }
      }
    }
    stage('Run Container') {
      agent { label 'controller' }
      steps {
        sh 'docker container run --detach --name <CONATINAER_NAME> -p 80:8080 <DOCKER_IMAGE_NAME>:<BUILD_NUMBER>'
      }
    }
  }
}

