========================
Team and repository tags
========================

.. image:: http://governance.openstack.org/badges/manila-image-elements.svg
    :target: http://governance.openstack.org/reference/tags/index.html

.. Change things from this point on

=============================
Manila Image Elements Project
=============================

This repo is a place for Manila-related diskimage-builder elements.

* Free software: Apache license
* Source: http://git.openstack.org/cgit/manila-image-elements
* Bugs: http://bugs.launchpad.net/manila-image-elements
* Built Images: http://tarballs.openstack.org/manila-image-elements/images


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

On completion, an Ubuntu minimal image with NFS will be available for use.

Non-default image using tox
---------------------------

A finer-grained image creation control can be obtained by specifying extra parameters.
Precisely, the syntax is as follows:

.. sourcecode:: bash

    tox -e buildimage -- -s nfs

Where <share-protocol> can be nfs, cifs or zfs.

For example, running:

.. sourcecode:: bash

    tox -e buildimage -- -s cifs

Will generate an Ubuntu based image with CIFS.
