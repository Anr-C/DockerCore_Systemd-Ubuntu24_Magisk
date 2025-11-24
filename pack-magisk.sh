#!/bin/sh

zip -r -9 ../DockerCore_Systemd-Ubuntu24_Magisk.zip . \
    -x ".git/*" \
    -x ".gitignore" \
    -x "LICENSE" \
    -x "README.md" \
    -x "pack-magisk.sh"