FROM alpine:latest

# Installer les outils nécessaires
RUN apk add --no-cache quagga busybox

# Créer les fichiers de configuration pour Quagga
RUN mkdir -p /etc/quagga && \
    touch /etc/quagga/bgpd.conf /etc/quagga/ospfd.conf /etc/quagga/isisd.conf && \
    echo "log file /var/log/quagga/bgpd.log" > /etc/quagga/bgpd.conf && \
    echo "log file /var/log/quagga/ospfd.log" > /etc/quagga/ospfd.conf && \
    echo "log file /var/log/quagga/isisd.log" > /etc/quagga/isisd.conf

# Configurer le fichier zebra.conf pour activer les services de routage
RUN echo "hostname zebra" > /etc/quagga/zebra.conf && \
    echo "log file /var/log/quagga/zebra.log" >> /etc/quagga/zebra.conf

# Activer les services de Quagga
CMD ["zebra", "-d", "--keep-foreground"]
