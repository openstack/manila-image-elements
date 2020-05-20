========================
Team and repository tags
========================

.. image:: https://governance.openstack.org/tc/badges/manila-image-elements.svg
    :target: https://governance.openstack.org/tc/reference/tags/index.html


=============================
Manila Image Elements Project
=============================

This repo is a place for Manila-related diskimage-builder elements.

* Free software: Apache license
* Source: https://opendev.org/openstack/manila-image-elements
* Bugs: https://bugs.launchpad.net/manila-image-elements
* Built Images: https://tarballs.openstack.org/manila-image-elements/images


Build instructions
~~~~~~~~~~~~~~~~~~

Before building the image, make sure all system dependencies
listed in bindep.txt file, are installed.

Default generic using tox
-------------------------

Script for creating Ubuntu based image with our elements and default parameters.

You should only need to run this command:

.. sourcecode:: bash

    tox -e buildimage

On completion, an Ubuntu minimal image with NFS+CIFS will be available for use.

Non-default image using tox
---------------------------

A finer-grained image creation control can be obtained by specifying extra parameters.
Precisely, the syntax is as follows:

.. sourcecode:: bash

    tox -e buildimage -- -s nfs

Where <share-protocol> can be nfs, cifs, zfs or nfs-ganesha.

For example, running:

.. sourcecode:: bash

    tox -e buildimage -- -s cifs

Will generate an Ubuntu based image with CIFS.

Configurable variables
----------------------

You can override some build variables from ``manila-image-create``, for example:

.. sourcecode:: bash

    export DHCP_TIMEOUT=600
    export MANILA_PASSWORD=PASSWORD
    tox -e buildimage
