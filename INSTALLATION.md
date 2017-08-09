# Installing GalliumOS on Edgar

This documents outlines how to install [GalliumOS 2.1](https://galliumos.org/) on a new Acer Chromebook 14" (CB3-431) 'Edgar'. This installation guide covers installing GalliumOS on the internal eMMC storage, but allows Chrome OS in place (allowing dual-booting).

This is meant to be an easy-to-follow and particularly thorough (if repetitive) guide, but there is no warranty that it will work correctly for you. It *will* wipe all data on your Edgar.

References are provided for each section; see the [GalliumOS wiki guide to *chrx* installation](https://wiki.galliumos.org/Installing#chrx_Installation) for an overview of the general process.

**⚠ Caution:** There have been reports of Edgars' speakers overheating, due to a malfunction of the audio hardware, when  booted into anything other than Chrome OS. It seems to be believed that this will not now occur under GalliumOS. More information can be found in the comments for the [GalliumOS *Braswell Platform Validation* issue](https://github.com/GalliumOS/galliumos-distro/issues/270).


## Contents
1. [First boot](#first-boot)
2. [Making a Recovery USB Stick](#making-a-recovery-usb-stick)
3. [Enable Developer mode](#enable-developer-mode)
4. [Update the firmware to enable Legacy Boot](#update-the-firmware-to-enable-legacy-boot)
5. [Reserve space on the eMMC](#reserve-space-on-the-emmc)
6. [Install GalliumOS](#install-galliumos)

- [*Important* - If Your Battery Ever Drains to 0%](#important---if-your-battery-ever-drains-to-0%)
- [*Extra* - Create a new user](#extra---create-a-new-user)
- [*Extra* - Encrypt your home folder](#extra---encrypt-your-home-folder)
- [*Extra* - Set the GBB flags](#extra---set-the-gbb-flags)
- [*Extra Extra* - Replace the boot screen image](#extra-extra---replace-the-boot-screen-image)

## First boot

* Connect the power
* Open the lid

You might want to at least proceed through wifi setup and check that the hardware is working correctly.

## Making a Recovery USB Stick
In this section you’ll want to transfer a bootable copy of ChromeOS over to a USB stick. This step allows you to reset your chromebook to factory settings if something ever goes wrong, or if you want to start over from scratch.

1. Grab a USB stick with 4GB+ of available storage and plug it into the chromebook after booting into ChromeOS

2. Download the [Chromebook Recovery Utility](https://chrome.google.com/webstore/detail/chromebook-recovery-utili/jndclpdbaamdhonoechobihbbiimdgai) Chrome extension to create a recovery USB stick

3. Follow the instructions and once the recovery USB stick is good to go, then eject the USB stick.

## Enable Developer mode
In this section you will put your Edgar into 'Developer Mode' which will 1) disable 'verified boot', allowing you to run operating systems that haven't been signed by Google, and 2) give you access to a root shell in Chrome OS.

This will wipe all your data on your Edgar.

See [the Chrome OS generic information for entering Developer mode](https://www.chromium.org/chromium-os/developer-information-for-chrome-os-devices/generic#TOC-Introduction1) or [How-To Geek's guide](https://www.howtogeek.com/210817/how-to-enable-developer-mode-on-your-chromebook/) for more information.

* Having shutdown your Edgar, hold down the **Esc** and **Refresh (↻)** keys and press the **Power** key.

* Your Edgar will then boot into Recovery Mode and appear to warn you that "Chrome OS is missing or damaged."

* Press **Ctrl-D**.

* The screen will change to one saying “To turn OS Verification OFF, press ENTER”.

* Press the **Enter** key and your Edgar will reboot.

* Your Edgar will boot to a screen that says “OS verification is OFF”. If you wait, your Edgar will eventually beep several times and then boot to Chrome OS; alternatively, you can press **Ctrl-D** at this point to immediately boot to Chrome OS.

* Your Edgar will show a warning about transitioning - wait.

* Your Edgar will show a screen saying that it is "Preparing your system for Developer Mode". This process will take some time. A progress bar is displayed at the top of the screen.

* Eventually your Edgar will reboot one more time.

* Your Edgar will boot to a screen that says “OS verification is OFF”. If you wait, your Edgar will eventually beep several times and then boot to Chrome OS; alternatively, you can press **Ctrl-D** at this point to immediately boot to Chrome OS.

At this point, Developer mode is enabled and OS verification has been disabled. It will continue to show the “OS verification is OFF” screen at startup.

## Update the firmware to enable Legacy Boot
The firmware that your Edgar comes with does not properly support booting operating systems other than Chrome OS. In this section you will update the *RW_LEGACY* section of your Edgar's firmware and configure it to allow 'Legacy Boot'.

This section relies on the work of *Mr Chromebox*. See [MrChromebox.tech](https://mrchromebox.tech/) for more information, in particular the [Firmware Utility Script section](https://mrchromebox.tech/#fwscript).

* Boot your Edgar to Chrome OS.

* Proceed to setup wifi.

* Press the 'Browse as Guest' button toward the bottom-left corner of the screen.

* Hold down the **Ctrl** and **Alt** keys, and press **T**, to get a *crosh* terminal.

* Type `shell` and press the **Enter** key to get a regular shell in that terminal.

* Type (or copy-and-paste) `cd; curl -LO https://mrchromebox.tech/firmware-util.sh && sudo bash firmware-util.sh` and press the **Enter** key to download and run the Mr Chromebox Firmware Utility Script.

* Type `1` and press the **Enter** key to choose "Install/Update RW_LEGACY Firmware".

* Press the **Enter** key again to confirm the default choice of booting from internal storage.

* Type `r` and press the **Enter** key to quit the Firmware Utility Script and reboot.

At this point, your Edgar has been configured to allow 'Legacy Boot' and the firmware has been updated to enable this to actually work.

**⚠ Caution:** If at this point, your chromebook freezes or becomes unresponsive, press the **Refresh (↻)** and **Power** buttons to force reboot. **⚠ Caution:**

## Reserve space on the eMMC
In this section you will alter the partition map on your Edgar's internal storage eMMC, so that some space is reserved for the installation of GalliumOS.

This will wipe all your data on your Edgar (again).

This and the following section rely on *chrx*. See [chrx.org](https://chrx.org/) for more information.

* Boot your Edgar to Chrome OS.

* Proceed to setup wifi.

* Press the 'Browse as Guest' button toward the bottom-left corner of the screen.

* Hold down the **Ctrl** and **Alt** keys, and press **T**, to get a *crosh* terminal.

* Type `shell` and press the **Enter** key to get a regular shell in that terminal.

* Type (or copy-and-paste) `cd ; curl -Os https://chrx.org/go && sh go` and press the **Enter** key to download and run *chrx*.

* Follow the instructions, including choosing the amount of disk space that you will give over to Gallium OS. I suggest leaving this at the default.

* Eventually *chrx* will prompt you to press **Enter** to reboot; do so.

* Your Edgar will boot to a screen that says “OS verification is OFF”. If you wait, your Edgar will eventually beep several times and then boot to Chrome OS; alternatively, you can press **Ctrl-D** at this point to immediately boot to Chrome OS.

* Your Edgar will enter Recovery Mode on this boot, as a result of *chrx* altering the partition table. Wait for the repairs to Chrome OS to complete, after which your Edgar will reboot again.

* Your Edgar will boot to a screen that says “OS verification is OFF”. If you wait, your Edgar will eventually beep several times and then boot to Chrome OS; alternatively, you can press **Ctrl-D** at this point to immediately boot to Chrome OS.

At this point, your Edgar will have space reserved on its internal storage for the installation of Gallium OS.

## Install GalliumOS
In this section you will install GalliumOS to the space that you previously reserved.

This and the previous section rely on *chrx*. See [chrx.org](https://chrx.org/) for more information.

Before you proceed, you may wish to investigate [*chrx*'s options](https://chrx.org/#options), in particular those relating to hostname, username, locale and timezone.

* Boot your Edgar to Chrome OS.

* Proceed to setup wifi.

* Press the 'Browse as Guest' button toward the bottom-left corner of the screen.

* Hold down the **Ctrl** and **Alt** keys, and press **T**, to get a *crosh* terminal.

* Type `shell` and press the **Enter** key to get a regular shell in that terminal.

* Type (or copy-and-paste) `cd ; curl -Os https://chrx.org/go && sh go` and press the **Enter** key to download and run *chrx*. (It is at this stage, that you would need to append any options.)

> The second time you run this command you may want to include a few flags to customize your username and/or hostname. You can do that by running:

    curl -Os https://chrx.org/go && sh go -U yourname -H foobarhost

> By default it will create a user `chrx` with a password of `chrx`. If you supply a custom username with -U yourname then your password will be yourname.
> For a full list of install options check out the [chrx option documentation](https://chrx.org/#options).

* Follow the instructions.

* Eventually *chrx* will prompt you to press **Enter** to reboot; do so.

* Your Edgar will boot to a screen that says “OS verification is OFF”. You must press **Ctrl-L** at this point. (If you do not, your Edgar will eventually beep several times and boot to Chrome OS.)

* Your Edgar will now boot to GalliumOS.

At this point your Edgar has GalliumOS installed. To boot to it in the future, press **Ctrl-L** at the “OS verification is OFF” screen. To boot to Chrome OS, you can either wait at that screen or press **Ctrl-D**.

## *Important* - If Your Battery Ever Drains to 0%

If your battery ever drains to 0% then a certain firmware setting will be forgotten and it will prevent your Chromebook from being able to boot into GalliumOS.

Fortunately it doesn’t take long and since you should rarely hit 0%, you won’t have to worry about it too often. To fix the issue:

1. Boot into ChromeOS (**CTRL+D** at the white screen)

2. Drop into a Virtual Terminal by pressing **CTRL+ALT+F2** (top right arrow)

3. Login as `chronos` with a blank password

4. Run `sudo crossystem dev_boot_legacy=1`

Reboot the system and now you’ll be able to boot into GalliumOS with **CTRL+L**

These steps could be bypassed if you removed the write protected screw when installing your new SSD, but it’s not really a big deal to do it this way.

## *Extra* - Create a new user

If you forgot to set your username during installation, don’t worry. You can always make a new user or change your hostname later just like you would in any Linux distro.

For example, after GalliumOS is fully installed you would open a terminal and run:

    sudo adduser yourname && \
      sudo usermod -a -G adm,sudo,cdrom,dip,plugdev,lpadmin yourname

That would ensure your new user belongs to the correct groups. In this case it would match the default `chrx` user’s groups. At this point you would log out and then log back in and you would be free to delete the `chrx` user.

## *Extra* - Encrypt your home folder

See [How-To Geek's *How to Encrypt Your Home Folder After Installing Ubuntu* guide](https://www.howtogeek.com/116032/how-to-encrypt-your-home-folder-after-installing-ubuntu/).

## *Extra* - Set the GBB flags

Setting the Google Binary Block (GBB) flags in your Edgar's firmware will allow it to boot quickly to GalliumOS without you having to intervene every time. (It will also protect against losing the ability to boot to GalliumOS at all in the event of a completely flat battery.)

This section relies on the work of *Mr Chromebox*. See [MrChromebox.tech](https://mrchromebox.tech/) for more information, in particular the [Firmware Utility Script section](https://mrchromebox.tech/#fwscript).

You will have to physically open up your Edgar in this section, see the [iFixit teardown of an Edgar](https://www.ifixit.com/Teardown/Acer+Chromebook+14+Teardown/76353) for more information and photos.

**N.B.** The iFixit source is actually wrong on one quite important point - only the [screw near the battery](https://i.imgur.com/eJHQpMy.jpg) *needs* to be removed. (I didn't suffer any ill-effects from removing, and replacing, both.)

### Remove the write-protect screws

* Shutdown your Edgar.

* Remove the 8 shorter and 2 longer screws from the underside of your Edgar.

* Remove the bottom panel of your Edgar.

* Locate the two write-protect screws and remove them. (See the [iFixit teardown](https://www.ifixit.com/Teardown/Acer+Chromebook+14+Teardown/76353#s153416).)

* Replace the bottom panel of your Edgar. (I suggest you can safely leave the screws out for now, if you're careful.)

### Set the GBB flags

* Type (or copy-and-paste) `cd; curl -LO https://mrchromebox.tech/firmware-util.sh && sudo bash firmware-util.sh` and press the **Enter** key to download and run the Mr Chromebox Firmware Utility Script.

* Type `4` and press the **Enter** key to choose "Set Boot Options (GBB Flags)".

* Type `1` and press the **Enter** key to choose a short boot-delay and booting to GalliumOS by default.

* Press the **Enter** key again to return to the main menu.

* Type `q` and press the **Enter** key to quit the Firmware Utility Script.

### Replace the write-protect screws

* Shutdown your Edgar.

* Remove the bottom panel of your Edgar.

* Replace the two write-protect screws. (See the [iFixit teardown](https://www.ifixit.com/Teardown/Acer+Chromebook+14+Teardown/76353#s153416).)

* Replace the bottom panel of your Edgar.

* Replace the 8 shorter and 2 longer screws.

## *Extra Extra* - Replace the boot screen image

**⚠ Caution:** This section is both largely pointless and risks bricking your Edgar if something doesn't work as expected.

It is possible to go beyond setting the GBB flags (to allow a quick boot to GalliumOS without intervention) to also changing the image briefly shown ("OS verification is OFF") when your Edgar is booted up.

**⚠ Caution:** Again, it's worth emphasising how silly this is and that you risk no longer being able to use your Edgar for anything by attempting it. Furthermore, the instructions are not as comprehensive or as straightforward in the section as they are in the rest of this document.

[Joshua Stein describes much the same process for a Chromebook Pixel](https://jcs.org/notaweblog/2016/08/26/openbsd_chromebook/#modifying-the-splash-screen), although some of the details do differ (i.e. the boot video mode). The [source code for Mr Chromebox's Firmware Utility Script](https://github.com/MattDevo/scripts/blob/8f7813a1e39a7711cd5e8cffc74c73c82325e3ae/firmware.sh#L666-L721) and [chromiumos bmpblk documentation](https://chromium.googlesource.com/chromiumos/platform/bmpblk/+/master/README) may also be useful references.

### Read the current GBB, export and unpack the current Bitmap FV

* `sudo aptitude install vboot-utils python-pil`
* `cd ~/Documents; mkdir bootimage; cd bootimage`
* Obtain *flashrom 0.9.4* . (As of writing, Mr Chromebox hosts a copy at `https://www.mrchromebox.tech/files/util/flashrom.tar.gz`.)
* `sudo ./flashrom -i GBB:gbb_old.rom --read`
* `gbb_utility --bmpfv=bmpfv_old gbb_old.rom`
* `bmpblk_utility -x -d bitmaps bmpfv_old`

### Create the new boot screen

* `cd bitmaps`

* Create your new boot screen and save it as *custom.png* . Be aware that whatever you create will end up being scaled (and squished) down to 1024x768 (as this is the resolution that your Edgar's firmware uses when it first starts the machine).

The final image has to be in a particular kind of bitmap format. The easiest way to ensure that your image is in this format is to to use Google's own script.

* Download [*convert_to_bmp3.py*](https://chromium.googlesource.com/chromiumos/platform/bmpblk/+/origin/factory-4455.B/images/convert_to_bmp3.py)

* Fix *convert_to_bmp3.py* to work with recent versions of PIL

```python
# Change this
import Image
# to this
from PIL import Image
```

* `./convert_to_bmp3.py --scale 1024x768! custom.png`

* Edit *config.yaml*

```yaml
bmpblock: 2.0
compression: 2
images:
  # ...
  custom: custom.bmp # Add an entry for your image
screens:
  scr_0_0: # Replace the scr_0_0 screen with one showing only your image
    - [0, 0, custom]
  scr_0_1:
    # ...
```

### Pack and set the new Bitmap FV, set the GBB flags

* `bmpblk_utility -z2 -c config.yaml ../bmpfv_new`
* `cd ..`
* `cp gbb_old.rom gbb_new.rom`
* `gbb_utility --set --bmpfv bmpfv_new gbb_new.rom`
* `gbb_utility --set --flags=0x4A9 gbb_new.rom`

These flags (`0x4A9`) specify a short boot-delay and booting to GalliumOS by default.

### Remove the write-protect screws

As above.

### Flash the new GBB

* `sudo ./flashrom -i GBB:gbb_new.rom --write`

### Replace the write-protect screws

As above.
