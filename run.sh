#!/bin/bash
ACTION=${1:-}
if [ ! -e "/docker.sock" ] ; then
    echo "You must map your Docker socket to /docker.sock (i.e. -v /var/run/docker.sock:/docker.sock)"
    exit 2
fi

if [ -z "$ACTION" ] ; then
    echo "Usage: "
    echo "  netdot/deploy <action>"
    echo ""
    echo "Examples: "
    echo "  docker run netdot/deploy setup"
    echo "     Deploys Netdot stack"
    echo "  docker run netdot/deploy cleanup"
    echo "     Removes Netdot stack"
    exit 1
fi

function cleanup {
    for CNT in netdot_apache netdot_db netdot_init
    do
        docker -H unix://docker.sock kill $CNT > /dev/null 2>&1
        docker -H unix://docker.sock rm $CNT > /dev/null 2>&1
    done
}

function purge {
    cleanup
    for IMG in netdot_db netdot
    do
        docker -H unix://docker.sock rmi 42wim/$IMG > /dev/null 2>&1
    done
}

if [ "$ACTION" = "setup" ] ; then
    echo "
This may take a moment while the Netdot images are pulled..."
    echo "Starting Mysql..."
    db=$(docker -H unix://docker.sock run -i -t -d -p 3306 --name netdot_db 42wim/netdot_db)
    sleep 4
    echo "Starting Apache.."
    echo "initializing..."
    apache=$(docker -H unix://docker.sock run -i -t -d --link netdot_db:db --name netdot_init 42wim/netdot /init.sh)
    echo "really starting now..."
    apache=$(docker -H unix://docker.sock run -i -t -d -p 8888:80 --link netdot_db:db --name netdot_apache 42wim/netdot /usr/sbin/httpd -DFOREGROUND)
    sleep 2
    echo "
Netdot Stack Deployed

You should be able to login with admin:admin http://<docker-host-ip>:8888/netdot/
"
elif [ "$ACTION" = "cleanup" ] ; then
    cleanup
    echo "Netdot Stack Removed"
elif [ "$ACTION" = "purge" ] ; then
    echo "Removing Netdot images.  This could take a moment..."
    purge
fi
