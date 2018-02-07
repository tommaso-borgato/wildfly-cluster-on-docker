FROM karm/mod_cluster-master-dockerhub:latest

MAINTAINER tborgato@redhat.com

RUN dnf install -y hostname

# Your own entry point script located in the same directory as your Dockerfile
COPY docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh