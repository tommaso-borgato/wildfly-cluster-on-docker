# ========================================
# DOCKERFILE FOR WILDFLY (WORKER NODE)
# ========================================
FROM jboss/wildfly

MAINTAINER tborgato@redhat.com

#ARG WAR_FINAL_NAME
ADD target/*.war /opt/jboss/wildfly/standalone/deployments/

RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent

# ========================================
# CREATE LAUNCH SCRIPT
# ========================================
RUN /bin/bash -c "echo '#!/bin/bash' > /tmp/jboss.sh"
# HOSTNAME
RUN /bin/bash -c "echo 'HOSTNAME=\$(hostname -i)' >> /tmp/jboss.sh"
RUN /bin/bash -c "echo 'echo \"HOSTNAME=\$HOSTNAME\"' >> /tmp/jboss.sh"
# MODIFY standalone-ha.xml
RUN /bin/bash -c "echo $'/opt/jboss/wildfly/bin/jboss-cli.sh <<EOF \n\
embed-server --std-out=echo --server-config=standalone-ha.xml \n\
/interface=multicast:add(inet-address=\$HOSTNAME) \n\
/socket-binding-group=standard-sockets/socket-binding=jgroups-mping:write-attribute(name=interface, value=multicast) \n\
/socket-binding-group=standard-sockets/socket-binding=jgroups-tcp:write-attribute(name=interface, value=multicast) \n\
/socket-binding-group=standard-sockets/socket-binding=jgroups-udp:write-attribute(name=interface, value=multicast) \n\
quit \n\
EOF\n'\
>> /tmp/jboss.sh"

# START WILDFLY
# CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-server-config=standalone-ha.xml"]
RUN /bin/bash -c "echo \"/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -server-config=standalone-ha.xml\" >> /tmp/jboss.sh"

RUN /bin/bash -c "chmod +x /tmp/jboss.sh"

CMD "/tmp/jboss.sh"
