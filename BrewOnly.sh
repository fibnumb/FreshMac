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
sudo xcode-select --install
sudo xcodebuild -license

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

# Install more recent versions of some OS X tools
brew tap homebrew/cask
brew tap davidchall/hep

#alibuild brews
brew install alisw/system-deps/o2-full-deps alisw/system-deps/alibuild

cd $HOME

sudo /usr/sbin/DevToolsSecurity --enable

binaries=(
ack 
aircrack-ng
alpine
ansiweather 
archey
autoconf 
autoenv  
autogen 
autojump 
automake 
autossh 
bash 
bash-completion 
berkeley-db@4  
bmake
boost
broot 
bzip2 
calc 
certbot
cfitsio 
cgal 
clhep 
cloog
cmake 
coreutils 
cowsay
curl
daemontools 
dark-mode 
diamond 
dpkg
emacs
ettercap
faac
ffmpeg
fftw
fig
findutils
fish
fontconfig
fortune
freetype
gcc
gcc@6
gd
gdb
geoip
gettext
gh 
git
git-flow 
glib
gmp
gnuplot
gnutls
gpg 
graphicsmagick
gsl 
gsoap 
homebank
htop 
hub
hydra
icoutils
imagemagick
isl
itstool
john
jpeg
lame
lemon 
libffi
libgcrypt
libgpg-error
libmpc
libpng
libssh
libtasn1
libtiff
libtool 
libuvc 
libxml2 
lua
lzlib 
m4 
mas
modules 
mongoose 
moreutils 
mpfr
mtr
nano 
nanomsg 
neofetch 
nettle
nmap
node
npm
open-mpi
openssh
openssl
paket
perl
pkg-config
platypus
ponysay 
protobuf 
pyenv
python
qt 
rancid
reaver
rename
root
rsync 
ruby-build 
scala
siege
skinny
smartmontools 
sphinx-doc 
ssh-copy-id 
svn
swig 
tcl-tk 
texinfo 
texmath 
thefuck
tig
tmux
tor
trash
tree
unison
unrar
vim
vnu
watch
webkit2png
wget 
when
wireshark
x264
xrootd
xterm
xvid
yaml-cpp 
yarn 
youtube-dl 
zopfli
zsh
)

echo "installing binaries..."
brew install -vd ${binaries[@]}

brew cleanup

# can search a repo in cask via:
# brew cask search /google-chrome/
# or look at the repo: https://github.com/caskroom/homebrew-cask/tree/master/Cask

# Apps
apps=(
aquamacs
atom
bibdesk
cloudup
deeper
docker
firefox
flux
hazel
hyper
inkscape
iterm2
jedit
mame
monolingual
nestopia
paraview
quicklook-json
retroarch
simple-comic
sketch
snes9x
spotify
texmaker
the-cheat
transmission
ubersicht
vagrant
vlc
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew install --cask --appdir="/Applications" ${apps[@]}

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
aliBuild
atlasplots
certifi
cheat
colorama
glances
howdoi
ipykernel
ipython
ipywidgets
jupyter
jupyterlab
keras
lhcbstyle
mackup
matplotlib
metakernel
nose
notebook
numpy
pandas
pip-upgrade-outdated
plotly
Pmw
pyjet
pySerial
pyunfold
pyUSB
pyvim
pyyaml
requests
Scapy
scikit-learn
scipy
seaborn
snappy
sunpy
SymPy
tensorflow
tqdm
uproot
virtualenv
virtualenvwrapper
wxPython
xlsxwriter
)

sudo pip3 install ${PYTHON_PACKAGES[]}

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


echo ""
echo "Add the following to your bashrc or bash_profile: "
echo "export ALIBUILD_WORK_DIR=\"$HOME/alice/sw\" "
echo "eval \"\`alienv shell-helper\`\""
echo "more info here: https://alice-doc.github.io/alice-analysis-tutorial/building/custom.html"



echo "############################################"
echo "#                 DONE!!                   #"
echo "############################################"
