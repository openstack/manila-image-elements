build-mie-images
================

An ansible role to build images with manila-image-elements

Role Variables
--------------

.. zuul:rolevar:: images_to_build
     :type: list
     :default: ['generic', 'cephfs']


   One or more image types to build.
