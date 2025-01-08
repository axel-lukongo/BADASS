#!/bin/bash
#!/bin/bash
# Liste les conteneurs Docker en cours d'exécution
ids=$(docker ps --format '{{.ID}}')

# Déclare un tableau associatif pour mapper les noms d'hôtes aux IDs des conteneurs
declare -A hostmap
for i in $ids
do
    # Récupère le nom d'hôte du conteneur
    name=$(docker exec -i $i hostname)
    hostmap[$name]=$i    
done

# Debug : Afficher les noms d'hôtes disponibles
declare -p hostmap

# Vérifie que l'utilisateur a fourni un argument
if [[ -z $1 ]]; then
    echo "Error: No host specified. Usage: $0 <hostname>"
    echo "Available hosts:"
    for key in "${!hostmap[@]}"; do
        echo "- $key"
    done
    exit 1
fi

# Vérifie si l'hôte spécifié existe dans le tableau
if [[ -z ${hostmap[$1]} ]]; then
    echo "Error: Host $1 not found. Available hosts are:"
    for key in "${!hostmap[@]}"; do
        echo "- $key"
    done
    exit 1
fi

# Vérifie si le conteneur cible est un routeur avant d'exécuter vtysh
if [[ $1 == router* ]]; then
    echo "Executing commands on router $1..."
    docker exec -i ${hostmap[$1]} sh << EOF
vtysh << INNER
do sh ip route
do sh bgp summary
do sh bgp l2vpn evpn
INNER
EOF
else
    echo "Error: $1 is not a router. vtysh is only available on routers."
    exit 1
fi

