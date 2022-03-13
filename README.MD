# DDoS-Ripper Terraform Wrapper over Kubernetes

## Description
A wrapper for [DDoS-Ripper](https://github.com/palahsu/DDoS-Ripper)
that launches Kubernetes deployments for each specified IP and port.
Simplifies massive DDoS attacks for a large number of targets and automatically
relaunches DDoS-Ripper in case of failure.

## Usage example with minikube
### Preparing the environment
[Docker](https://www.docker.com/get-started),
[minikube](https://minikube.sigs.k8s.io/docs/start/) and
[Terraform](https://www.terraform.io/downloads) must be installed before
proceeding. Docker also must be running.

`minikube start --cpus <YOUR_NUMBER_OF_CORES>`

`terraform init`


### Starting an attack

Default configuration:

`terraform apply -auto-approve -var targets=IP1:PORT1,IP2:PORT2`

Custom configuration:

```terraform apply -auto-approve -var targets=IP1:PORT1,IP2:PORT2 -var replicas=2 -var turbo=443```


### Checking the running PODs

`kubectl get pod --namespace="dripper"`

### Stopping the atack

`terraform destroy -auto-approve`

## Input parameters

`targets` - target IP and ports specified in format `IP1:PORT1,IP2:PORT2`

`replicas` - number of replicas for each target

`turbo` -  DDOS intensity. Can be either 135 or 443
