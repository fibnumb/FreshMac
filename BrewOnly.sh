#!/bin/sh
# BashBuild (Mavericks/Yosemite/Sierra/High Sierra/Mojave/Catalina)
#
# Andrew Castro
# This should be run after installing a new OSX && after xcode and command line tools has been installed
#
#  Warning!!!  You should read this script before using it!!!

# Some things taken from here
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# More on Homebrew Cask here
# http://caskroom.io

echo "Ask for the administrator password upfront"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install command line tools for Xcode
xcode-select --install
#sudo xcodebuild -license

# Alias to build on multicore CPU's
alias make='make -j$MJ'

# Set the colours you can use
black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'

echo "This script will make your Mac awesome"

###############################################################################
#  Hombrew and basic app installation(Cask)
###############################################################################

echo ""
echo "Disabling OS X Gate Keeper"
echo "(You'll be able to install any app you want from here on, not just Mac App Store apps)"
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo ""
echo "Make Library unhidden in Finder"
chflags nohidden ~/Library/

echo ""
echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo ""
echo "Disable smart quotes and smart dashes as they are annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo ""
echo "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true


echo ""
echo "Shpw full path in finder title"
sudo defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES; killall Finder

echo ""
echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo ""
echo "Never go into computer sleep mode"
systemsetup -setcomputersleep Off > /dev/null

echo ""
echo "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

echo ""
echo "Turn off keyboard illumination when computer is not used for 5 minutes"
defaults write com.apple.BezelServices kDimTime -int 300


echo ""
echo "Enabling subpixel font rendering on non-Apple LCDs"
defaults write NSGlobalDomain AppleFontSmoothing -int 2

echo ""
echo "Disable hibernation (speeds up entering sleep mode)"
sudo pmset -a hibernatemode 0

echo ""
echo "Enable HiDPI display modes (requires restart)"
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

echo ""
echo "Disabling the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo ""
echo "Avoiding the creation of .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo ""
echo "Enabling the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo ""
echo "Restart automatically on power loss"
sudo pmset -a autorestart 1

echo ""
echo "Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on

echo ""
echo "Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true

echo ""
echo "Hide icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

echo ""
echo "Avoid creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

echo ""
echo "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo ""
echo "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4

echo ""
echo "Restarting Finder"
killall Finder

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
echo "Installing homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install -vd coreutils lzlib swig libxml2 modules texinfo texmath xrootd

# Install Bash 4
brew install -vd bash bash-completion ssh-copy-id findutils

# Install more recent versions of some OS X tools
brew tap homebrew/cask
brew tap davidchall/hep
brew install --cask starship xquartz hyper kitty

#alibuild brews
brew install alisw/system-deps/o2-full-deps

brew install -vd gh automake autossh autojump autoenv  autoconf autogen cgal tcl-tk berkeley-db@4  libtool cmake open-mpi archey python libxml2 bzip2 wget hub nano yaml-cpp protobuf nanomsg gsl clhep gpg pkg-config sphinx-doc gsoap libuvc daemontools m4 tmux tree git-flow calc ansiweather dark-mode cowsay ruby-build ack findutils moreutils qt rsync ponysay cfitsio yarn neofetch fish htop broot trash lemon mongoose diamond smartmontools youtube-dl pyenv
 
# for KBB's SD_TOOLS
brew install gcc@6
#echo "Prepping globus...................."
#mkdir -p $HOME/alicesw
#cd $HOME/alicesw
#curl -L https://raw.github.com/dberzano/cern-alice-setup/master/alice-env.sh -o alice-env.sh
#mkdir -p ~/.globus
#mkdir -p ~/alicesw/RooUnfold
#git clone https://github.com/skluth/RooUnfold ~/alicesw/RooUnfold
cd $HOME

sudo /usr/sbin/DevToolsSecurity --enable

binaries=(
gnuplot
root
homebank
icoutils
vnu
dpkg
thefuck
mas
certbot
openssh
itstool
graphicsmagick
aircrack-ng
webkit2png
bmake
rename
curl
zopfli
paket
ffmpeg
python
vim
trash
zsh
tree
npm
when
alpine
fortune
fftw
fig
platypus
unison
ack
rancid
skinny
python3
svn
hub
tmux
git
archey
imagemagick
ack
gdb
faac
hydra
mpfr
tig
ffmpeg
isl
mtr
john
nettle
tree
fontconfig
jpeg
tor
nmap
unrar
freetype
lame
node
watch
boost
gcc
libffi
ettercap
openssl
gd
libgcrypt
wireshark
geoip
libgpg-error
pkg-config
x264
open-mpi
cloog
gettext
libmpc
xvid
libpng
glib
libssh
reaver
gmp
libtasn1
scala
cowsay
gnuplot
libtiff
gnutls
siege
emacs
hub
lua
perl
)

echo "installing binaries..."
brew install -vd ${binaries[@]}

brew cleanup


# can search a repo in cask via:
# brew cask search /google-chrome/
# or look at the repo: https://github.com/caskroom/homebrew-cask/tree/master/Casks


sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"
# Brew Mac-Cli
# Keep-alive: update existing `sudo` time stamp until script has finished


# Apps
apps=(
alfred
hyper
docker
monolingual
thunderbird
silverlight
aquamacs
mame
paraview
qlcolorcode
simple-comic
screenflick
firefox
hazel
ubersicht
qlmarkdown
spotify
vagrant
inkscape
arq
retroarch
flash-player
iterm2
jedit
qlprettypatch
shiori
atom
flux
snes9x
nestopia
sketch
tower
vlc
cloudup
nvalt
the-cheat
deeper
cuda-z
quicklook-json
transmission
bibdesk
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

#only need if you are using beta casks
brew tap homebrew/cask-fonts
# fonts
fonts=(
font-mplus
font-clear-sans
font-roboto
font-consolas-for-powerline
)

# install fonts
echo "installing fonts..."
brew install --cask ${fonts[@]}

#find more fonts at:  https://github.com/caskroom/homebrew-fonts/tree/master/Casks

# Mackup is a community-driven tool for backing up and restoring system and application settings. You can find the
# list of applications it supports in the lra/mackup repo.
echo "Installing Python3 packages..."
PYTHON_PACKAGES=(
alibuild
pandas
glances
cheat
howdoi
metakernel
matplotlib
SymPy
nose
Scapy
pySerial
pyUSB
wxPython
Pmw
virtualenv
virtualenvwrapper
pyvim
scipy
snappy
numpy
jupyter
matplotlib
seaborn
keras
tensorflow
scikit-learn
aliBuild
jupyterlab
mackup
certifi
ipython
ipywidgets
ipykernel
notebook
metakernel
pyyaml
pip-upgrade-outdated
pandas
requests
uproot
pyunfold
pyjet
plotly
sunpy
)
sudo pip3 install --progress-bar pretty ${PYTHON_PACKAGES[@]}


echo ""
echo "Disable annoying backswipe in Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false

###############################################################################
# iTerm2.app                                                            #
###############################################################################

# Install the Solarized Dark theme for iTerm
open "${HOME}/init/Solarized Dark.itermcolors"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

###############################################################################
# Transmission.app                                                            #
###############################################################################

echo ""
echo "Trash original torrent files"
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

echo ""
echo "Hide the donate message"
defaults write org.m0k.transmission WarningDonate -bool false

echo ""
echo "Hide the legal disclaimer"
defaults write org.m0k.transmission WarningLegal -bool false

###############################################################################
# Kill affected applications
###############################################################################

echo "###############################################################################"
echo ""
echo ""
echo "Note that some of these changes require a logout/restart to take effect."
echo "Killing some open applications in order to take effect."
echo ""

echo "cloning oh-my-zsh..."
# curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

echo ""
echo "Installing Hyper packages"

hyper install hyperline
hyper install hypercwd
hyper install hyper-sync-settings
hyper install hyperterm-paste
hyper install hyperterm-tabs
hyper install hyper-tabs-enhanced
hyper install hyper-savetext
hyper install hyperborder
hyper install hyper-blink
hyper install hyper-snazzy



#find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
#for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
#"Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
#"Terminal" "Transmission"; do
#killall "${app}" > /dev/null 2>&1
#done

echo "gem: --no-document" >> ~/.gemrc
gem install tmuxinator
gem install shenzhen
curl -L https://get.rvm.io | bash -s stable --auto-dotfiles --autolibs=enable --rails
cpan -i Bio::Perl
cpan -i XML::Simple
npm install -g vtop
npm install -g grunt-cli
brew cleanup
brew doctor
csrutil status
echo""
echo"Copying bash_profile to local area"
bash <(curl -fsSL https://raw.githubusercontent.com/alidock/alidock/master/alidock-installer.sh)
wget -O ~/.bash_profile  https://raw.githubusercontent.com/fibnumb/FreshMac/master/bash_profile.mine
wget -O ~/.bash-powerline.sh  https://raw.githubusercontent.com/fibnumb/FreshMac/master/bash-powerline.sh
source ~/.bash_profile
echo ""
echo "Building CERN ROOT using modules (This may take awhile)"
mkdir -p ~/alice
cd ~/alice
aliBuild init AliRoot@master,AliPhysics@master -z ali-main-root6
cd ali-main-root6
aliBuild --defaults next-root6 -z -d -w ../sw build GEANT4_VMC && aliBuild --defaults next-root6 -z -d -w ../sw build RooUnfold

echo ""
echo "Add the following to your bashrc or bash_profile: "
echo "export ALIBUILD_WORK_DIR=\"$HOME/alice/sw\" "
echo "eval \"\`alienv shell-helper\`\""
echo "more info here: https://alice-doc.github.io/alice-analysis-tutorial/building/custom.html"



echo "############################################"
echo "#                 DONE!!                   #"
echo "############################################"
