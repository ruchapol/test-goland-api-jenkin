CONTAINER_NAME = "test-goland-api-jenkin"
IMAGE = "${CONTAINER_NAME}:latest"
DOCKERFILE = "./Dockerfile"


pipeline {
    agent any
    

    stages {
        stage('Deploy') {
            steps {
                git branch: 'main', url: 'https://github.com/ruchapol/test-goland-api-jenkin'
                
                script {
                    
                    def customImage = docker.build("${CONTAINER_NAME}:latest", "-f ${DOCKERFILE} .")
                    

                    customImage.inside {
                        echo 'Hello World'
                        sh "ls"
                        sh "./main"
                    }
                }
            }
        }
    }
}