#!/bin/bash

if [ $# -eq 3 ]; then
	echo "All three positional parameters given: $1 $2 $3. Exiting with error code 0."
	exit 0
elif [ $# -eq 2 ]; then
	echo "Missing \$3. Exiting with error code 1."
	exit 1
elif [ $# -eq 1 ]; then
	echo "Missing \$2 and \$3. Exiting with error code 2."
	exit 2
elif [ $# -eq 0 ]; then
	echo "Missing \$1, \$2 and \$3. Exiting with error code 3."
	exit 3
fi
