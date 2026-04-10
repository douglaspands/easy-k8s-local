# EASY K8S LOCAL
O objetivo desse repositório é orientar de forma facil como utilizar o Kubernetes localmente.   
Usaremos as ferramentas: **Docker**, **KinD** e **Kubectl** para montarmos um cluster funcional e leve.

## Dependências

- [Docker](https://www.docker.com)
- [KinD](https://kind.sigs.k8s.io)
- [Kubernetes Cloud Provider for KinD](https://github.com/kubernetes-sigs/cloud-provider-kind)
- [Kubectl](https://kubernetes.io/docs/reference/kubectl/)

Para instalação do `Docker`, é necessario seguir os passos [oficiais](https://docs.docker.com/engine/install/).   
Os demais, eu recomendo instalar via [Brew](https://brew.sh/) com o comando: 
```sh
brew install kind cloud-provider-kind kubectl
```

## Inicialização do Cluster

### 1. Passo - Iniciar o Cluster junto com o Local Registry
```sh
./script/kind-with-registry.sh
```
> Script não prende o terminal.

**Local Registry** é o servidor/repositório local de imagens `Docker`. Ele é necessario quando se faz a construção (`build`) de uma nova imagem e precisa utilizar a mesma no manifesto de `deployment`, pois ele só utiliza imagens previamente armazenadas em um repositório.

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

### !!! Script facilitador !!!
Foi criado em Python um script para facilitar a inicialização do cluster:
```sh
./easyk8s
```
Pressione `Ctrl+C` para cancelar o script e encerrar o load balancer, o cluster e o registry.

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
