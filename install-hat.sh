echo "deb https://dl.google.com/aiyprojects/deb stable main" | sudo tee -a /etc/apt/sources.list.d/aiyprojects.list > /dev/null
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-get update

sudo apt-get install pulseaudio
mkdir -p ~/.config/pulse/
echo "default-sample-rate = 48000" > ~/.config/pulse/daemon.conf

sudo apt-get install aiy-dkms aiy-voicebonnet-soundcard-dkms aiy-voicebonnet-routes

echo "dtoverlay=i2s-mmap
dtoverlay=googlevoicehat-soundcard" | sudo tee -a /boot/config.txt > /dev/null
echo "blacklist snd_bcm2835" | sudo tee -a /etc/modprobe.d/alsa-blacklist.conf > /dev/null

echo "Reboot your Pi to enable the AIY Voice HAT driver."
echo "If you want to test audio after rebooting, run the Python script $HOME/AIY-projects-python/src/checkpoints/check_audio.py"
