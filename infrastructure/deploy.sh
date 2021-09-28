#!/bin/sh

REGION="ap-south-1"
SERVICE_NAME="test-service-name"
# SERVICE_TAG="${SERVICE_TAG}"
# ECR_REPO_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${SERVICE_NAME}"
  SERVICE_TAG="v1"
  ECR_REPO_URL="202791543801.dkr.ecr.ap-south-1.amazonaws.com/${SERVICE_NAME}"

if [ "$1" = "build" ];then
    echo "Building the application.."
    cd ..
    # sh mvnw clean install
# elif [ "$1" = "test" ];then
#     echo $SERVICE_NAME
#     find ../target/ -type f \( -name "*.jar" -not -name "*sources.jar" \) -exec cp {} ../infrastructure/$SERVICE_NAME.jar \;
elif [ "$1" = "dockerize" ];then
    # find ../target/ -type f \( -name "*.jar" -not -name "*sources.jar" \) -exec cp {} ../infrastructure/$SERVICE_NAME.jar \;
    echo "Building the application.."
    aws ecr create-repository --repository-name ${SERVICE_NAME:?} --region ${REGION} || true
    aws ecr get-login-password \
    --region ${REGION} \
    | docker login \
    --username AWS \
    --password-stdin 202791543801.dkr.ecr.ap-south-1.amazonaws.com

    cd ..
    docker build -t ${SERVICE_NAME}:${SERVICE_TAG} -f 03-application/Dockerfile .
    docker tag ${SERVICE_NAME}:${SERVICE_TAG} ${ECR_REPO_URL}:${SERVICE_TAG}
    docker push ${ECR_REPO_URL}:${SERVICE_TAG}
elif [ "$1" = "plan" ];then
    echo "terraform plan..for application deployment"
    terraform init -backend-config="application-dev.config"
    terraform plan -var-file="dev.tfvars" -var docker_image_url="$ECR_REPO_URL:$SERVICE_TAG"
elif [ "$1" = "deploy" ];then
    terraform init -backend-config="application-dev.config"
    terraform apply -var-file="dev.tfvars" -var "docker_image_url=$ECR_REPO_URL:$SERVICE_TAG" -auto-approve
elif [ "$1" = "destroy" ];then
    cd infrastructure
    terraform init -backend-config="app-prod.config"
    terraform destroy -var-file="production.tfvars" -var "docker_image_url=$ECR_REPO_URL:$SERVICE_TAG" -auto-approve
fi
