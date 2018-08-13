#!/usr/bin/env bash

read -p "Are you sure you want to uninstall the AssistantPi service? (y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  exec $SHELL
fi
echo

sudo systemctl stop AssistantPi.service
sudo systemctl disable AssistantPi.service

sudo rm /lib/systemd/system/AssistantPi.service
rm -rf $HOME/AIY-projects-python
rm -rf $HOME/.cache/voice-recognizer
