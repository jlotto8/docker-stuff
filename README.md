# docker-stuff
A repo to store and monitor improvement of docker usage. 


# Command Purpose
docker build -t my-nginx-app .	Builds a Docker image from the Dockerfile in the current directory.

docker rm -f my-nginx-app	Forcefully removes a container (stopped or running).

docker run -d -p 8080:80 --name my-nginx-app my-nginx-app	Runs a new container in the background, mapping ports.

docker ps	Shows running containers.

docker ps -a	Shows all containers (running + stopped).

curl http://192.168.64.116:8080	Sends a request to the running web server.


