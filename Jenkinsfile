pipeline {
    agent any
    environment {
        CONTAINER_NAME = "test-goland-api-jenkin"
        IMAGE = "${CONTAINER_NAME}:latest"
        DOCKERFILE = "./Dockerfile.jenkins"
        PORT_MAPPING = "3001:3000 2226:22"
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
        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container in detached mode
                    sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT_MAPPING} ${IMAGE}"
                    
                    // Execute commands inside the container (optional)
                    sh "docker exec ${CONTAINER_NAME} echo 'Hello World'"
                    sh "docker exec ${CONTAINER_NAME} ls -l /app"
                }
            }
        }
    }
}
