# There should be an ssh key pair
if (stat id_ed25519)
then
  echo "key pair already exists."
else
  echo "generating key pair."
  ssh-keygen -t ed25519 -f ./id_ed25519 -N ''
fi  

# Cloud init user-data should exist
if (grep "$(cat ./id_ed25519.pub)" ./user-data)
then
  echo "user data already exists."
else
  echo "creating user data cloud init."
  cat <<-EOF > ./user-data
#cloud-config

users:
  - default
  - name: relativepath
    shell: /bin/bash
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    ssh_authorized_keys:
      - $(cat ./id_ed25519.pub)
EOF
fi

# The vm relativepath should exist
if (multipass info relativepath)
then
  echo "relativepath vm already exists" 
else
  echo "creating vm relativepath"
  multipass launch --name relativepath --cpus 4 --memory 4G --disk 20G --cloud-init user-data
fi


