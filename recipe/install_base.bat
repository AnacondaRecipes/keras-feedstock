@REM silently remove eventual leftover config (will set the backend)
del %HOMEPATH%/.keras/keras.json 2> nul

%PYTHON% setup.py install --single-version-externally-managed --record record.txt
