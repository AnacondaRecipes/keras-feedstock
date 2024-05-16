#!/bin/bash

# remove eventual leftover config (will set the backend)
rm -f ~/.keras/keras.json

python -m pip install -vv $PKG_NAME-$PKG_VERSION-py3-none-any.whl
