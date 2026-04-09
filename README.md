# EASY K8S LOCAL
Scripts para facilitar a o uso do Kubernetes localmente na maquina.

## Dependencias

- Docker
- Kubectl
- KIND
- Cloud Provider KIND

> Para instalação do Docker, é necessario seguir os passos [oficiais](https://docs.docker.com/engine/install/). Os demais, eu recomendo instalar via [Brew](https://brew.sh/) (`brew install kind kubectl cloud-provider-kind`).

## Inicialização Do Cluster

### 1. Passo - Iniciar o Cluster junto com o Registry
```sh
./script/kind-with-registry.sh
```
> Script não prende o terminal.


### 2. Passo - Iniciar o Load Balancer
Liberar as permissões requeridas:
```sh
kubectl label node kind-control-plane node.kubernetes.io/exclude-from-external-load-balancers-
``` 
> Script não prende o terminal.

Iniciar o Load Balancer:
```sh
cloud-provider-kind
```
> Binario prende o terminal.

## Teste
Apos iniciar o cluster do k8s, iniciar a aplicação de teste com o seguinte comando:
```sh
kubectl apply -k k8s/local
``` 

Para validar se esta tudo funcionado, vamos fazer request nas aplicações (`bar-app` e `foo-app`) executando o script:
```sh
./script/test-ingress.sh
```

O output deve conter algo assim quando der certo:
```txt
curl -i 172.20.0.4/foo

HTTP/1.1 200 OK
date: Thu, 09 Apr 2026 02:01:23 GMT
content-length: 7
content-type: text/plain; charset=utf-8
x-envoy-upstream-service-time: 0
server: envoy

foo-app

---
curl -i 172.20.0.4/bar

HTTP/1.1 200 OK
date: Thu, 09 Apr 2026 02:01:24 GMT
content-length: 7
content-type: text/plain; charset=utf-8
x-envoy-upstream-service-time: 0
server: envoy

bar-app
```
