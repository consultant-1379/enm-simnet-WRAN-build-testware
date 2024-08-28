#!/bin/sh

##script to delete wran nodes from netsim server##

for sim in `ls /netsim/netsimdir/ | grep FT | grep RNC`
do

echo "deleting simulation $sim"

#echo ".deleletesimulation $sim force" | /netsim/inst/netsim_pipe

done

