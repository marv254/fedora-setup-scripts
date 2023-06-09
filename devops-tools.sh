#!/bin/bash
#DOCKER
#uninstall old docker/docker-engine
sudo dnf remove -y docker docker-client  docker-client-latest  docker-common docker-latest  docker-latest-logrotate docker-logrotate  docker-selinux docker-engine-selinux docker-engine
#Setup repository
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
#install docker engine
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

#Install nodejs && npm
sudo dnf module install -y  nodejs:18/common

#install kubectl
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum install -y kubectl
#enable kubectl autocompletion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'complete -o default -F __start_kubectl k' >>~/.bashrc

#install Minikube if it does not exist
if ! command -v minikube &> /dev/null
then
    # Minikube is not installed, so download and install it
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
    sudo rpm -Uvh minikube-latest.x86_64.rpm
fi

# Start Minikube with the qemu driver
minikube start --driver=qemu
rm -rf minikube-latest.x86_64.rpm

#install ansible
sudo dnf install -y ansible

#install terraform
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf -y install terraform
terraform -install-autocomplete

#install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws*

#install Jetbrains toolbox
# Download the latest version of JetBrains Toolbox
wget -O jetbrains-toolbox.tar.gz "https://data.services.jetbrains.com/products/download?code=TBA&platform=linux"
# Extract the downloaded file
sudo tar -xzf jetbrains-toolbox.tar.gz -C /opt
# Change to the extracted directory
cd /opt/jetbrains-toolbox-*
# Run the installer
./jetbrains-toolbox
# Remove the downloaded file and extracted directory
cd - 
rm -rf jetbrains-toolbox*

#install maven
sudo dnf install -y maven

#Installing Kubens
# Download the latest version of kubectx
curl -LO https://github.com/ahmetb/kubectx/releases/latest/download/kubectx
# Download the latest version of kubens
curl -LO https://github.com/ahmetb/kubectx/releases/latest/download/kubens
# Make the downloaded files executable
chmod +x kubectx kubens
# Move the files to a directory in your PATH
sudo mv kubectx kubens /usr/local/bin/

#Install eksctl
Download and extract the latest release of eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
Move the extracted binary to /usr/local/bin
sudo mv /tmp/eksctl /usr/local/bin

#Install helm
sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

#Install helmfile
curl -LO https://github.com/roboll/helmfile/releases/download/v0.144.0/helmfile_linux_amd64
# Make the binary executable
chmod +x helmfile_linux_amd64
# Move the binary to a directory in your PATH
sudo mv helmfile_linux_amd64 /usr/local/bin/helmfile
# Verify the installation
helmfile version

