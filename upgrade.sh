#!/usr/bin/env bash

cd $HOME/AIY-projects-python

git pull
env/bin/pip install -U -e src

sudo systemctl restart AssistantPi.service
