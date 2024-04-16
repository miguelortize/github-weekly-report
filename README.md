# github-weekly-report
Project created with the purpose to create Github Reports.


az login:

```
az login
az acr login --name miguelcontainertest
```

```
az acr update -n miguelcontainertest --admin-enabled true
```

docker pull mcr.microsoft.com/mcr/hello-world
docker tag mcr.microsoft.com/mcr/hello-world miguelcontainertest.azurecr.io/azurefunctionsimage:v1.0.0

docker push miguelcontainertest.azurecr.io/azurefunctionsimage:v1.0.0

![alt text](image.png)

![alt text](image-1.png)

![alt text](image-2.png)


Test:
https://us-central1-test-project-miguel.cloudfunctions.net/function-1?user=kubernetes&repo=kubernetes