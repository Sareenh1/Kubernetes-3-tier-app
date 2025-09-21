#!/bin/bash

echo "=== Kubernetes Demo App Deployment on EC2 ==="

# Build Docker images
echo "Building Docker images..."
docker build -t frontend-app:latest ./app/frontend
docker build -t backend-app:latest ./app/backend

# Load images into Minikube
echo "Loading images into Minikube..."
minikube image load frontend-app:latest
minikube image load backend-app:latest

# Create namespace
echo "Creating namespace..."
kubectl apply -f k8s/namespace.yaml

# Apply ConfigMaps and Secrets
echo "Applying ConfigMaps and Secrets..."
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/mysql-configmap.yaml

# Apply storage
echo "Applying storage..."
kubectl apply -f k8s/pvc.yaml

# Apply deployments
echo "Applying deployments..."
kubectl apply -f k8s/deployment-backend.yaml
kubectl apply -f k8s/deployment-frontend.yaml

# Wait for pods to be ready
echo "Waiting for pods to be ready..."
sleep 30

# Apply services
echo "Applying services..."
kubectl apply -f k8s/service-backend.yaml
kubectl apply -f k8s/service-frontend.yaml

# Apply ingress
echo "Applying ingress..."
kubectl apply -f k8s/ingress.yaml

# Wait for services
echo "Waiting for services to be ready..."
sleep 20

echo "=== Deployment Complete ==="
echo ""
echo "=== Application Status ==="
kubectl get pods -n demo-app
echo ""
kubectl get svc -n demo-app
echo ""
kubectl get ingress -n demo-app
echo ""
kubectl get pvc -n demo-app
echo ""
echo "=== Access Instructions ==="
echo "1. LoadBalancer URL:"
minikube service frontend-service -n demo-app --url
echo ""
echo "2. To test DNS resolution:"
echo "   kubectl run dns-test -n demo-app --image=busybox --rm -it --restart=Never -- nslookup backend-service.demo-app.svc.cluster.local"
echo ""
echo "3. To test service communication:"
echo "   kubectl run curl-test -n demo-app --image=curlimages/curl --rm -it --restart=Never -- curl http://backend-service.demo-app.svc.cluster.local:8080/api/data"
echo ""
echo "4. To view logs:"
echo "   kubectl logs -l app=backend -n demo-app -c backend"
echo "   kubectl logs -l app=mysql -n demo-app -c mysql"
