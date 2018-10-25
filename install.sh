#!/usr/bin/env bash

MAIN_PY="
import os.path
activate_this = os.path.join(os.path.dirname(__file__), '../env/bin/activate_this.py')
with open(activate_this) as f:
    exec(f.read(), {'__file__': activate_this})

import examples.voice.assistant_library_with_local_commands_demo as assistant
assistant.main()
"

SERVICE="[Unit]
Description=Google Assistant for Raspberry Pi
After=network.target

[Service]
ExecStart=/usr/bin/python3 -u src/AssistantPi.py
WorkingDirectory=$HOME/AIY-projects-python
StandardOutput=inherit
StandardError=inherit
Restart=always
User=$USER

[Install]
WantedBy=multi-user.target
"

if [ "$(uname -m)" = "armv6" ]; then
  echo -e "\e[1;31mError: AssistantPi does not work on the Pi Zero and Pi 1.\e[0m
If you are using a device with an ARMv6 CPU, try this project instead:
    https://github.com/warchildmd/google-assistant-hotword-raspi"
  exec $SHELL
fi

if [ -f $HOME/AIY-projects-python/src/AssistantPi.py ]; then
  echo -e "\e[1;31mError: AssistantPi is already installed.\e[0m
Try running upgrade.sh or uninstall.sh instead."
  exec $SHELL
fi

if [ ! -f $HOME/assistant.json ]; then
  echo -e "\e[1;31mError: You need client secrets to use the Assistant API.\e[0m
Follow these instructions:
    https://developers.google.com/api-client-library/python/auth/installed-app#creatingcred
and put the file at $HOME/assistant.json"
  exec $SHELL
fi

sudo apt-get install git libttspico-utils python3-dev python3-numpy virtualenv

git clone https://github.com/google/aiyprojects-raspbian.git $HOME/AIY-projects-python
cd $HOME/AIY-projects-python

virtualenv --system-site-packages -p python3 env
env/bin/pip install -e src
env/bin/pip install google-auth-oauthlib  # HACK Temporary fix for missing dependency

echo "$MAIN_PY" > src/AssistantPi.py
echo "$SERVICE" | sudo tee /lib/systemd/system/AssistantPi.service > /dev/null

sudo systemctl daemon-reload
sudo systemctl enable AssistantPi.service

python3 src/AssistantPi.py

echo
sudo systemctl start AssistantPi.service
