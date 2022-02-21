# meu-desafio

## Pré-requisitos:
 - Docker
 - Kubectl
 - Terraform
 - Git

## Estrutura:
 Para o meu desafio escolhi subir esta estrutura na AWS usando EKS, nele 3 microsserviços com 3 bancos distintos e o RabbitMQ:
  - auth-api (node)
    - auth-db (postgre)
  - product-api (java)
    - product-db (postgre)
  - sales-api (node)
    - sales-db (mongo)
  - RabbitMQ


A documentação deles está no API-DOC.md

## Subindo localmente:

No seu computador dentro do repo da app:
`$ cd local/`

`$ docker-compose up -d`

Aguarde alguns minutos, os serviços irão subir devidamente

### Testando a aplicação:
auth-api = localhost:8080

Gerando massa de dados inicial na aplicação:
```bash
curl --location --request GET 'http://localhost:8080/api/initial-data' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "testeuser1@gmail.com",
    "password": "123456"
}'
```
  
response: {"message":"Data created."}



Gerando o Authorizarion token:
```bash
curl --location --request POST 'http://localhost:8080/api/user/auth' \
--header 'Content-Type: application/json' \
--header 'transactionid: 843e5420-e767-45f3-aee3-ca9a16233555' \
--data-raw '{
    "email": "testeuser1@gmail.com",
    "password": "123456"
}'
```
  
No response receberá um access token, que nas próximas usaremos como o Authorization


Testando o product-api
Criar novo produto:
```bash
curl --location --request POST 'localhost:8081/api/product' \
--header 'transactionid: 843e5420-e767-45f3-aee3-ca9a16233555' \
--header 'Authorization: bearer <cole seu accessToken aqui>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Superman - As Quatro Estações",
    "quantity_available": 3,
    "supplierId": 1000,
    "categoryId": 1000
}'
```
  
No response receberá o json do produto cadastrado


Busca os produtos cadastrados:
```bash
curl --location --request GET 'localhost:8081/api/product' \
--header 'transactionid: 843e5420-e767-45f3-aee3-ca9a16233555' \
--header 'Authorization: bearer <cole seu accessToken aqui>' \
--data-raw ''
```


Testando sales-api:
Gerando massa de dados inicial na aplicação:
```bash
curl --location --request GET 'http://localhost:8082/api/initial-data' \
--header 'Content-Type: application/json'
```
  
response: {"message":"Data created."}
  
  
  
  
## Subindo na AWS:

Acesse a pasta aws dentro do projeto:

`cd aws/`

Inicie o terraform:

`terraform init`

Aplique a estrutura:
`terraform apply --auto-approve`

Depois de uns 20min toda a estrutura ja subiu, com as aplicações iniciadas, inclusive com o kubectl de sua maquina ja conectado ao cluster

Abaixo rode este comando para fazer os port-forward no kubectl para acessar os serviços pela sua maquina:
```bash
kubectl port-forward service/auth-api 8888:8080 &>/dev/null &; kubectl port-forward service/product-api 8889:8081 &>/dev/null &; kubectl port-forward service/sales-api 8890:8082 &>/dev/null &
```

##Testando as aplicações:
Testaremos da mesma forma que o sistema local, porem alterando as portas para as mapeadas acima:
Gerando massa de dados inicial na aplicação:
```bash
curl --location --request GET 'http://localhost:8888/api/initial-data' \
--header 'Content-Type: application/json' \
--data-raw '{
    "email": "testeuser1@gmail.com",
    "password": "123456"
}'
```
  
response: {"message":"Data created."}



Gerando o Authorizarion token:
```bash
curl --location --request POST 'http://localhost:8888/api/user/auth' \
--header 'Content-Type: application/json' \
--header 'transactionid: 843e5420-e767-45f3-aee3-ca9a16233555' \
--data-raw '{
    "email": "testeuser1@gmail.com",
    "password": "123456"
}'
```
  
No response receberá um access token, que nas próximas usaremos como o Authorization


Testando o product-api
Criar novo produto:
```bash
curl --location --request POST 'localhost:8889/api/product' \
--header 'transactionid: 843e5420-e767-45f3-aee3-ca9a16233555' \
--header 'Authorization: bearer <cole seu accessToken aqui>' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "Superman - As Quatro Estações",
    "quantity_available": 3,
    "supplierId": 1000,
    "categoryId": 1000
}'
```
  
No response receberá o json do produto cadastrado


Busca os produtos cadastrados:
```bash
curl --location --request GET 'localhost:8889/api/product' \
--header 'transactionid: 843e5420-e767-45f3-aee3-ca9a16233555' \
--header 'Authorization: bearer <cole seu accessToken aqui>' \
--data-raw ''
```


Testando sales-api:
Gerando massa de dados inicial na aplicação:
```bash
curl --location --request GET 'http://localhost:8890/api/initial-data' \
--header 'Content-Type: application/json'
```
  
response: {"message":"Data created."}
