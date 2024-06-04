pipeline {
    agent any
    environment {
        CONTAINER_NAME = "test-goland-api-jenkin"
        IMAGE = "${CONTAINER_NAME}:latest"
        DOCKERFILE = "./Dockerfile.jenkins"
    }
    stages {
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
                    sh "docker run -d --name ${CONTAINER_NAME} -p 3001:3000 ${IMAGE}"
                    
                    // Execute commands inside the container (optional)
                    sh "docker exec ${CONTAINER_NAME} echo 'Hello World'"
                    sh "docker exec ${CONTAINER_NAME} ls -l /app"
                    // Uncomment the next line if you want to run the main application
                    sh "docker exec ${CONTAINER_NAME} /app/main"
                }
            }
        }
    }
}
