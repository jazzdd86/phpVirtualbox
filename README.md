# docker-phpvirtualbox

[phpVirtualBox](http://sourceforge.net/projects/phpvirtualbox/) is a modern web interface that allows
you to control remote VirtualBox instances - mirroring the VirtualBox GUI.
This is a [docker](https://www.docker.io) image that eases setup.

## About phpVirtualBox

> *From [the official description](http://sourceforge.net/projects/phpvirtualbox/):*

An open source, AJAX implementation of the VirtualBox user interface written in PHP.
As a modern web interface, it allows you to access and control remote VirtualBox instances.
phpVirtualBox is designed to allow users to administer VirtualBox in a headless
environment - mirroring the VirtualBox GUI through its web interface.

![](http://a.fsdn.com/con/app/proj/phpvirtualbox/screenshots/phpvb1.png)

## Usage

Using this image for the first time will start a download automatically.
Further runs will be immediate, as the image will be cached locally.

This image provides the phpVirtualBox web interface that communicates with any
number of VirtualBox installations on your computers.

Internally, the phpVirtualBox web interface communicates with each VirtualBox installation through the
`vboxwebsrv` program that is installed as part of VirtualBox.
So for every computer connected to the phpVirtualbox instance, we're going to use a minimal container
that eases exposing the `vboxwebsrv`.


You can now point your webbrowser to this URL:

```
http://vbox.jotunheim.de
```

This is a rather common setup following docker's conventions:

* `-d` will run a detached session running in the background
* `-p {OutsidePort}:80` will bind the webserver to the given outside port
* `--link {ContainerName}:{DisplayName}` links a `vboxwebsrv` instance with the given {ContainerName} and exposes it under the visual {DisplayName}
* `jazz/phpvirtualbox` the name of this docker image