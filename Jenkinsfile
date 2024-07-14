pipeline {
    agent any
    environment {
        CONTAINER_NAME = "bank-jenkins"
        IMAGE = "${CONTAINER_NAME}:latest"
        DOCKERFILE = "./Dockerfile.jenkins"
        // PORT_MAPPING = "-p 3001:3000"
        VOLUME_MAPPING = "-v ${WORKSPACE}/artifact:/app/artifact"
        REMOTE_USER = "jenkins"
        REMOTE_HOST = "localhost"
        REMOTE_SSH_PORT = "-p 2224"
        REMOTE_SCP_PORT = "-P 2224"
        REMOTE_PROJECT_PATH = "/home/jenkins/be-api"
        REMOTE_RUN_SCRIPT_PATH = "/home/jenkins/be-api/run-2.sh"
        // ${REMOTE_USER}@${REMOTE_HOST}
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

                    sh "ssh ${REMOTE_SCP_PORT} ${REMOTE_USER}@${REMOTE_HOST} \"${REMOTE_RUN_SCRIPT_PATH} stop\""
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
                    
                    sh "docker run --name ${CONTAINER_NAME} ${VOLUME_MAPPING} ${IMAGE} /bin/bash -c \"cp ./main ./artifact/main\""
                    
                    // Stop and remove the container after the process
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                }
            }
        }
        stage('Transfer File') {
            steps {
                script {
                    sh "ls -l ./artifact"
                    sh "scp ${REMOTE_SCP_PORT} ./artifact/main ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PROJECT_PATH}"
                    sh "scp ${REMOTE_SCP_PORT} ./etc/run-2.sh ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PROJECT_PATH}"
                }
            }
        }
        stage('Run') {
            steps {
                script {
                    sh "ssh ${REMOTE_SCP_PORT} ${REMOTE_USER}@${REMOTE_HOST} \"${REMOTE_RUN_SCRIPT_PATH} start\""
                }
            }
        }
    }
}
