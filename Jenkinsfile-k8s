pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: maven
    image: maven:3-eclipse-temurin-21
    command:
    - sleep
    args:
    - infinity
  - name: buildah
    image: quay.io/buildah/stable:v1
    command:
    - sleep
    args:
    - infinity
    securityContext:
      privileged: true
    volumeMounts:
    - name: registry-credentials
      mountPath: /root/.docker
  volumes:
  - name: registry-credentials
    secret:
      secretName: docker-hub-credential
      items:
      - key: .dockerconfigjson
        path: config.json
'''
        }
    }
    environment {
        REGISTRY    = 'docker.io'
        USERNAME    = 'kangdidkr08'
        IMAGE_NAME  = 'myapp'
        DOCKERFILE  = 'Dockerfile'
        IMAGE_TAG   = "${REGISTRY}/${USERNAME}/${IMAGE_NAME}"
    }
    stages {
        stage('Checkout') {
            steps {
                container('maven') {
                    git branch: 'main', url: 'https://github.com/kangyoungsoo-jpg/source-maven-java-spring-hello-webapp.git'
                }
            }
        }
        stage('Test Application') {
            steps {
                container('maven') {
                    sh 'mvn test'
                }
            }
        }
        stage('Build Application') {
            steps {
                container('maven') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }
        stage('Build Container Image') {
            steps {
                container('buildah') {
                    sh """
                        buildah build -f ${DOCKERFILE} \
                          -t ${IMAGE_TAG}:${BUILD_NUMBER} \
                          -t ${IMAGE_TAG}:latest .
                    """
                }
            }
        }
        stage('Push Container Image') {
            steps {
                container('buildah') {
                    sh """
                        buildah push --authfile /root/.docker/config.json ${IMAGE_TAG}:${BUILD_NUMBER}
                        buildah push --authfile /root/.docker/config.json ${IMAGE_TAG}:latest
                    """
                }
            }
        }
    }
}
