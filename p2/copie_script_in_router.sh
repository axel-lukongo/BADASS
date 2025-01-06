#!/bin/bash
cd $(dirname $0)
if [[ $1 == '' ]]; then
	echo "Please add either 'static' or 'multi' as argument."
	exit 0
fi

for cont_id in $(docker ps -q); do
	if [[ $(docker exec $cont_id hostname | cut -d '_' -f 1) == 'router' ]]; then
		docker cp ./config_VXLAN.sh $cont_id:/ && \
		docker exec $cont_id bash /config_VXLAN.sh $1
	fi
done


###### copie and exec the config_host #####
#for cont_id in $(docker ps -q); do
#        if [[ $(docker exec $cont_id hostname | cut -d '_' -f 1) == 'host' ]]; then
#                docker cp ./config_host.sh $cont_id:/ && \
#                docker exec $cont_id bash /config_host.sh
#        fi
#done

