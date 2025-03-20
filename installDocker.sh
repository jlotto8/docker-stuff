# Set up Docker's apt repository in the following two steps:

# 2. Add Docker's official GPG key:

# Check if ca-certificates exists, if not, install it.
if apt-cache show 'ca-certificates'
then
  echo 'The ca-certificates package is already installed. 👏'
else
  echo 'Installing ca-certificates... ⏳'
  sudo apt-get install -y ca-certificates
fi

# Check if curl exists, if not, install it.
if apt-cache show 'curl'
then
  echo 'The curl package is already installed. 👏'
else
  echo 'Installing curl... ⏳'
  sudo apt-get install -y curl
fi

# Check if the keyrings directory exists & if not, create it
if [ -d /etc/apt/keyrings ]
then
  echo 'The keyrings directory already exists. 👌'
else
  echo 'The keyrings directory does not exist. Creating it...✨'
  sudo install -m 0755 -d /etc/apt/keyrings
fi

# Check if the Docker GPG key exists & if not, install it
if [ -f /etc/apt/keyrings/docker.asc ]
then
  echo 'The Docker GPG key already exists. 🔑'
else
  echo 'The Docker GPG key does not exist. Downloading it...⬇️'
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
fi

# Check read permissions for the Docker GPG key
if [ -r /etc/apt/keyrings/docker.asc ]
then
  echo 'The Docker GPG key has the correct permissions. 👍'
else
  echo 'Setting correct permissions for the Docker GPG key... 🐳'
  sudo chmod a+r /etc/apt/keyrings/docker.asc
fi

# Check if the repository file exists, add it to Apt sources if it does not, then update the list of available packages and their versions from the newly added Docker repository 
if (stat /etc/apt/sources.list.d/docker.list)
then
   echo 'Repository already exists at /etc/apt/sources.list.d/docker.list'
else
   echo 'Repository not found. Adding repository.'
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   sudo tee /etc/apt/sources.list.d/docker.list && sudo apt update
fi

# Install the latest version

# Check if the containerd.io package is in the apt-cache
if apt-cache show 'containerd.io'
then
  echo "The containerd.io package is in the apt-cache 👍"
else
  echo "containerd.io not found in the apt-cache. Updating the package list 🔄"
  sudo apt update
fi

# Check if the containerd.io package is installed
if dpkg -s containerd.io
then
  echo "containerd.io package is already installed. 👏"
else
  echo "Installing containerd.io... ⏳"
  sudo apt-get install -y containerd.io
  echo "containerd.io installation complete! ✅"
fi

# Install docker-ce
if dpkg -s docker-ce
then
  echo "docker-ce is already installed"
else
  echo "Installing docker-ce"
  sudo apt-get install -y docker-ce
fi

# Install docker-ce-cli
if dpkg -s docker-ce-cli
then
  echo "docker-ce-cli is already installed"
else
  echo "docker-ce-cli not installed, installing now"
  sudo apt-get install -y docker-ce-cli
fi

# Install docker-buildx-plugin
if dpkg -s docker-buildx-plugin
then
  echo 'docker-buildx-plugin already installed'
else
  echo 'Installing docker-buildx-plugin'
  sudo apt-get install -y docker-buildx-plugin
fi

# Install docker compose
if dpkg -s docker-compose-plugin
then
  echo "docker-compose-plugin is already installed"
else
  echo "docker-compose-plugin is not installed, installing it now"
  sudo apt-get install -y docker-compose-plugin
fi

# Apply the group change in the current terminal session
if grep docker /etc/group
then
  echo 'The docker group already exists'
else
  echo 'Creating the 'docker' group'
  sudo groupadd docker
fi

# Check if the user "ubuntu" is in the "docker" group
if grep -q "docker" /etc/group && grep -q "ubuntu" /etc/group
then
  echo 'User "ubuntu" is already in the docker group'
else
  echo 'Adding user "ubuntu" to the docker group'
  sudo usermod -aG docker ubuntu
fi

# Confirmation for the install
if (which docker)
then 
  echo "congrats you have docker installed"
  docker -v
else
  echo 'Oops, something is fucked up!'
fi

