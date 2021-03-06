#!/bin/sh
if [[ -z $ADMIN_PASSWORD ]]; then
	ADMIN_PASSWORD=$(date| md5sum | fold -w 8 | head -n 1)
	echo "##########GENERATED ADMIN PASSWORD: $ADMIN_PASSWORD  ##########"
fi
echo "AS_ADMIN_PASSWORD=" > /tmp/glassfishpwd
echo "AS_ADMIN_NEWPASSWORD=${ADMIN_PASSWORD}" >> /tmp/glassfishpwd
asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1
asadmin start-domain
echo "AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}" > /tmp/glassfishpwd
asadmin --user=admin --passwordfile=/tmp/glassfishpwd enable-secure-admin
asadmin --user=admin --passwordfile=/tmp/glassfishpwd --echo=true start-database --dbport 1527
asadmin --user=admin --passwordfile=/tmp/glassfishpwd --echo=true add-resources /glassfish-resources.xml
asadmin --user=admin --passwordfile=/tmp/glassfishpwd --echo=true deploy /MavenEnterpriseApp-ear.ear
asadmin --user=admin stop-domain
rm /tmp/glassfishpwd
exec "$@"
