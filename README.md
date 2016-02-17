# docker-phpvirtualbox

This is a fork of [clue/phpvirtualbox](https://hub.docker.com/r/clue/phpvirtualbox/), because it is not very up to date and there are no further configuration options.

## phpVirtualBox

[phpVirtualBox](http://sourceforge.net/projects/phpvirtualbox/) is a modern web interface that allows you to control remote VirtualBox instances - mirroring the VirtualBox GUI.

![](http://a.fsdn.com/con/app/proj/phpvirtualbox/screenshots/phpvb1.png)

## Usage
This image provides the phpVirtualBox web interface that communicates with any number of VirtualBox installations on your computers.

Internally, the phpVirtualBox web interface communicates with each VirtualBox installation through the `vboxwebsrv` program that is installed as part of VirtualBox.

The container is started with following command:

```
docker run --name vbox_http --restart=always \
    -p 80:80 \
    -e ID_PORT_18083_TCP=ServerIP:PORT \
    -e ID_NAME=serverName \
    -e ID_USER=vboxUser \
    -e ID_PW='vboxUserPassword' \
    -e CONF_browserRestrictFolders="/data,/home" \
    -d jazzdd/phpvirtualbox
```

* `-p {OutsidePort}:80` - will bind the webserver to the given host port
* `-d jazzdd/phpvirtualbox` - the name of this docker image
* `-e ID_NAME` - name of the vbox server
* `-e ID_PORT_18083_TCP` - ip/hostname and port of the vbox server
* `-e ID_USER` - user name of the user in the vbox group
* `-e ID_PW` - password of this user
* `-e CONF_varName` - override default config value of varName, browserRestrictFolders is a useful example. Coma-separated strings will be converted into an array.

ID is an identifier to get all matching environment variables for one vbox server. So, it is possible to define more then one VirtualBox server and manage it with one phpVirtualbox instance.

An example would look as follows:
```
docker run --name vbox_http --restart=always -p 80:80 \
    -e SRV1_PORT_18083_TCP=192.168.1.1:18083 -e SRV1_NAME=Server1 -e SRV1_USER=user1 -e SRV1_PW='test' \
    -e SRV2_PORT_18083_TCP=192.168.1.2:18083 -e SRV2_NAME=Server2 -e SRV2_USER=user2 -e SRV2_PW='test' \
    -d jazzdd/phpvirtualbox
```

## Running vboxwebsrv as a container
Instead of using environment variables to configure the server connection, the [jazzdd86/vboxwebsrv](https://github.com/jazzdd86/vboxwebsrv) image could be used to establish a secure ssh connection to the server and start the vboxwebsrv service on demand.

See [jazzdd86/vboxwebsrv](https://github.com/jazzdd86/vboxwebsrv) for more information on how to start the vboxwebsrv service via docker image.

Example:
```bash
$ docker run -it --name=vbox_websrv_1 --restart=always jazzdd/vboxwebsrv vbox@10.1.2.3
```

To run phpVirtualbox with the vboxwebsrv container use following command:

```bash
$ docker run --name vbox_http --restart=always -p 80:80 --link vbox_websrv_1:MyComputer -d jazzdd/phpvirtualbox
```

## Configurations
As mentioned before `-e CONF_varName` can override default config values of varName. This configuration options can be used in various ways:

```bash
$ docker run -it --name=vbox_websrv_1 --restart=always -e CONF_browserRestrictFolders="/data,/home" jazzdd/vboxwebsrv vbox@10.1.2.3
$ docker run --name vbox_http --restart=always \
    -e SRV1_PORT_18083_TCP=192.168.1.1:18083 -e SRV1_NAME=Server1 -e SRV1_USER=user1 -e SRV1_PW='test' \
    -e SRV2_PORT_18083_TCP=192.168.1.2:18083 -e SRV2_NAME=Server2 -e SRV2_USER=user2 -e SRV2_PW='test' \
    -e SRV1_CONF_browserRestrictFolders="/data,/home" \
    -e CONF_browserRestrictFolders="/data," \
    -d jazzdd/phpvirtualbox
```

* 1. config for specific server with usage of vboxwebsrv image
* 2. `-e SRV1_CONF_browserRestrictFolders="/data,/home"` - config for specific server with usage of environment variables
* 3. `-e CONF_browserRestrictFolders="/data,"` - global configuration - valid for all servers without local configuration parameter

If an option requires an array but only one parameter is given enter a comma after the option, because an array is generated if there is an , character (see option 3).
