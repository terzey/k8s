# K9S
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