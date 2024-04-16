pipeline {
    agent any 

    environment {
        DOCKER_CREDENTIALS_ID = 'roseaw-dockerhub'
        GITHUB_URL = 'https://github.com/miamioh-cit/225-lab3-8.git'                                    //<------This github URL
        DOCKER_IMAGE = 'my-mongo-express'
        KUBECONFIG = credentials('roseaw-225')                                                          //<------Your MiamiID
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']],
                          userRemoteConfigs: [[url: "${GITHUB_URL}"]]])
            }
        }

        stage('Build Mongo Stateful Set') {
            steps {
                script {                                                                                // Be sure that you have added the mongo-secret.yaml to your cluster before you run your pipeline.
                    docker.build(env.DOCKER_IMAGE)
                    sh 'kubectl apply -f mongo-secret.yaml'
                    sh 'kubectl apply -f mongo.yaml'
                    sh 'kubectl apply -f mongo-configmap.yaml'
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_CREDENTIALS_ID}") {
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push()
                    sh 'kubectl apply -f mongo-express.yaml'
                }
            }
        }
        
 
        stage('Check Kubernetes Cluster') {
            steps {
                script {
                    sh "kubectl get all"
                }
            }
        }
    }
    
    post {
        
        success {
            slackSend color: "good", message: "Build Completed: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
        unstable {
            slackSend color: "warning", message: "Build Unstable: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
        failure {
            slackSend color: "danger", message: "Build Failed: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
    }
}

