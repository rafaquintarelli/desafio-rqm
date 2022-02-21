# meu-desafio

## Pré-requisitos:
 - Docker
 - Kubectl
 - Terraform
 - Git

## Estrutura:
 Para o meu desafio escolhi subir esta estrutura na AWS usando EKS, nele 3 microsserviços:
  - auth-api (node)
    - auth-db (postgre)
  - product-api (java)
    - product-db (postgre)
  - sales-api (node)
    - sales-db (mongo)
  - RabbitMQ


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
--header 'Authorization: bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoVXNlciI6eyJpZCI6MSwibmFtZSI6IlVzZXIgVGVzdCAxIiwiZW1haWwiOiJ0ZXN0ZXVzZXIxQGdtYWlsLmNvbSJ9LCJpYXQiOjE2NDU0MDA2MDcsImV4cCI6MTY0NTQ4NzAwN30.8yuKxJCdrq7PfxoVF2SJZVdieMp_-TEfQ2WlvMldWWc' \
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
--header 'Authorization: bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoVXNlciI6eyJpZCI6MSwibmFtZSI6IlVzZXIgVGVzdCAxIiwiZW1haWwiOiJ0ZXN0ZXVzZXIxQGdtYWlsLmNvbSJ9LCJpYXQiOjE2NDUzOTYxNzMsImV4cCI6MTY0NTQ4MjU3M30.jCcSTVvNvcpjhdRIMbpWiN0HLhOZsusOeMwNgmuTBtk' \
--data-raw ''
```


Testando sales-api:
Gerando massa de dados inicial na aplicação:
```bash
curl --location --request GET 'http://localhost:8082/api/initial-data' \
--header 'Content-Type: application/json'
```
  
response: {"message":"Data created."}
  
  
  
  
  
  
```bash
kubectl port-forward service/auth-api 8888:8080 &>/dev/null &; kubectl port-forward service/product-api 8889:8081 &>/dev/null &; kubectl port-forward service/sales-api 8890:8082 &>/dev/null &
```