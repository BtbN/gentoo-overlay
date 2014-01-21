#!/bin/bash

action="$1"

case $action in
  add)
    rc-update -q add vmware-workstation-server default
    /etc/init.d/vmware-workstation-server start
    ;;
  remove)
    rc-update -q del vmware-workstation-server default
    /etc/init.d/vmware-workstation-server stop
    ;;
  status)
    /etc/init.d/vmware-workstation-server status
    ;;
  *)
    exit 1
    ;;
esac
