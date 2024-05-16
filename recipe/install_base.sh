#!/bin/bash


echo ~/.keras/keras.json
cat ~/.keras/keras.json
ls ~/.keras/keras.json

# remove eventual leftover config (will set the backend)
rm -f ~/.keras/keras.json

python -m pip install -vv $PKG_NAME-$PKG_VERSION-py3-none-any.whl
