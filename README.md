# Go Http Web Server
A simple http web server written in `Golang` exposing application metrics as a microservice. This project is built on the basic DevOps principles like building images securely through CI mechanism which includes signing of images, scanning for vulnerabilities and also does a continuous deployment test on every push and pull request. The application can be deployed easily on your kubernetes cluster using helm chart. 

## Pre-requisites for installation on Linux Machines

- [Docker](https://docs.docker.com/desktop/)
- [KIND](https://kind.sigs.k8s.io/)
- [OpenTofu](https://opentofu.org/docs/intro/install/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [Helm](https://helm.sh)
- [Cosign](https://docs.sigstore.dev/cosign/installation)

## Setup tools and environment using OpenTofu
1. Clone this repo in your local laptop 
```bash
git clone https://github.com/cherrymu/process-out-challenge.git
```
2. Install all the necessary cli tools using makescript. Before running the makefile please make sure you have `make` and `unzip` utility installed on your machine
```bash
make all 
```
3. Switch directory into environments/local-dev
```bash
cd environments/local-dev/
```
4. Initialize OpenTofu
```bash
tofu init
```
5. Apply OpenTofu Configuration to Create Kind Cluster
```bash
tofu apply -auto-approve
```
6. Set your `KUBECONFIG` path and check the status of the nodes 
```bash
export KUBECONFIG=./environments/local-dev/kubeconfig_example

kubectl get nodes -o wide
```
7. Create a namespace for our application deployment and an `imagepull secret` to securely pull a private image from the container registry
```bash
kubectl create ns go-web-app

kubectl create secret docker-registry my-registry-secret --docker-server=docker.io --docker-username=tincher --docker-password=dckr_pat_rNnP750_a_Jt6MKeTyaK0uomSQk -n go-web-app
```

## Deploying the application using Helm 

1. Add the helm repo and perform a repo update 

```bash
helm repo add go-http-server https://cherrymu.github.io/process-out-challenge/charts

helm repo update 
```
2. Deploy the application 
``` bash
helm install web-server go-http-server/go-simple-web-server -n go-web-app
```
3. Please follow the instructions on your screen to do a `port-forward` of the app service to test it the locally for the path `/` for webpage displaying Hello,World! and the path `/metrics`to view the metrics exposed by the application.

## Bonus Points
You can fetch the values.yaml of the chart locally to make changes and upgrade your helm release
```bash
helm show values go-http-server/go-simple-web-server > custom-values.yaml

helm upgrade web-server go-http-server/go-simple-web-server -f custom-values.yaml
```
## Clean Up
1. Delete the helm release 
```bash
helm delete web-server
```
2. Destroy the KIND cluster after testing 
```bash
cd environments/local-dev/

tofu destroy
```

## Things Covered 
- [x] Create a golang application listening on port 8080 with open telemetry metrics
- [x] Application built in a secure CI pipeline using github actions and test the release using CD process.
- [x] Packaged into a Docker container and push it to a container registry
- [x] Deployed on to a local kind cluster
- [x] Used private cloud container registry
- [x] Used helm to deploy the packaged application easily
- [x] Usage of infrastructure-as-code tool (OpenTofu) to provision local KIND cluster
- [x] Security scanners implementation using Trivy during the build process 

## Assumptions
After building the application from the CI pipeline, deploy it manually using helm on any k8s distribution. However, also written a github workflow to do a continous test of the latest image built using OpenTofu on a local kind cluster running in the workflow job.

## Project Highlights/Features
1. Modular Golang code with Separate HTTP handlers and telemetry into different files for better organization and error handling.
2. Built the CI workflow using [github actions](https://docs.github.com/en/actions) for building the image on every push andpull requests before merging. 
3. Used [Trivy](https://github.com/aquasecurity/trivy) as a security vulnerability scanner to scan the built images before pushing it to the private container registry
4. Used [Cosign](https://docs.sigstore.dev/cosign/installation) to sign off the images securely to the private container registy.
5. Used [OpenTofu](https://opentofu.org/docs/intro/install/) to automate the provision of the creating a quick local KIND cluster even when we don't have native KIND package support in OpenTofu yet. So used a bash script under the hoods and taking advantage of OpenTofu's `null_resource` to manage the execution of your Kind cluster script
6. Created and hosted [Helm Chart](https://helm.sh) using GitHub pages for easy access.


## Areas for Future Improvement
1. Use an ingress gateway like Istio to route the traffic inside the cluster securely with more granularity and access control for the backend services with claims and policies.
2. Use ArgoCD/Flux to deploy and manage applications more efficiently
3. Extend OpenTofu configuration to automate installation of pre-requisites tools.
4. Use [sigstore policy controller](https://github.com/sigstore/policy-controller) to enforce a strict image policy such that only signed and verified images will be allowed to deploy in a namespace and other images will be rejected by the admission webhook controller.
