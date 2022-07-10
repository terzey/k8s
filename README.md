# K9S
## Ingress
Install nginx ingress controller [doc](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start)
```shell
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```