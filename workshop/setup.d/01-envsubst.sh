#!/bin/bash
set -x
set +e

envsubst < /home/eduk8s/exercises/labs/pvc/pi/ingress.yaml.in > /home/eduk8s/exercises/labs/pvc/pi/ingress.yaml
envsubst < /home/eduk8s/exercises/labs/cm/demo/ingress.yaml.in > /home/eduk8s/exercises/labs/cm/demo/ingress.yaml