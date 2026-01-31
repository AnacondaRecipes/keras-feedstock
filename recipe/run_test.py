
#!/usr/bin/env python3
import os
import sys
import subprocess
import importlib

def run_command(cmd, shell=False):
    if isinstance(cmd, str) and not shell:
        cmd = cmd.split()
    
    print(f"Running: {' '.join(cmd) if isinstance(cmd, list) else cmd}")
    result = subprocess.run(cmd, shell=shell)
    
    if result.returncode != 0:
        sys.exit(result.returncode)
    
    return result

def import_for_backend(backend):
    """Import Keras modules for a specific backend"""
    print(f"Setting up backend: {backend}")
    
    # Set environment variable and test basic import
    os.environ['KERAS_BACKEND'] = backend
    
    try:
        # Test imports equivalent to the original script
        import keras
        import keras.backend
        import keras.datasets
        import keras.layers
        import keras.utils
        print(f"Successfully imported Keras modules for {backend} backend")
    except ImportError as e:
        print(f"Failed to import Keras modules for {backend} backend: {e}")
        sys.exit(1)

def main():

    # JAX BACKEND
    import_for_backend("jax")
    run_command("python integration_tests/jax_custom_fit_test.py")

    # TORCH BACKEND
    import_for_backend("torch")
    run_command("pytest integration_tests/torch_workflow_test.py")
    run_command("python integration_tests/torch_custom_fit_test.py")

    # TENSORFLOW BACKEND
    import_for_backend("tensorflow")
    run_command("python integration_tests/tf_distribute_training_test.py")
    run_command("python integration_tests/tf_custom_fit_test.py")

if __name__ == "__main__":
    main()