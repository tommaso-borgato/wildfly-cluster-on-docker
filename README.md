# Prerequisites
Must have Docker (Community Edition will suffice) running.

# Build war
Build war file to have something to deploy on wildfly:
```
mvn clean install
```
thsi application uses replicated HTTP session (`<distributable/>` tag in src/main/webapp/WEB-INF/web.xml).

# Build docker image with wildfly+war
Build a Docker image containig war running inside wildfly configured to run in clustered mode (`-server-config=standalone-ha.xml`)
```
docker build -t wildfly-sample-dockerfile .
```

# Create a dedicated Docker network
Defining a Docker network specifing gateway and subnet is necessary to assign specific IPs to containers:
```
docker network ls 
docker network create --driver bridge --gateway 172.19.0.1 --subnet 172.19.0.0/16 cluster_nw  
docker network inspect cluster_nw  
```

# Run a Docker web GUI
```
docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer  
```
The console is now available at:
http://localhost:9000/#/dashboard

# Run 2 Docker containers
Run 2 containers.  
Note that specific IPs are only needed to configure a mod_jk balancer later.
```
docker run --network=cluster_nw --ip 172.19.0.2 -p 8081:8080 -p 9991:9990 --name wildfly-sample-dockerfile-1 -t wildfly-sample-dockerfile  
docker run --network=cluster_nw --ip 172.19.0.3 -p 8082:8080 -p 9992:9990 --name wildfly-sample-dockerfile-2 -t wildfly-sample-dockerfile
```

# Check clustering is working
http://localhost:8081/Multicast/helloworld  
http://localhost:8082/Multicast/helloworld

# Inspect a Docker container
```
docker container ls --all  
docker exec -it 24d9244eb9f0 bash
```

# Remove a Docker container
```
docker container stop 8b64379c60e4  
docker container rm 8b64379c60e4
```
    
    
    