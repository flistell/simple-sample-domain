
Add to this directory:

 * weblogic-deploy.zip
 * archive_1.0.zip by building the application in the base dir using build-archive.sh
 * archive_2.0.zip by building the application in the base dir using build-archive.sh


Deploy of base domain

 1. `build-domain-base-image.sh` -> _Base domain docker image pushed to docker.io_
 2. `kubectl apply -f k8s-resource-secret_myapp-domain-base.yaml` -> _secret created for domain 'myapp-domain' on K8S cluster namespace_
 3. `kubectl apply -f k8s-resource-domain_myapp-domain-base.yaml` -> _empty domain for "myapp" created on K8S cluster_
 4. T.B.D: create the ingress / route -> `helm install ../weblogic-kubernetes-operator/kubernetes/samples/charts/ingress-per-domain --name sample-domain1-fl-traefik --namespace sample-domain1-ns-fl --values traefik-my-values.yaml`
 5. T.B.D: how to access the service in OCI-OKE

Redeploy of application

 1. `build-domain-update-app_1.0.sh` -> _Base domain + application version 1.0_
 2. `k apply -f k8s-resource-domain_myapp-domain-app_1.0.yaml` or `kubectl edit domain myapp-domain-fl`-> _changes the image source for the domain to the one with application version 1.0_
 
Wait for rolling update to happen
