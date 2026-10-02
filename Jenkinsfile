LDpipeline {
    agent none
    stages {
        stage('Checkout') {
            agent {
                docker { image 'maven:3-eclipse-temurin-21' }
            }
            steps {
                git branch: 'main', url: 'https://github.com/kangyoungsoo-jpg/source-maven-java-spring-hello-webapp.git'
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
                sh 'docker image build -t my-tomcat .'
            }
        }
        stage('Tag Container Image') {
            agent { label 'controller' }
            steps {
                sh 'docker image tag my-tomcat kangdidkr08/my-tomcat:${BUILD_NUMBER}' // Tagging with build number
                sh 'docker image tag my-tomcat kangdidkr08/my-tomcat:latest' // Tagging with latest
            }
        }
	stage('Push Container Image') {
            agent { label 'controller' }
            steps {
                withDockerRegistry(credentialsId: 'docker-registry-credential', url: 'https://index.docker.io/v1/') {
                    // v1을 ${BUILD_NUMBER}로 수정하여 태그 단계와 일치시킴
                    sh 'docker image push kangdidkr08/my-tomcat:${BUILD_NUMBER}'
                    sh 'docker image push kangdidkr08/my-tomcat:latest' 
                }
            }
        }
        stage('Run Container') {
            agent { label 'controller' }
            steps {
		ansiblePlaybook(playbook: 'myweb-playbook.yaml')
            }
        }
    }
}
