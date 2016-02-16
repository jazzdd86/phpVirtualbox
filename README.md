# docker-phpvirtualbox

This is a fork of [clue/phpvirtualbox](https://hub.docker.com/r/clue/phpvirtualbox/), because it is not very up to date.

## phpVirtualBox

[phpVirtualBox](http://sourceforge.net/projects/phpvirtualbox/) is a modern web interface that allows
you to control remote VirtualBox instances - mirroring the VirtualBox GUI.

![](http://a.fsdn.com/con/app/proj/phpvirtualbox/screenshots/phpvb1.png)

## Usage
This image provides the phpVirtualBox web interface that communicates with any
number of VirtualBox installations on your computers.

Internally, the phpVirtualBox web interface communicates with each VirtualBox installation through the `vboxwebsrv` program that is installed as part of VirtualBox.

The container is started with following command:

```
docker run --name vbox_http --restart=always \
    -p 80:80 \
    -e ID_PORT_18083_TCP=ServerIP:PORT \
    -e ID_NAME=serverName \
    -e ID_USER=vboxUser \
    -e ID_PW='vboxUserPassword' \
    -e CONFIG_browserRestrictFolders="/home/vbox,/home/cd-images" \
    -d jazzdd/phpvirtualbox
```

* `-p {OutsidePort}:80` - will bind the webserver to the given host port
* `-d jazzdd/phpvirtualbox` - the name of this docker image
* `-e ID_NAME` - name of the vbox server
* `-e ID_PORT_18083_TCP` - ip/hostname and port of the vbox server
* `-e ID_USER` - user name of the user in the vbox group
* `-e ID_PW` - password of this user
* `-e CONFIG_varName` - overrige default config value of varName, browserRestrictFolders is useful example. Coma-separated strings will be converted into array

ID is an identifier to get all matching environment variables for one vbox server. So, it is possible to define more then one vbox server and manage it with one phpVirtualbox instance.

An example would look as follows:
```
docker run --name vbox_http --restart=always -p 80:80 \
    -e SRV1_PORT_18083_TCP=192.168.1.1:18083 -e SRV1_NAME=Server1 -e SRV1_USER=user1 -e SRV1_PW='test' \
    -e SRV2_PORT_18083_TCP=192.168.1.2:18083 -e SRV2_NAME=Server2 -e SRV2_USER=user2 -e SRV2_PW='test' \
    -d jazzdd/phpvirtualbox
```
