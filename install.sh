#!/usr/bin/env bash

SERVICE="[Unit]
Description=Google Assistant for Raspberry Pi
After=network.target

[Service]
ExecStart=/bin/bash -c 'source env/bin/activate && env/bin/python3 -u src/AssistantPi.py'
WorkingDirectory=$HOME/AIY-projects-python
StandardOutput=inherit
StandardError=inherit
Restart=always
User=$USER

[Install]
WantedBy=multi-user.target
"

if [ -f $HOME/AIY-projects-python/src/AssistantPi.py ]; then
  echo -e "\e[1;31mError: AssistantPi is already installed.\e[0m
Try running upgrade.sh or uninstall.sh instead."
  exec $SHELL
fi

if [ ! -f $HOME/assistant.json ]; then
  echo -e "\e[1;31mError: You need client secrets to use the Assistant API.\e[0m
Follow these instructions:
    https://developers.google.com/api-client-library/python/auth/installed-app#creatingcred
and put the file at /home/pi/assistant.json"
  exec $SHELL
fi

sudo apt-get install git virtualenv

git clone https://github.com/google/aiyprojects-raspbian.git $HOME/AIY-projects-python
cd $HOME/AIY-projects-python

virtualenv --system-site-packages -p python3 env
env/bin/pip install -e src

ln -s examples/voice/assistant_library_with_local_commands_demo.py src/AssistantPi.py
echo "$SERVICE" | sudo tee /lib/systemd/system/AssistantPi.service > /dev/null

sudo systemctl daemon-reload
sudo systemctl enable AssistantPi.service

source env/bin/activate
env/bin/python3 src/AssistantPi.py

echo
sudo systemctl start AssistantPi.service
