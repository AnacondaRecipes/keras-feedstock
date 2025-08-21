#!/bin/bash
set -euxo pipefail

function import_for_backend {
  backend=$1
  python -c "import os; os.environ['KERAS_BACKEND'] = '$backend'; import keras;"
  export KERAS_BACKEND=$backend
  python -c "import keras;"
  python -c "import keras.backend;"
  python -c "import keras.datasets;"
  python -c "import keras.layers;"
  python -c "import keras.utils;"
}

pip check

# Temporary commented, till jax will be updated 
# JAX BACKEND
# import_for_backend jax
# python integration_tests/jax_custom_fit_test.py

# TORCH BACKEND
import_for_backend torch
pytest integration_tests/torch_workflow_test.py
python integration_tests/torch_custom_fit_test.py

# TENSORFLOW BACKEND
import_for_backend tensorflow
python integration_tests/tf_distribute_training_test.py
python integration_tests/tf_custom_fit_test.py