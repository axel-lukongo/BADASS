#!/bin/bash
cd $(dirname $0)
for cont_id in $(docker ps -q); do
	hostname=$(docker exec $cont_id hostname)
	if [[ $(echo $hostname | cut -d '_' -f 1) == 'router' ]]; then
		if [[ $(echo $hostname | cut -d '-' -f 2) == '2' ]] \
		|| [[ $(echo $hostname | cut -d '-' -f 2) == '4' ]]; then
			docker cp ./router_vxlan_config.sh $cont_id:/ && \
			docker exec $cont_id bash /router_vxlan_config.sh
		fi
		docker cp ./router_evpn_config.sh $cont_id:/ && \
		docker exec $cont_id bash /router_evpn_config.sh
	fi
done