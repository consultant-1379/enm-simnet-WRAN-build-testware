#! /bin/sh
rm -rf ~/netsimdir/*RNC07*
rm -rf ~/netsimdir/*RNC08*
rm -rf ~/netsimdir/*RNC09*
rm -rf ~/netsimdir/*RNC10*
~/inst/restart_netsim
./createWranSimsParallel.sh 15K_trailer.env
~/inst/netsim_gui
