@echo off
setlocal enabledelayedexpansion

REM Function equivalent for Windows
:import_for_backend
set backend=%1
python -c "import os; os.environ['KERAS_BACKEND'] = '%backend%'; import keras;"
if errorlevel 1 exit /b 1

set KERAS_BACKEND=%backend%
python -c "import keras;"
if errorlevel 1 exit /b 1

python -c "import keras.backend;"
if errorlevel 1 exit /b 1

python -c "import keras.datasets;"
if errorlevel 1 exit /b 1

python -c "import keras.layers;"
if errorlevel 1 exit /b 1

python -c "import keras.utils;"
if errorlevel 1 exit /b 1

goto :eof

pip check
if errorlevel 1 exit /b 1

REM Temporary commented, till jax will be updated 
REM Testing JAX BACKEND
@REM call :import_for_backend jax
@REM if errorlevel 1 exit /b 1

@REM python integration_tests/jax_custom_fit_test.py
@REM if errorlevel 1 exit /b 1

REM Testing TORCH BACKEND  
call :import_for_backend torch
if errorlevel 1 exit /b 1

pytest integration_tests/torch_workflow_test.py
if errorlevel 1 exit /b 1

python integration_tests/torch_custom_fit_test.py
if errorlevel 1 exit /b 1

REM Testing TENSORFLOW BACKEND
call :import_for_backend tensorflow
if errorlevel 1 exit /b 1

python integration_tests/tf_distribute_training_test.py
if errorlevel 1 exit /b 1

python integration_tests/tf_custom_fit_test.py
if errorlevel 1 exit /b 1

echo All tests completed successfully!