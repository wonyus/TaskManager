pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME_COORDINATOR = 'wonyus/taskmanager-coordinator'
        DOCKER_IMAGE_NAME_SCHEDULER = 'wonyus/taskmanager-scheduler'
        DOCKER_IMAGE_NAME_WORKER = 'wonyus/taskmanager-worker'
        DOCKER_REGISTRY_CREDENTIALS = 'docker-credential'
        DOCKER_REGISTRY_URL = 'https://registry.hub.docker.com'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    buildDockerImageCoordinator("${env.GIT_COMMIT}")
                    buildDockerImageScheduler("${env.GIT_COMMIT}")
                    buildDockerImageWorker("${env.GIT_COMMIT}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(url: "${DOCKER_REGISTRY_URL}", credentialsId: "${DOCKER_REGISTRY_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE_NAME_COORDINATOR}:${env.GIT_COMMIT}").push()
                        docker.image("${DOCKER_IMAGE_NAME_SCHEDULER}:${env.GIT_COMMIT}").push()
                        docker.image("${DOCKER_IMAGE_NAME_WORKER}:${env.GIT_COMMIT}").push()
                        docker.image("${DOCKER_IMAGE_NAME_COORDINATOR}:latest").push()
                        docker.image("${DOCKER_IMAGE_NAME_SCHEDULER}:latest").push()
                        docker.image("${DOCKER_IMAGE_NAME_WORKER}:latest").push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Build and push to repo successful!'
        }
        failure {
            echo 'Build or push to repo failed!'
        }
    }
}

def buildDockerImageCoordinator(tag) {
    sh "docker build -t ${DOCKER_IMAGE_NAME_COORDINATOR}:${tag} -t ${DOCKER_IMAGE_NAME_COORDINATOR}:latest -f ${WORKSPACE}/00-coordinator-kube-dockerfile ."
}

def buildDockerImageScheduler(tag) {
    sh "docker build -t ${DOCKER_IMAGE_NAME_SCHEDULER}:${tag} -t ${DOCKER_IMAGE_NAME_SCHEDULER}:latest -f ${WORKSPACE}/00-scheduler-kube-dockerfile ."
}

def buildDockerImageWorker(tag) {
    sh "docker build -t ${DOCKER_IMAGE_NAME_WORKER}:${tag} -t ${DOCKER_IMAGE_NAME_WORKER}:latest -f ${WORKSPACE}/00-worker-kube-dockerfile ."
}
