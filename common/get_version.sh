#!/usr/bin/env bash

TARBALL=$1
DATE=`which date`

if [[ ${TARBALL} = *"master"* ]]
then
    ${DATE} +'%Y%m%d'
else
    echo ${TARBALL} | sed -r 's/.*qdb-([0-9\.a-z_]+)-linux-.*/\1/'
fi
