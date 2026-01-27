#!/bin/bash
set -e

BACKEND=$1

echo "============================================"
echo "Starting ISOLATED test for $BACKEND backend"
echo "============================================"

# Clear any loaded libraries (best effort)
unset LD_PRELOAD
unset DYLD_INSERT_LIBRARIES
unset DYLD_LIBRARY_PATH

# Run in subshell to isolate environment
(
    export KERAS_BACKEND=$BACKEND
    python tests/keras_backend_test.py $BACKEND
)

EXIT_CODE=$?

echo "============================================"
echo "Completed test for $BACKEND (exit: $EXIT_CODE)"
echo "============================================"

# Force cleanup
sleep 1

exit $EXIT_CODE