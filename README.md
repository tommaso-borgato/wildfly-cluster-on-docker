# Build war
mvn clean install

# Build docker image with wildfly+war
docker build -t wildfly-sample-dockerfile .

# Create a dedicated Docker network
docker network inspect bridge  
docker network create --driver bridge multicast_nw  
docker network inspect multicast_nw  

# Run a Docker web GUI
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer  
http://localhost:9000/#/dashboard

# Run 2 Docker containers
docker run --network=multicast_nw -p 8081:8080 -p 9991:9990 --name wildfly-sample-dockerfile-1 -t wildfly-sample-dockerfile  
docker run --network=multicast_nw -p 8082:8080 -p 9992:9990 --name wildfly-sample-dockerfile-2 -t wildfly-sample-dockerfile

# Check clustering is working
http://localhost:8081/Multicast/helloworld  
http://localhost:8082/Multicast/helloworld

# Inspect a Docker container
docker container ls --all  
docker exec -it 24d9244eb9f0 bash

# Remove a Docker container
docker container stop 8b64379c60e4  
docker container rm 8b64379c60e4

    
    
    