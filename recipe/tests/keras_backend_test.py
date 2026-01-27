#!/usr/bin/env python3
"""
tests/keras_backend_test.py
Run tests for a SINGLE backend only
"""
import os
import sys
import subprocess

def run_command(cmd, shell=False):
    if isinstance(cmd, str) and not shell:
        cmd = cmd.split()
    
    print(f"Running: {' '.join(cmd) if isinstance(cmd, list) else cmd}")
    result = subprocess.run(cmd, shell=shell)
    
    if result.returncode != 0:
        sys.exit(result.returncode)
    
    return result

def main():
    if len(sys.argv) != 2:
        print("Usage: python keras_backend_test.py <backend>")
        print("Available: jax, torch, tensorflow")
        sys.exit(1)
    
    backend = sys.argv[1].lower()
    
    # Set backend BEFORE any imports
    os.environ['KERAS_BACKEND'] = backend
    
    print(f"\n{'='*60}")
    print(f"Testing {backend.upper()} backend ONLY")
    print(f"{'='*60}\n")
    
    # Verify backend loads
    try:
        import keras
        actual_backend = keras.backend.backend()
        print(f"✓ Keras loaded with backend: {actual_backend}")
        
        if actual_backend != backend:
            print(f"✗ ERROR: Expected {backend} but got {actual_backend}")
            sys.exit(1)
    except ImportError as e:
        print(f"✗ Failed to import Keras: {e}")
        sys.exit(1)
    
    # Run ONLY tests for THIS backend
    if backend == 'jax':
        print("\nRunning JAX tests...")
        run_command("python integration_tests/jax_custom_fit_test.py")
        
    elif backend == 'torch':
        print("\nRunning Torch tests...")
        run_command("pytest integration_tests/torch_workflow_test.py")
        run_command("python integration_tests/torch_custom_fit_test.py")
        
    elif backend == 'tensorflow':
        print("\nRunning TensorFlow tests...")
        run_command("python integration_tests/tf_distribute_training_test.py")
        run_command("python integration_tests/tf_custom_fit_test.py")
        
    else:
        print(f"✗ Unknown backend: {backend}")
        sys.exit(1)
    
    print(f"\n{'='*60}")
    print(f"✓ {backend.upper()} tests PASSED")
    print(f"{'='*60}\n")

if __name__ == "__main__":
    main()