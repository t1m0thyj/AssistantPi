# AssistantPi

Scripts to automate installing, upgrading, and uninstalling Google Assistant service on Raspbian

## Installation

### Get Google Cloud credentials

First make sure you are logged into Google in the web browser you are using. You can register the project on any device, but doing it on your Pi is recommended because it is most convenient.

Go the [Google Cloud Console](https://console.cloud.google.com/) and follow the steps to get credentials in [Google's documentation](https://aiyprojects.withgoogle.com/voice#google-assistant--get-credentials). After completing Step 81 (Download the credentials) you can continue with the next step below.

Rename the file that you downloaded to "assistant.json" and place it in the home directory of your Pi (usually `/home/pi`). If you downloaded it on a device other than your Pi, you can transfer it using a USB flash drive, or [FTP](https://www.raspberrypi.org/documentation/remote-access/ssh/sftp.md) if the device is on the same network.

### Configure USB microphone

If you are using a USB microphone, you will need to configure some audio settings on your Pi to make it work with Assistant. Follow the steps in [Google's documentation](https://developers.google.com/assistant/sdk/guides/library/python/embed/audio) to configure and test the audio. The `(card number, device number)` pairs that you find in step 1 will likely be `1,0` for the mic and `0,0` for the speaker.

### Run install script

There are two options for downloading and running the install script:

1. Clone this Git repo with the command `git clone https://github.com/t1m0thyj/AssistantPi.git`, then open a terminal in the "AssistantPi" directory (`cd AssistantPi`) and run `bash install.sh`. This is the recommended option because it will also download the scripts "upgrade.sh" and "uninstall.sh" which you can use later, but is not as easy as the second option.
2. Open a terminal window and run the command `curl -ssl https://raw.githubusercontent.com/t1m0thyj/AssistantPi/master/install.sh | bash`. This is easier than the first option but does not download the additional scripts. (Also this command executes a remote script, which is safe if the source is trusted but still potentially dangerous.)

After the installation process finishes, a link should open automatically in Chromium (or whatever your Pi's default web browser is) asking you to sign in with your Google account. If the link doesn't automatically open, there should be a message in the terminal saying "Please visit this URL to authorize this application" with a link that you can click on.

After logging in to your account, click "Allow" to grant permissions to Google Assistant. If the authorization succeeded, you should see this message:
> The authentication flow has completed, you may close this window.

A demo of Google Assistant should now be running in the terminal. Try talking to Assistant using the trigger phrase "OK Google" or "Hey Google", and whatever you say should show up in the terminal. After you are done with the demo, press `Ctrl+C` to quit it and the AssistantPi service should now start up in the background.

Now if you reboot your Pi (you can use the voice command "OK Google reboot"), AssistantPi should start automatically after the Pi boots up again.

## FAQ

### Why not flash Google's AIY image on my Pi?

Because you might not want to flash a custom image on your SD card just to use Google Assistant. With AssistantPi you can get it working in your existing Raspbian install.

### Can I add a status indicator LED?

Yes, simply connect an LED between GPIO pin 25 and GND on your Pi. When Google Assistant is running, it will flash the LED every few seconds to let you know it is listening, and the light will turn solid when you start talking to it.

### Can I play podcasts and music on my Pi?

No, unfortunately Google has limited the capabilities of the Assistant API on the Pi, but this may be possible in the future.

### Can I change the language used by Google Assistant?

Yes, if you have the Google Assistant app on your phone, open Settings in the app and scroll down to "Devices". "Voice Kit" should be one of the devices listed, which is what AssistantPi registers itself as. From here you can change the language used by Assistant as well as some other settings.

### Can I code custom actions for Google Assistant?

Yes, custom actions can easily be added by editing the Python script `~/AIY-projects-python/src/AssistantPi.py`. Details about how to do this can be found in [Google's Maker's Guide](https://aiyprojects.withgoogle.com/voice#makers-guide) for this project.
