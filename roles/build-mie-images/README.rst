build-mie-images
================

An ansible role to build images with manila-image-elements

Role Variables
--------------

.. zuul:rolevar:: mie_project_path
     :type: string
     :default: {{ zuul.projects['opendev.org/openstack/manila-image-elements'].src_dir }}

   Path of the manila-image-elements repository.

.. zuul:rolevar:: images_to_build
     :type: list
     :default: ['generic', 'cephfs']

   One or more image types to build.
