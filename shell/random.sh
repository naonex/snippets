#!/bin/bash

if [ $RANDOM -lt 10000 ]; then
  RETURN=0
else
  RETURN=1
fi

echo $RETURN

exit $RETURN
