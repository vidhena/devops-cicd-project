DevOps CI/CD Pipeline with Jenkins, Docker, Kubernetes and Terraform
Project Overview
This project demonstrates a complete local CI/CD pipeline for deploying a simple Nginx web application using DevOps tools.
The application source code is maintained using Git and GitHub. Jenkins retrieves the latest code, builds a Docker image, loads the image into a Minikube Kubernetes cluster, and uses Terraform to create and manage Kubernetes resources.
The project demonstrates the complete flow from source-code change to application deployment and verification.
Technologies Used
Git – Version control
GitHub – Source-code repository
Jenkins – CI/CD automation
Docker – Containerization
Kubernetes – Container orchestration
Minikube – Local Kubernetes cluster
Terraform – Infrastructure as Code
Nginx – Web server
Windows – Local development environment
Project Architecture
Developer
    |
    v
   Git
    |
    v
 GitHub
    |
    v
 Jenkins
    |
    +----------------------+
    |                      |
    v                      v
Docker Build          Terraform
    |                      |
    v                      v
Minikube              Kubernetes
    |                      |
    +----------+-----------+
               |
               v
        Web Application
Project Structure
devops-cicd-project/
│
├── app/
│   └── index.html
│
├── Dockerfile
│
├── Jenkinsfile
│
├── README.md
│
└── terraform/
    ├── providers.tf
    ├── namespace.tf
    ├── deployment.tf
    └── service.tf
Application
The application is a simple HTML web page served using Nginx.
The application source code is located at:
app/index.html
Example:
HTML
<!DOCTYPE html>
<html>
<head>
    <title>DevOps CI/CD Project</title>
</head>
<body>
    <h1>DevOps CI/CD Project - Version 2</h1>
</body>
</html>
Docker
Docker is used to containerize the web application.
Dockerfile
FROM nginx:alpine

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80
Dockerfile Explanation
FROM nginx:alpine uses a lightweight Nginx image.
COPY copies the application HTML file into the Nginx web directory.
EXPOSE 80 documents the port used by Nginx.
Build Docker Image
The Docker image is built using:
docker build -t devops-web-app:2.0 .
The image used in the final deployment is:
devops-web-app:2.0
Versioned image tags are used so that application versions can be clearly identified.
Example:
devops-web-app:1.0
devops-web-app:2.0
devops-web-app:3.0
Kubernetes and Minikube
Kubernetes is used to run and manage the Docker container.
Minikube provides the local Kubernetes cluster.
The Minikube profile used in this project is:
unique
Check the Minikube status using:
minikube status -p unique
Kubernetes Namespace
A dedicated Kubernetes namespace is used:
devops
This keeps the project's Kubernetes resources organized.
Kubernetes Deployment
Deployment name:
devops-web-app
The deployment runs one replica of the application.
The container image is:
devops-web-app:2.0
The container listens on:
80
The deployment uses:
image_pull_policy = "Never"
This is because the Docker image is loaded directly into the local Minikube cluster.
Kubernetes Service
Service name:
devops-web-app-service
Service type:
NodePort
The service exposes the application and forwards traffic to the Nginx container.
The application can be opened using:
minikube service devops-web-app-service -n devops -p unique
Terraform
Terraform is used as Infrastructure as Code (IaC) to manage the Kubernetes resources.
Terraform creates and manages:
Namespace
    |
    +--- Deployment
    |
    +--- Service
Terraform Files
providers.tf
Configures the Kubernetes provider.
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
namespace.tf
Creates the devops namespace.
resource "kubernetes_namespace" "devops" {
  metadata {
    name = "devops"
  }
}
deployment.tf
Creates the Kubernetes deployment and runs:
devops-web-app:2.0
The deployment contains:
Application container
One replica
Port 80
image_pull_policy = "Never"
service.tf
Creates the NodePort service:
devops-web-app-service
Terraform Commands
Initialize Terraform:
terraform init
Check the infrastructure plan:
terraform plan
Apply the configuration:
terraform apply -auto-approve
Jenkins CI/CD Pipeline
The CI/CD pipeline is defined in:
Jenkinsfile
The Jenkins pipeline performs the following stages:
1. Checkout
2. Build Docker Image
3. Load Image into Minikube
4. Terraform Init
5. Terraform Apply
6. Restart Application
7. Verify Deployment
Stage 1 – Checkout
Jenkins retrieves the latest source code from GitHub.
GitHub
   ↓
Jenkins Workspace
Stage 2 – Build Docker Image
Jenkins builds the Docker image:
docker build -t devops-web-app:2.0 .
Stage 3 – Load Image into Minikube
The image is loaded into the correct Minikube profile:
minikube image load devops-web-app:2.0 -p unique
Stage 4 – Terraform Init
Jenkins initializes Terraform:
cd terraform
terraform init
Stage 5 – Terraform Apply
Jenkins creates or updates the Kubernetes resources:
cd terraform
terraform apply -auto-approve
Stage 6 – Restart Application
Jenkins restarts the Kubernetes deployment:
kubectl rollout restart deployment/devops-web-app -n devops
Then it waits for the deployment:
kubectl rollout status deployment/devops-web-app -n devops
Stage 7 – Verify Deployment
Jenkins verifies the Kubernetes resources:
kubectl get pods -n devops
kubectl get services -n devops
A successful pipeline displays:
CI/CD Pipeline completed successfully!
Finished: SUCCESS
Complete CI/CD Workflow
Developer makes code change
          |
          v
     Git add/commit
          |
          v
      GitHub
          |
          v
      Jenkins
          |
          v
    Checkout Source
          |
          v
   Build Docker Image
          |
          v
 Load Image into Minikube
          |
          v
    Terraform Init
          |
          v
   Terraform Apply
          |
          v
     Kubernetes
          |
          v
 Restart Deployment
          |
          v
 Verify Pod & Service
          |
          v
 Updated Web Application
Testing
The CI/CD pipeline was tested by modifying the application.
Initial Application
The initial Docker image was:
devops-web-app:1.0
The application was deployed successfully using this image.
Application Update
The HTML application was modified to Version 2.
A new Docker image was then created:
devops-web-app:2.0
The new image was:
Built using Docker
Loaded into Minikube
Deployed using Terraform
Started by Kubernetes
Verified inside the Kubernetes pod
Displayed through the browser
The Version 2 application was successfully displayed.
Troubleshooting
Several real-world issues were encountered during the implementation.
1. Jenkins could not find the Minikube profile
Problem
Jenkins initially tried to use the default profile:
minikube
However, the actual active profile was:
unique
Solution
The Minikube command was changed to:
minikube image load devops-web-app:2.0 -p unique
2. Jenkins could not access Minikube
Problem
Jenkins was initially running as the Windows Local System account.
The Minikube configuration was available to the normal Windows user account.
Solution
Jenkins was configured to run under the Windows user account.
After restarting the Jenkins service, Jenkins was able to access the Minikube profile.
3. Application update was not reflected in Kubernetes
Problem
The first application update continued using the same Docker image tag:
devops-web-app:1.0
The new Docker image was built, but Kubernetes continued using the previously loaded image.
Solution
A new image tag was introduced:
devops-web-app:2.0
The following were updated:
Jenkins Docker build
Minikube image load
Terraform deployment
This allowed Kubernetes to clearly identify and deploy the new image.
4. Kubernetes pod continued running the old application
Problem
The old pod was still running the previous image.
Solution
The existing pod was deleted:
kubectl delete pod -l app=devops-web-app -n devops
Kubernetes automatically created a new pod through the Deployment.
The new pod was then verified using:
kubectl exec -n devops deployment/devops-web-app -- cat /usr/share/nginx/html/index.html
The updated Version 2 content was successfully displayed.
5. Terraform detected changes outside Terraform
Terraform displayed:
Objects have changed outside of Terraform
This occurred because a Kubernetes resource had been changed outside Terraform.
Terraform detected the difference and recreated the required resources successfully.
The Terraform deployment completed successfully:
Apply complete!
Resources: 3 added, 0 changed, 0 destroyed.
Verification Commands
Check Kubernetes pods:
kubectl get pods -n devops
Check Kubernetes services:
kubectl get services -n devops
Check deployment image:
kubectl get deployment devops-web-app -n devops -o jsonpath="{.spec.template.spec.containers[0].image}"
Expected:
devops-web-app:2.0
Check the actual HTML inside the running container:
kubectl exec -n devops deployment/devops-web-app -- cat /usr/share/nginx/html/index.html
Open the application:
minikube service devops-web-app-service -n devops -p unique
Key Learning
This project provided practical experience with:
Git version control
GitHub repository management
Jenkins CI/CD pipelines
Docker image creation
Kubernetes deployments
Minikube
Terraform Infrastructure as Code
Kubernetes services
Image versioning
CI/CD troubleshooting
Jenkins and Windows permissions
Debugging container deployment issues
Future Improvements
The project can be further improved by:
Automatically triggering Jenkins after every GitHub push
Automatically generating Docker image tags using Jenkins build numbers
Using Git commit IDs as Docker image tags
Adding automated application testing
Adding Kubernetes readiness and liveness probes
Increasing the number of application replicas
Adding monitoring and logging
Deploying the application to a cloud Kubernetes environment
Final Result
The project successfully implements a complete local CI/CD pipeline:
Git
 ↓
GitHub
 ↓
Jenkins
 ↓
Docker
 ↓
Minikube
 ↓
Terraform
 ↓
Kubernetes
 ↓
Nginx Web Application
A code change can be committed to GitHub, processed through Jenkins, converted into a Docker image, loaded into Minikube, deployed through Terraform and Kubernetes, and verified as an updated running application.
Author
Vidhena
Project: DevOps CI/CD Pipeline with Jenkins, Docker, Kubernetes and Terraform