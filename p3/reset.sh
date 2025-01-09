#!/bin/bash

cd $(dirname $0)

# Vérifier si un paramètre a été fourni
RESET_MODE=false
if [[ $1 == "--reset" ]]; then
    RESET_MODE=true
    echo "Mode reset activé : les configurations seront supprimées."
fi

# Parcourir tous les conteneurs en cours d'exécution
for cont_id in $(docker ps -q); do
    hostname=$(docker exec $cont_id hostname)

    # Vérifier si le conteneur est un routeur
    if [[ $(echo $hostname | cut -d '_' -f 1) == 'router' ]]; then
        
        # Si le flag --reset est activé, exécuter le script de réinitialisation
        if $RESET_MODE; then
            echo "Réinitialisation des configurations pour $hostname..."
            docker cp ./router_reset_conf.sh $cont_id:/ && \
            docker exec $cont_id bash /router_reset_conf.sh
            continue
        fi

        # Appliquer les configurations normales
        if [[ $(echo $hostname | cut -d '-' -f 2) == '2' ]] \
        || [[ $(echo $hostname | cut -d '-' -f 2) == '4' ]]; then
            docker cp ./router_vxlan_conf.sh $cont_id:/ && \
            docker exec $cont_id bash /router_vxlan_conf.sh
        fi
        docker cp ./router_evpn_conf.sh $cont_id:/ && \
        docker exec $cont_id bash /router_evpn_conf.sh
    fi
done

