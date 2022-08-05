# K8S
## Repository structure
```shell
├── apps                    # Applications deployment
│   ├── base
│   ├── dev                 # Dev kustomization
│   ├── stage
│   └── prod
├── clusters                # Flux resources deployed to "flux-system" kubernetes namespace
│   ├── dev                 # Flux resources for dev cluster
│   │   ├── flux-system     # Bootstrapped by "terraform/flux-bootstrap/dev"
│   │   └── flux-resources  # Custom Flux resources: HelmRepository(ies), Kustomization(s), Alert(s)
│   ├── stage               # Flux resources for stage cluster
│   └── prod                # Flux resources for prod cluster
├── infrastructure          # Deployed by flux: monitoring, alerting, grafana, ingress controllers, service mesh, etc.
│   ├── base
│   ├── dev                 # Dev kustomization
│   ├── stage
│   └── prod 
└── terraform               # IaC
    ├── kubernetes          # Deploy kubernetes cluster 
    │   ├── main
    │   ├── dev
    │   ├── stage
    │   └── prod
    ├── infrastructure      # Kubernetes cluster-wide and external resources: namespaces, kubernetes dashboard, helm repositories
    │   ├── main
    │   ├── dev
    │   ├── stage
    │   └── prod
    └── flux-bootstrap      # Bootstraps flux to clusters/[dev/state/prod]
        ├── main
        ├── dev
        ├── stage
        └── prod

```
## Terraform
### Deploy dev cluster
```shell
bash terraform/kubernetes/dev/deploy.sh
```
## Ingress
Install nginx ingress controller [doc](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start)
```shell
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

## Troubleshooting
Namespace "flux-system" stuck as Terminating
```shell
kubectl get namespace flux-system -o json > flux-system.json
jq '.spec.finalizers = []' flux-system.json > flux-system-1.json
kubectl replace --raw "/api/v1/namespaces/flux-system/finalize" -f ./flux-system-1.json
```
Inspect overlay resources
```shell
 kustomize build overlay_path | kubesplit -o ./build/ -p -c
```
Describe helm release
```shell
kubectl describe -n <namespace> helmrelease/<release-name>
```