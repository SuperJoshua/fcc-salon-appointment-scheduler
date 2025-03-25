#! /bin/bash

PSQL="psql -d salon -U freecodecamp -t -X -c"

$PSQL "truncate customers, appointments restart identity"
