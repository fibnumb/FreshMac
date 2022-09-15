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
adwaita-icon-theme
alibuild
ansiweather
aom
atk
autoconf
autoenv
autogen
autojump
automake
autossh
bash
bash-completion
bdw-gc
berkeley-db
berkeley-db@4
boost
broot
brotli
btop
bzip2
c-ares
ca-certificates
cairo
calc
cfitsio
cgal
cjson
clang-format
clhep
cling
cmake
cmake-docs
cmocka
coreutils
cowsay
ctop
curl
daemontools
dark-mode
dav1d
davix
diamond
docbook
docbook-xsl
dpkg
eigen
emacs
ettercap
exa
fd
ffmpeg
fftw
findutils
fish
flac
fontconfig
fortune
fping
freetype
frei0r
fribidi
gcc
gcc@6
gd
gdbm
gdk-pixbuf
geoip
gettext
gh
giflib
git
git-flow
gl2ps
glew
glfw
glib
glib-networking
gmp
gnu-sed
gnu-tar
gnupg
gnuplot
gnutls
gotop
gpatch
graphite2
graphviz
gsettings-desktop-schemas
gsl
gsoap
gtk+3
gtk-doc
gts
guile
harfbuzz
hicolor-icon-theme
homebank
htop
hub
hwloc
icu4c
imath
imlib2
isl
jansson
jasper
john
jpeg
jpeg-turbo
jpeg-xl
jq
killswitch
lame
lemon
leptonica
libarchive
libass
libassuan
libavif
libb2
libbluray
libcaca
libcbor
libcerf
libepoxy
libev
libevent
libffi
libfido2
libgcrypt
libgpg-error
libidn2
libksba
liblinear
libmicrohttpd
libmpc
libnet
libnghttp2
libofx
libogg
libomp
libpng
libpsl
libpthread-stubs
librist
librsvg
libsamplerate
libsndfile
libsodium
libsoup@2
libsoxr
libssh2
libtasn1
libtiff
libtool
libunistring
libusb
libuv
libuvc
libvidstab
libvmaf
libvorbis
libvpx
libx11
libxau
libxcb
libxdmcp
libxext
libxml2
libxrender
libyaml
little-cms2
llvm@13
lsd
lua
lua@5.3
lz4
lzlib
lzo
m4
make
mbedtls
modules
mongoose
moreutils
mpdecimal
mpfr
msgpack
mysql-client
mytop
nano
nanomsg
ncurses
neofetch
netpbm
nettle
ninja
nmap
node
npth
numpy
o2-full-deps
oniguruma
open-mpi
open-sp
openblas
opencore-amr
openexr
openjpeg
openldap
openssl@1.1
openssl@3
opus
p11-kit
pango
pcre
pcre2
perl
pigz
pinentry
pixiewps
pixman
pkg-config
ponysay
popt
powerline-go
proctools
protobuf
pv
pyenv
python@3.10
python@3.8
python@3.9
qt@5
rav1e
readline
reaver
root
rsync
rtmpdump
rubberband
ruby-build
s3cmd
screenresolution
sdl2
six
smartmontools
snappy
sntop
speex
sphinx-doc
sqlite
srt
ssh-copy-id
starship
swig
svn
taglib
tbb
tcl-tk
tesseract
texinfo
texmath
thefuck
theora
tig
tmux
toilet
trash
tree
unbound
utf8proc
webp
wget
when
x264
x265
xorgproto
xrootd
xvid
xxhash
xz
yaml-cpp
yarn
youtube-dl
zeromq
zimg
zlib
zopfli
zsh
zsh-syntax-highlighting
zstd
)

echo "installing binaries..."
brew install -vd ${binaries[@]}

brew cleanup

# can search a repo in cask via:
# brew cask search /google-chrome/
# or look at the repo: https://github.com/caskroom/homebrew-cask/tree/master/Cask

# Apps
apps=(
alacritty
atom
bibdesk
docker
fig
font-clear-sans
font-mplus
font-noto-nerd-font
font-ubuntu-nerd-font
hyper
iterm2
latexit
monolingual
mysql-connector-python
simple-comic
sublime-text
texmaker
texpad
texshop
texstudio
visual-studio-code
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
anyio               
appnope             
argon2-cffi         
argon2-cffi-bindings
asttokens           
async-generator     
atlasplots          
attrs               
awkward             
awkward0            
Babel               
backcall            
backoff             
beautifulsoup4      
black               
bleach              
cachetools          
certifi             
cffi                
chardet             
charset-normalizer  
click               
colorama            
cycler              
Cython              
debugpy             
decorator           
defusedxml          
dryable             
entrypoints         
executing           
fastjsonschema      
fonttools           
h5py                
idna                
ipykernel           
ipython             
ipython-genutils    
ipywidgets          
jedi                
Jinja2              
joblib              
json5               
jsonschema          
jupyter_client      
jupyter-core        
jupyter-server      
jupyterlab          
jupyterlab-pygments 
jupyterlab_server   
jupyterlab-widgets  
keras               
kiwisolver          
lhcbstyle           
lxml                
MarkupSafe          
matplotlib          
matplotlib-inline   
metakernel          
mistune             
mock                
monotonic           
mypy-extensions     
nbclassic           
nbclient            
nbconvert           
nbformat            
nest-asyncio        
notebook            
notebook-shim       
numpy               
packaging           
pandas              
pandocfilters       
parso               
pathspec            
pbr                 
pexpect             
pickleshare         
Pillow              
pip                 
pip-upgrade-outdated
platformdirs        
ploomber-core       
posthog             
powerline-shell     
powerline-status    
prometheus-client   
prompt-toolkit      
psutil              
ptyprocess          
pure-eval           
pycparser           
Pygments            
pyjet               
pyparsing           
pyrsistent          
PySide2             
Pysun               
python-dateutil     
pytz                
PyUnfold            
PyYAML              
pyzmq               
requests            
responses           
scikit-learn        
scipy               
seaborn             
Send2Trash          
setuptools          
shiboken2           
six                 
sklearn-evaluation  
sniffio             
soupsieve           
stack-data          
starlette           
starship            
tabulate            
terminado           
testpath            
threadpoolctl       
tinycss2            
tomli               
tornado             
tqdm                
traitlets           
uproot              
uproot-methods      
uproot3             
uproot3-methods     
urllib3             
wcwidth             
webencodings        
websocket-client    
wheel               
widgetsnbextension  
xgboost             
XlsxWriter          
)

sudo pip3 install ${PYTHON_PACKAGES[]}

hyper install hyper-opacity hyperborder hyperterm-hipster

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
#bash <(curl -fsSL https://raw.githubusercontent.com/alidock/alidock/master/alidock-installer.sh)
wget -O ~/.bash_profile  https://raw.githubusercontent.com/fibnumb/FreshMac/master/bash_profile.mine


echo ""
echo "Add the following to your bashrc or bash_profile: "
echo "export ALIBUILD_WORK_DIR=\"$HOME/alice/sw\" "
echo "eval \"\`alienv shell-helper\`\""
echo "more info here: https://alice-doc.github.io/alice-analysis-tutorial/building/custom.html"



echo "############################################"
echo "#                 DONE!!                   #"
echo "############################################"
