## Use cases ##

 - First implant of domain
 - Deploy application on fresh domain
 - Update application (and redeploy with rolling)
 - Update _DataSource_ configurations (string, password)
 - Update JAVA OPTIONS (Xmx)
 - Update OS / JDK 
 - Update WLS
 - Patching of WLS

### UC-1 First implant of domain ###

1. Customize the domain configuration: `inventory/group_vars/all.yaml`

2. Build the Base Domain Image: 
```
    $ ansible-playbook -vv -i inventory/inventory.yaml playbook-build-domain-base-image.yaml
```

    The result is a basic image pushed in the {{ DOCKER_REPOSITORY }}.

3. Create Domain credentials and Domain resource on K8S:
```
    ansible-playbook -vv -i inventory/inventory.yaml playbook-create-domain-in-k8s.yaml
```

Wait until all the pods are running.

Write down and keep DOMAIN_BASE_IMAGE_TAG value: this is the id of the base image of the domain from which you must derive all the subsequent build.


### Deploy application ###

1. Build the application image:
```
    $ ansible-playbook -vv -i inventory/inventory.yaml playbook-build-domain-with-app.yaml
```

At the end of build `target_app/domain_app_image_tag.yaml` will contain the new application image tag and image name.

2. Deploy the application with rolling strategy by editing the k8s domain resource either by hand with `kubectl edit domain {{ DOMAIN_NAME }}` or with the generated patch file:
```
    kubectl patch domain --type=merge  -n sample-domain1-ns-fl myapp-domain-fl --patch "$(cat target_app/k8s-resource-domain-patch.yaml)" -o yaml
```

This will terminate the pods one-by-one a rollout the new version of the domain with the application deployed.

3. Test the application server readyness:
```
    curl -v http://$(kubectl get service  myapp-domain-fl-cluster-cluster-1 -o jsonpath='{ .spec.clusterIP }:{ .spec.ports[0].port }')/weblogic/ready
```

4. Test the application:
```
    curl -v http://$(kubectl get service  myapp-domain-fl-cluster-cluster-1 -o jsonpath='{ .spec.clusterIP }:{ .spec.ports[0].port }')/testwebapp/
```


### Update application (and redeploy with rolling) ###

Update the application or provide a new application version and put it in `applications/` directory.

1. Build the application image specifing the version VER variable on command line:
```
    $ ansible-playbook  -i inventory/inventory.yaml -e VER=v2 playbook-build-domain-with-app.yaml
```


2. Deploy the application with rolling strategy by editing the k8s domain resource either by hand with `kubectl edit domain {{ DOMAIN_NAME }}` or with the generated patch file:
```
    kubectl patch domain --type=merge  -n sample-domain1-ns-fl myapp-domain-fl --patch "$(cat target_app/k8s-resource-domain-patch.yaml)"
```

