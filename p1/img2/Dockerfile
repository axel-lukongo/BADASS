FROM alpine:latest
RUN apk add --no-cache quagga busybox
# Créer les fichiers de configuration nécessaires pour Quagga
RUN touch /etc/quagga/bgpd.conf /etc/quagga/ospfd.conf /etc/quagga/isisd.conf
CMD ["sh"]
