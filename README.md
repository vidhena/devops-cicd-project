# DevOps CI/CD Project Using Jenkins, Docker, Kubernetes and Terraform

This project demonstrates a beginner-level DevOps CI/CD workflow using Git, GitHub, Jenkins, Docker, Kubernetes, Minikube, and Terraform.

The main objective of this project is to automate the process of taking application source code from GitHub, building the application into a Docker image, deploying it to Kubernetes, and managing the Kubernetes resources using Terraform.

The application used in this project is a simple Nginx-based web application. The application contains an HTML page that displays a welcome message and confirms that the application has been deployed using Jenkins, Docker, and Kubernetes.

## Technologies Used

- Git
- GitHub
- Jenkins
- Docker
- Kubernetes
- Minikube
- Terraform
- Nginx
- HTML

## Application

The application is a simple HTML web page served using Nginx.

The application file is:

`app/index.html`

The current application version is Version 1.

```html
<!DOCTYPE html>
<html>
<head>
    <title>DevOps CI/CD Project</title>
</head>
<body>
    <h1>Welcome to My DevOps Project v1</h1>
    <p>Application deployed using Jenkins, Docker and Kubernetes.</p>
</body>
</html>
project structure
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
    Git and GitHub
Git is used for version control and to track changes made to the application and configuration files.
GitHub is used as the remote repository where the complete project source code is stored.
GitHub Repository:
https://github.com/vidhena/devops-cicd-project⁠�
The project uses the master branch.
The source code is committed and pushed to GitHub so that Jenkins can retrieve the latest version of the project.

Docker
Docker is used to containerize the web application.
The Dockerfile uses Nginx Alpine as the base image.
FROM nginx:alpine

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80
The Docker image is created using:
docker build -t devops-web-app:1.0 .
The Docker image name used in this project is:
devops-web-app:1.0
The application runs on port 80 inside the container.

Kubernetes and Minikube
Kubernetes is used to deploy and manage the Docker container.
Minikube is used to run the Kubernetes cluster locally.
The Minikube profile used in this project is:
unique
The Kubernetes namespace created for the project is:
devops
The application deployment is:
devops-web-app
The Kubernetes service is:
devops-web-app-service
The application container uses port 80.
The Kubernetes deployment uses the locally created Docker image:
devops-web-app:1.0
The image pull policy is set to Never because the image is built locally and loaded into Minikube.
The Docker image is loaded into Minikube using:
minikube image load devops-web-app:1.0 -p unique
The application can be accessed using:
minikube service devops-web-app-service -n devops -p unique

Terraform
Terraform is used as Infrastructure as Code to create and manage the Kubernetes resources.
Terraform is responsible for managing the Kubernetes namespace, deployment, and service.
The Terraform configuration is divided into separate files.
providers.tf configures the Kubernetes Terraform provider.
namespace.tf creates the devops namespace.
deployment.tf creates the devops-web-app deployment and configures the application container.
service.tf creates the NodePort service used to access the application.
The main Terraform commands used are:
terraform init
terraform plan
terraform apply -auto-approve
terraform init initializes the Terraform project and downloads the required provider.
terraform plan displays the changes Terraform is going to make.
terraform apply creates or updates the Kubernetes resources according to the Terraform configuration.

Jenkins
Jenkins is used to automate the CI/CD process.
The Jenkins pipeline is defined inside the Jenkinsfile.
The Jenkins job retrieves the project from the GitHub repository and performs the deployment steps automatically.
The pipeline performs the following tasks:
Checks out the source code from GitHub.
Builds the Docker image.
Loads the Docker image into Minikube.
Initializes Terraform.
Applies the Terraform configuration.
Restarts the Kubernetes deployment.
Waits for the deployment to complete.
Verifies the Kubernetes pods and services.

The Docker image is built using:
docker build -t devops-web-app:1.0 .
The image is loaded into the Minikube unique profile using:
minikube image load devops-web-app:1.0 -p unique
Terraform is initialized using:
cd terraform
terraform init
The Kubernetes infrastructure is deployed using:
cd terraform
terraform apply -auto-approve
The Kubernetes deployment is restarted using:
kubectl rollout restart deployment/devops-web-app -n devops
The rollout is verified using:
kubectl rollout status deployment/devops-web-app -n devops
The pods are checked using:
kubectl get pods -n devops
The service is checked using:
kubectl get services -n devops

CI/CD Process
When the project source code is available in GitHub, Jenkins retrieves the source code from the repository.
Jenkins then builds the Docker image using the Dockerfile.
The generated Docker image is loaded into the local Minikube cluster.
Terraform is then used to create or update the Kubernetes resources.
Kubernetes starts the application using the Docker image.
Jenkins verifies that the deployment and service are running successfully.
The application can then be accessed through the Kubernetes NodePort service.

Troubleshooting
During the implementation of the project, several practical issues were encountered and resolved.
Initially, Jenkins was unable to access the Minikube environment because Jenkins was running under the Windows Local System account. The Jenkins service was configured to run using the Windows user account that had access to the Minikube configuration.
Another issue occurred because the active Minikube profile was unique instead of the default minikube profile. The Jenkins pipeline was updated to explicitly use the unique profile when loading the Docker image.
The Docker image was built locally and therefore was not pushed to Docker Hub. The image was loaded directly into Minikube using:
minikube image load devops-web-app:1.0 -p unique
A Terraform state issue was also encountered when Kubernetes resources were changed outside Terraform. Terraform detected that the actual Kubernetes environment was different from its state and reconciled the resources during the next Terraform apply.
These troubleshooting steps helped in understanding how Jenkins, Docker, Kubernetes, Minikube, and Terraform interact during a CI/CD deployment.

Verification
The Kubernetes pods can be checked using:
kubectl get pods -n devops
The Kubernetes service can be checked using:
kubectl get services -n devops
The deployment can be checked using:
kubectl get deployment -n devops
The Docker image configured in the deployment can be checked using:
kubectl get deployment devops-web-app -n devops -o jsonpath="{.spec.template.spec.containers[0].image}"
The application content running inside the pod can be checked using:
kubectl exec -n devops deployment/devops-web-app -- cat /usr/share/nginx/html/index.html
The application can be opened using:
minikube service devops-web-app-service -n devops -p unique

Project Outcome
The project successfully demonstrates a complete beginner-level local DevOps CI/CD workflow.
Git and GitHub are used for source code management.
Jenkins is used for CI/CD automation.
Docker is used for application containerization.
Kubernetes is used for container orchestration.
Minikube provides the local Kubernetes environment.
Terraform is used for Infrastructure as Code and manages the Kubernetes resources.
Nginx serves the web application inside the Docker container.
The final application is successfully deployed to Kubernetes and can be accessed through the Kubernetes service.

Key Learning
This project provided practical experience in Git version control, GitHub repository management, Jenkins pipelines, Docker image creation, Kubernetes deployments and services, Minikube, Terraform configuration, Infrastructure as Code, CI/CD automation, and troubleshooting.
The project also helped in understanding how multiple DevOps tools can be integrated into a single deployment workflow instead of using each tool independently.

Future Improvements
The project can be extended in the future by adding automatic Jenkins triggers when code is pushed to GitHub, automated Docker image versioning, automated testing, Kubernetes ConfigMaps and Secrets, multiple application replicas, monitoring, logging, and deployment to a cloud Kubernetes environment.

Conclusion
This project demonstrates how a simple web application can be managed through a DevOps workflow using Git, GitHub, Jenkins, Docker, Kubernetes, Minikube, and Terraform.
The application source code is maintained in GitHub, Jenkins automates the CI/CD process, Docker provides containerization, Kubernetes manages the application, Minikube provides the local cluster, and Terraform manages the Kubernetes infrastructure as code.
The project provides hands-on experience with the fundamental tools and concepts required for a beginner-level DevOps workflow.