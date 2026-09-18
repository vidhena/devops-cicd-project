pipeline {

    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'

                bat '''
                docker build -t devops-web-app:1.0 .
                '''
            }
        }

        stage('Load Image into Minikube') {
            steps {
                echo 'Loading Docker image into Minikube...'

                bat '''
                minikube image load devops-web-app:1.0
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                echo 'Initializing Terraform...'

                bat '''
                cd terraform
                terraform init
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                echo 'Deploying Kubernetes resources using Terraform...'

                bat '''
                cd terraform
                terraform apply -auto-approve
                '''
            }
        }

        stage('Restart Application') {
            steps {
                echo 'Restarting Kubernetes deployment...'

                bat '''
                kubectl rollout restart deployment/devops-web-app -n devops
                kubectl rollout status deployment/devops-web-app -n devops
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Checking Kubernetes resources...'

                bat '''
                kubectl get pods -n devops
                kubectl get services -n devops
                '''
            }
        }
    }

    post {
        success {
            echo 'CI/CD Pipeline completed successfully!'
        }

        failure {
            echo 'CI/CD Pipeline failed. Check the console output.'
        }
    }
}