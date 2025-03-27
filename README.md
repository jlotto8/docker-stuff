# Docker Practice
## Family Tree Project - Dockerized

This project containerizes the **Family Tree Python program** using Docker. The guide provides step-by-step instructions to set up Docker, create a Dockerfile, and run the application inside a container.
---

## **1. Prerequisites**
- Have a working **Multipass VM**, have a text editor, have Git installed. Run the following to setup your computer if needed: 
Linux: `bash setup-linux.sh`
Mac: `bash setup-mac.sh`
---

### Starting the VM
Run the following command to create the vm: `bash create-vm.sh`

### To SSH into the vm:
`ssh -i id_ed25519 -o StrictHostKeyChecking=no relativepath@$(multipass info relativepath | grep IPv4 | awk '{print $2}')`

### Installing docker inside the VM
Transfer the automated docker installation script from your local machine to the VM:
`multipass transfer installDocker.sh relativepath:/home/relativepath/installDocker.sh`

### Permissions note
 If changes in the permissions of /home/relativepath are needed to allow access for the user that is performing the transfer:
Shell into the VM:
`multipass shell relativepath`
`sudo chmod 755 /home/relativepath`
`exit`
re-run the transfer command

## **2. Transferring the Family Tree Project to the VM**
### **Clone from GitHub**
`git clone https://github.com/jlotto8/Family-Tree`
cd Family-Tree

### Creating a requirements.txt file
This Python program uses external libraries (Graphviz, CSV reading, etc.)
Docker needs to install these dependencies when building the container:
`nano requirements.txt`
- add any needed dependencies
- graphviz → Needed for rendering the family tree visualization.
- pandas → Might be useful for handling CSV data more efficiently.

## Creating a Dockerfile
Inside  project folder, create a file named Dockerfile:
`nano Dockerfile`

# Use an official Python base image
FROM python:3.10

# Install system dependencies for Graphviz
RUN apt-get update && apt-get install -y graphviz

# Set the working directory inside the container
WORKDIR /app

# Copy only the family_tree directory into the container
COPY family_tree /app/family_tree

# Copy the requirements file separately
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r /app/requirements.txt

# Set the working directory to the script's location
WORKDIR /app/family_tree

# Ensure the correct file is executed
CMD ["python", "family_tree.py"]

## Building the Docker Image
Run the following command inside the family-tree directory to build the Docker image:
docker build -t family-tree-app .
- ** `docker build`** → Tells Docker to build an image.
- **`-t family-tree-app**` → Names the image family-tree-app.
- **`.`** → Uses the current directory as the build context.

## Running the container
Run the foolowing ccommand to start the container:
`docker run --name family-tree-container family-tree-app`
- **`docker run`** → Runs a new container.
- **`--name family-tree-container`** → Gives the container a readable name.
- **`family-tree-app`** → Uses the `family-tree-app` image created in step 4.

## Running in Interactive Mode (Optional)
If your program requires user input, use: 
`docker run -it family-tree-app`

## Listing Running Containers
To check which containers are currently **running**, use:
`docker ps`
### To check all containers, including stopped ones:
`docker ps -a`

##Stopping & Removing Containers
To stop a running container:
`docker stop family-tree-container`

###To remove a stopped container:
`docker rm family-tree-container`

### To remove all stopped containers:
`docker container prune`
- docker stop family-tree-container → Stops the running container.
- docker rm family-tree-container → Removes the stopped container.
- docker container prune → Deletes all containers that are no longer running.

### Removing Docker Images
To remove the family-tree-app image:
`docker rmi family-tree-app`
- docker rmi family-tree-app → Deletes the image named family-tree-app.
- This won't work if any containers are still using the image—remove them first.

### Cleaning Up
To remove all containers, images, and networks:
`docker system prune -a`
- docker system prune -a → Deletes all unused images, containers, and networks.
- Use this command carefully, as it removes everything not actively in use.

#### Next Steps
- Add Docker Compose to manage dependencies.
- Create persistent storage for saved data.
- Deploy the container on a cloud platform.

#### Command Purpose

| **Command** | **Purpose** |
|------------|------------|
| `docker build -t my-nginx-app .` | Builds a Docker image from the Dockerfile in the current directory. |
| `docker rm -f my-nginx-app` | Forcefully removes a container (stopped or running). |
| `docker run -d -p 8080:80 --name my-nginx-app my-nginx-app` | Runs a new container in the background, mapping ports. |
| `docker ps` | Shows running containers. |
| `docker ps -a` | Shows all containers (running + stopped). |
| `curl http://192.168.64.116:8080` | Sends a request to the running web server. |


