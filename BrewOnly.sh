#!/bin/sh
# BashBuild (Mavericks/Yosemite/Sierra)
#
# Andrew Castro
# This should be run after installing a new OSX && after xcode and command line tools has been installed
#
#  Warning!!!  You should read this script before using it!!!

# Some things taken from here
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# More on Homebrew Cask here
# http://caskroom.io

# Install command line tools for Xcode
xcode-select --install

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

chflags nohidden ~/Library/

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

# Allow apps from any source, Mac OS Sierra
sudo spctl --master-disable


# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
echo "Installing homebrew..."
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install -vd coreutils gsl cmake cgal lzlib swig boost libxml2 modules texinfo texmath xrootd

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install -vd findutils tig

# Install Bash 4
brew install -vd bash
brew install -vd bash-completion ssh-copy-id autoconf automake

# Install more recent versions of some OS X tools
brew tap homebrew/dupes
brew install homebrew/dupes
brew install caskroom/cask/brew-cask
brew tap phinze/homebrew-cask
brew install brew-cask
brew cask install xquartz

brew install automake@1.12 autossh autojump autoenv  autoconf@2.64 autoconf@2.13  autogen
brew install -vd cgal tcl-tk berkeley-db@4  libtool autoconf automake cmake open-mpi archey python libxml2 bzip2 wget macvim hub nano plplot
brew install -vd yaml-cpp protobuf nanomsg gsl clhep gpg pkg-config sphinx-doc berkeley-db@4
brew install -vd gsoap libuvc daemontools m4 tmux tree git-flow calc ansiweather dark-mode cowsay ruby-build ack findutils moreutils qt rsync ponysay cfitsio yarn
 

echo "Prepping globus...................."

mkdir -p $HOME/alicesw
cd $HOME/alicesw
curl -L https://raw.github.com/dberzano/cern-alice-setup/master/alice-env.sh -o alice-env.sh
mkdir -p ~/.globus
#mkdir -p ~/alicesw/RooUnfold
#git clone https://github.com/skluth/RooUnfold ~/alicesw/RooUnfold
cd $HOME

# Only on Andy's computer
echo "Downloading Aliroot Enviroment Script, Moving certificate into globus, setting up bashrc, and building alien..."
cp ~/Dropbox/bash_profileAliBuild.txt ~/.bash_profile
source ~/.bash_profile
cp -r ~/Dropbox/gridcertificate/* ~/.globus/
chmod 600 $HOME/.globus/userkey.pem
#sudo curl -L https://raw.github.com/gerrywastaken/git-new-workdir/master/git-new-workdir -o /usr/bin/git-new-workdir
#sudo chmod +x /usr/bin/git-new-workdir
echo ""

sudo curl -L https://raw.github.com/gerrywastaken/git-new-workdir/master/git-new-workdir -o /usr/local/bin/git-new-workdir
sudo chmod 0777 /usr/local/bin/git-new-workdir
which git-new-workdir
cd $HOME

brew cask install java
brew install certbot itstool openssh itstool globus-toolkit
sudo /usr/sbin/DevToolsSecurity --enable

binaries=(
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
#thrift
fftw
fig
platypus
unison
ack
rancid
skinny
python3
#atari++
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
#cppcheck
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
#brew-cask
gd
libgcrypt
#osxfuse
wireshark
geoip
libgpg-error
pkg-config
x264
open-mpi
cloog
gettext
libmpc
#qt
xvid
libpng
glib
libssh
reaver
#zopfli
#cowpatty
gmp
libtasn1
#zsh-completions
scala
cowsay
gnuplot
libtiff
#scantailor
#ctorrent
gnutls
siege
emacs
hub
lua
perl
#wine
#sshfs
)

echo "installing binaries..."
brew install -vd ${binaries[@]}

brew cleanup

brew install homebank icoutils vnu dpkg thefuck mas

# can search a repo in cask via:
# brew cask search /google-chrome/
# or look at the repo: https://github.com/caskroom/homebrew-cask/tree/master/Casks

# Ask for the administrator password upfront

pip install alibuild pandas glances cheat howdoi metakernel matplotlib IPython SymPy nose Scapy NumPy SciPy pySerial pyUSB pyGoogle wxPython Pmw 
pip install ipywidgets ipykernel notebook metakernel

sudo -v
brew tap homebrew/science
brew tap davidchall/hep
#brew install whizard sherpa thepeg herwig++ jetvheto lhapdf fastnlo applgrid hepmc hoppet pythia8 qcdnum mcfm yoda rivet
sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"
# Brew Mac-Cli
brew install -vd no-more-secrets cfitsio
# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Apps
apps=(
alfred
hyper
monolingual
thunderbird
#dropbox
silverlight
#skype
#amazon-music
aquamacs
#adobe-reader
mame
#aquaterm
#filezilla
paraview
qlcolorcode
cdock
#kismac
#mac-linux-usb-loader
#simple-comic
#texmaker
#texshop
screenflick
slack
transmit
appcleaner
firefox
#google-chrome
hazel
ubersicht
qlmarkdown
#seil
#spotify
vagrant
#diskmaker-x
inkscape
arq
#geektool
retroarch
flash-player
iterm2
java
#geekbench
#github
#google-drive
jedit
#subversion
#python3
qlprettypatch
shiori
#sublime-text3
#virtualbox
atom
flux
#mailbox
#qlstephen
wireshark
#minecraft
snes9x
nestopia
sketch
tower
#istat-menus
vlc
cloudup
nvalt
the-cheat
deeper
#textwrangler
cuda-z
quicklook-json
visualjson
transmission
#bibdesk
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}

#only need if you are using beta casks
brew tap caskroom/versions

brew tap caskroom/fonts
brew cask install amazon-music amazon-workdocs amazon-workspaces amazon-drive
# fonts
fonts=(
font-m-plus
font-clear-sans
font-roboto
)

# install fonts
echo "installing fonts..."
brew cask install ${fonts[@]}

#find more fonts at:  https://github.com/caskroom/homebrew-fonts/tree/master/Casks

# Mackup is a community-driven tool for backing up and restoring system and application settings. You can find the
# list of applications it supports in the lra/mackup repo.
echo "installing mackup..."
pip install mackup
pip install pyvim scipy snappy wxpython numpy jupyter dxpy
brew install pyvim scipy snappy wxpython pyqt pypy pyenv numpy jupyter dxpy

#brew update
#brew upgrade
#brew cleanup
#brew doctor

brew install lemon salmon mongoose diamond smartmontools

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

gem install tmuxinator
gem install shenzhen
#curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh



###############################################################################
# Kill affected applications
###############################################################################

cecho "###############################################################################" $white
echo ""
echo ""
cecho "Note that some of these changes require a logout/restart to take effect." $white
cecho "Killing some open applications in order to take effect." $white
echo ""

echo "cloning oh-my-zsh..."
# curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

brew cask cleanup
brew cleanup

#find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
#for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
#"Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
#"Terminal" "Transmission"; do
#killall "${app}" > /dev/null 2>&1
#done

echo "gem: --no-document" >> ~/.gemrc
curl -L https://get.rvm.io | bash -s stable --auto-dotfiles --autolibs=enable --rails
cpan -i Bio::Perl
cpan -i XML::Simple


echo "############################################"
echo "#                 DONE!!                   #"
echo "############################################"
