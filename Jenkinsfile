pipeline {
    agent any
    environment {
        CONTAINER_NAME = "bank-jenkins"
        IMAGE = "${CONTAINER_NAME}:latest"
        DOCKERFILE = "./Dockerfile.jenkins"
        PORT_MAPPING = "-p 3001:3000"
        VOLUME_MAPPING = "-v ${WORKSPACE}/artifact:/app/artifact"
    }
    stages {
        stage('Cleanup') {
            steps {
                script {
                    // Stop and remove the container if it already exists
                    sh """
                        if [ \$(docker ps -aq -f name=${CONTAINER_NAME}) ]; then
                            docker stop ${CONTAINER_NAME} || true
                            docker rm ${CONTAINER_NAME} || true
                        fi
                    """
                }
            }
        }
        stage('Prepare Workspace') {
            steps {
                script {
                    // Ensure Jenkins has permission to write to the workspace
                    sh "mkdir -p ./artifact"
                    // sh "chmod 777 ./artifact"
                }
            }
        }
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ruchapol/test-goland-api-jenkin'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    sh "docker build -t ${IMAGE} -f ${DOCKERFILE} ."
                }
            }
        }
        stage('Run Docker Container For Build') {
            steps {
                script {
                    // Run the Docker container with volume mapping
                    
                    sh "docker run --name ${CONTAINER_NAME} ${PORT_MAPPING} ${VOLUME_MAPPING} ${IMAGE} /bin/bash -c \"cp ./main ./artifact/main\""
                    
                    // Stop and remove the container after the process
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                }
            }
        }
        stage('List Artifact') {
            steps {
                script {
                    sh "ls -l ./artifact"
                }
            }
        }
    }
}
