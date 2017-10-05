#!/bin/sh

###########################################################################
#
# Crouton Bootstrap
# https://github.com/dnschneid/crouton
#
# # Usage:
#
# 1. Click on Settings > Internet Connection > Wi-Fi Network
# 2. Select current Wi-Fi network from dropdown list
# 3. Select Network Tab > "Google name servers"
# 4. Open crosh terminal `Ctrl+Alt+T`
# 5. Enter shell `shell`
# 6. Run bootstrap script: wget -q -O - https://raw.github.com/michaelcapx/salad/master/bin/crouton.sh | sh
#
# Command:
# sudo sh ~/Downloads/crouton -t audio,chromium,cli-extra,core,extension,xiwi,xfce -n machina -r xenial
#
###########################################################################

###########################################################################
# Constants and Global Variables
###########################################################################

readonly CROUTON_URL="https://github.com/dnschneid/crouton/raw/master/installer/crouton"
readonly CROUTON_FILENAME="crouton"

readonly CROUTON_RELEASE="xenial"
readonly CROUTON_TARGET="audio,chromium,cli-extra,core,extension,xiwi,xfce"
readonly CROUTON_NAME="machina"

###########################################################################
# Crouton Setup
###########################################################################

wget $CROUTON_URL -O $HOME/Downloads/$CROUTON_FILENAME -w 10
sudo sh -e $HOME/Downloads/$CROUTON_FILENAME -r $CROUTON_RELEASE -t $CROUTON_TARGET -n $CROUTON_NAME
