#!/bin/bash -xe

find ./ -not -wholename \*.tox/\* -and \
    \( -name \*.sh -or -wholename \*.d/\* -and \
    -not -name \*.md -and -not -name \*.rst -and \
    -not -name \*.py  -and -not -name \*.conf \) \
    -not -name \*.service -not -name \*.yaml \
    -print0 | xargs -0 bashate -v -i E006
