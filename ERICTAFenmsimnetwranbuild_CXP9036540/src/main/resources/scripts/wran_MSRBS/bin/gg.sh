#!/bin/sh

./Get_Freeip.sh

OFFSET=$( cat /netsim/wran_MSRBS/bin/availableip.txt | head -2 | tail -1)

echo "$OFFSET"
