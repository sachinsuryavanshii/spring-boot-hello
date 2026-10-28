pipeline {
    agent any

    environment {
        APP_NAME = 'spring-boot-hello'
        IMAGE_TAG = '1.0.0'
        IMAGE_NAME = "${APP_NAME}:${IMAGE_TAG}"
        // Tool paths on Windows host
        DOCKER_BIN = 'C:\\Users\\Admin\\AppData\\Local\\Programs\\DockerDesktop\\resources\\bin'
        MINIKUBE_BIN = 'C:\\Users\\Admin\\AppData\\Local\\Programs\\Minikube'
        MAVEN_BIN = 'C:\\Users\\Admin\\AppData\\Local\\Programs\\ApacheMaven\\apache-maven-3.9.11\\bin'
        JAVA_BIN = 'D:\\Program Files\\Java\\jdk-25.0.5.0.3\\bin'
        PATH = "${DOCKER_BIN};${MINIKUBE_BIN};${MAVEN_BIN};${JAVA_BIN};${env.PATH}"
        // Docker Desktop and Kubernetes credentials & context
        DOCKER_CONFIG = 'C:\\Users\\Admin\\.docker'
        DOCKER_HOST = 'npipe:////./pipe/dockerDesktopLinuxEngine'
        KUBECONFIG = 'C:\\Users\\Admin\\.kube\\config'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=== Stage 1: Checkout Source Code ==='
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '=== Stage 2: Build Spring Boot Application with Maven ==='
                script {
                    if (isUnix()) {
                        sh 'mvn clean compile package -DskipTests'
                    } else {
                        bat 'mvn clean compile package -DskipTests'
                    }
                }
            }
        }

        stage('Test') {
            steps {
                echo '=== Stage 3: Run Unit and Integration Tests ==='
                script {
                    if (isUnix()) {
                        sh 'mvn test'
                    } else {
                        bat 'mvn test'
                    }
                }
            }
            post {
                always {
                    junit testResults: '**/target/surefire-reports/*.xml', allowEmptyResults: true
                }
            }
        }

        stage('Docker Build') {
            steps {
                echo '=== Stage 4: Build Docker Image ==='
                script {
                    if (isUnix()) {
                        sh "docker build -t ${IMAGE_NAME} ."
                    } else {
                        bat "docker build -t ${IMAGE_NAME} ."
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo '=== Stage 5: Deploy to Kubernetes (Minikube) ==='
                script {
                    if (isUnix()) {
                        sh "minikube image load ${IMAGE_NAME}"
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                        sh 'kubectl rollout status deployment/spring-boot-hello-deployment --timeout=90s'
                    } else {
                        bat "minikube image load ${IMAGE_NAME}"
                        bat 'kubectl apply -f deployment.yaml'
                        bat 'kubectl apply -f service.yaml'
                        bat 'kubectl rollout status deployment/spring-boot-hello-deployment --timeout=90s'
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
        }
        success {
            echo 'Spring Boot Hello Service successfully built, tested, containerized, and deployed!'
        }
        failure {
            echo 'Pipeline execution encountered errors. Check stage logs for troubleshooting.'
        }
    }
}
