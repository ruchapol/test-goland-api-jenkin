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
                    // Run the Docker container
                    sh "docker run -d --name ${CONTAINER_NAME} -p 3306:3306 ${IMAGE}"
                    
                    // Execute commands inside the container
                    sh "docker exec ${CONTAINER_NAME} echo 'Hello World'"
                    sh "docker exec ${CONTAINER_NAME} ls -l /app"
                    // Uncomment the next line if you want to run the main application
                    // sh "docker exec ${CONTAINER_NAME} /app/main"
                    
                    // Stop and remove the container after use
                    sh "docker stop ${CONTAINER_NAME}"
                    sh "docker rm ${CONTAINER_NAME}"
                }
            }
        }
    }
}
