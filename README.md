# spyder-docker
Demo code for connecting docker container kernel in spyder

## Idea follows from the following question
https://stackoverflow.com/questions/72648550/how-to-run-docker-container-in-spyder

## How to setup Spyder kernel connection
https://docs.spyder-ide.org/current/panes/ipythonconsole.html#connect-to-a-remote-kernel

## Command to get container the ip address
```sh
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' spyder
```

## Command to ssh into container
```sh
ssh notebook-user@127.0.0.1:2022
```

## Extra details for ssh
```sh
username="notebook-user"
password="1234"
connection_path="./local/share/jupyter/runtime/kernel-7.json"
```