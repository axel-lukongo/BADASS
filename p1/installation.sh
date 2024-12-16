#!/bin/bash

set -e  # Arrêter le script en cas d'erreur

# Vérification des privilèges root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté avec des privilèges root." 
   exit 1
fi

# Variables
gns3_version="2.2"

echo "Mise à jour des paquets..."
apt update && apt upgrade -y

# Installation des dépendances requises
echo "Installation des dépendances..."
apt install -y \
    software-properties-common \
    curl \
    git \
    python3 \
    python3-pip \
    python3-venv \
    apt-transport-https \
    qemu \
    qemu-kvm \
    libvirt-clients \
    libvirt-daemon-system \
    virt-manager \
    bridge-utils \
    unzip \
    wget

# Ajout du dépôt GNS3
echo "Ajout du dépôt GNS3..."
add-apt-repository ppa:gns3/ppa -y

# Mise à jour des paquets après ajout du dépôt
apt update

# Installation de GNS3
echo "Installation de GNS3..."
apt install -y gns3-server gns3-gui

# Installation de Docker
echo "Installation de Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable\" > /etc/apt/sources.list.d/docker.list
apt update
apt install -y docker-ce docker-ce-cli containerd.io

# Ajout de l'utilisateur courant au groupe Docker
echo "Ajout de l'utilisateur $(whoami) au groupe docker..."
usermod -aG docker $(whoami)

# Installation de VMware Workstation Player ou VirtualBox (optionnel)
echo "Installation de VirtualBox (optionnel, peut être modifié pour VMware)..."
apt install -y virtualbox virtualbox-ext-pack

# Téléchargement et configuration de la GNS3 VM
echo "Téléchargement et configuration de la GNS3 VM..."
wget -O GNS3-VM.ova https://github.com/GNS3/gns3-gui/releases/download/v${gns3_version}/GNS3.VM.VMware.Workstation.ova

if command -v vboxmanage &> /dev/null; then
    echo "Importation de la GNS3 VM dans VirtualBox..."
    VBoxManage import GNS3-VM.ova
    VBoxManage modifyvm "GNS3 VM" --memory 4096 --cpus 2 --nic1 bridged
else
    echo "VMware Workstation Player est recommandé pour la GNS3 VM. Configure manuellement si nécessaire."
fi

# Configuration finale
echo "Configuration finale..."
systemctl enable --now libvirtd
echo "Installation terminée. Redémarrez votre système pour que toutes les configurations prennent effet."
echo "Lancez GNS3 et configurez la GNS3 VM pour une expérience complète. N'oubliez pas de tester Docker après votre redémarrage avec la commande: docker run hello-world"
