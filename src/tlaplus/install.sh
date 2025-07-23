#!/usr/bin/env bash

TOOLSPATH=${TOOLSPATH:-"tools"}
SETUP_SHORTHAND=${SETUPSHORTHAND:-true}
INSTALL_TLAPLUS=${INSTALLTLAPLUS:-true}
VERSION_FOR_TLAPLUS=${VERSIONFORTLAPLUS:-"latest"}
INSTALL_COMMUNITY_MODULES=${INSTALLCOMMUNITYMODULES:-true}
VERSION_FOR_COMMUNITY_MODULES=${VERSIONFORCOMMUNITYMODULES:-"latest"}
INSTALL_TLAPS=${INSTALLTLAPS:-true}
VERSION_FOR_TLAPS=${VERSIONFORTLAPS:-"1.4.5"}
INSTALL_APALACHE=${INSTALLAPALACHE:-true}
VERSION_FOR_APALACHE=${VERSIONFORAPALACHE:-"latest"}
INSTALL_TLAUC=${INSTALLTLAUC:-true}
VERSION_FOR_TLAUC=${VERSIONFORTLAUC:-"latest"}

set -e

if [ "$SETUP_SHORTHAND" = "true" ]; then
    ## Fix issues with gitpod's stock .bashrc
    cp /etc/skel/.bashrc "$HOME"

    ## Shorthands for git
    git config --global alias.slog 'log --pretty=oneline --abbrev-commit'
    git config --global alias.co checkout
    git config --global alias.lco '!f() { git checkout ":/$1:" ; }; f'

    ## Waste less screen estate on the prompt.
    echo 'export PS1="$ "' >> "$HOME/.bashrc"

    ## Make it easy to go back and forth in the (linear) git history.
    echo 'function sn() { git log --reverse --pretty=%H main | grep -A 1 "$(git rev-parse HEAD)" | tail -n1 | xargs git show --color; }' >> "$HOME/.bashrc"
    echo 'function n() { git log --reverse --pretty=%H main | grep -A 1 "$(git rev-parse HEAD)" | tail -n1 | xargs git checkout; }' >> "$HOME/.bashrc"
    echo 'function p() { git checkout HEAD^; }' >> "$HOME/.bashrc"
fi

if [ "$INSTALL_TLAPLUS" = "false" ] && \
    [ "$INSTALL_COMMUNITY_MODULES" = "false" ] && \
    [ "$INSTALL_TLAPS" = "false" ] && \
    [ "$INSTALL_APALACHE" = "false" ] && \
    [ "$INSTALL_TLAUC" = "false" ]; then
     echo "No TLA+ tools selected for installation. Exiting."
     exit 0
fi

## Place to install TLC, TLAPS, Apalache, ...
mkdir -p "$TOOLSPATH"


if [ "$INSTALL_TLAPLUS" = "true" ]; then
    ## Install TLA+ Tools (download from github instead of nightly.tlapl.us (inria) to only rely on github)
    wget -qN https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/tla2tools.jar -P "$TOOLSPATH"/
    echo "alias tlcrepl='java -cp \"$TOOLSPATH\"/tla2tools.jar tlc2.REPL'" >> "$HOME/.bashrc"
    echo "alias tlc='java -cp \"$TOOLSPATH\"/tla2tools.jar tlc2.TLC'" >> "$HOME/.bashrc"
fi

if [ "$INSTALL_COMMUNITY_MODULES" = "true" ]; then
    ## Install CommunityModules
    wget -qN https://github.com/tlaplus/CommunityModules/releases/latest/download/CommunityModules-deps.jar -P "$TOOLSPATH"/
fi

if [ "$INSTALL_TLAPS" = "true" ]; then
    ## Install TLAPS (proof system)
    wget -N https://github.com/tlaplus/tlapm/releases/download/v1.4.5/tlaps-1.4.5-x86_64-linux-gnu-inst.bin -P /tmp
    chmod +x /tmp/tlaps-1.4.5-x86_64-linux-gnu-inst.bin
    /tmp/tlaps-1.4.5-x86_64-linux-gnu-inst.bin -d "$TOOLSPATH"/tlaps
    echo "export PATH=\$PATH:\"$TOOLSPATH\"/tlaps/bin" >> "$HOME/.bashrc"
fi

if [ "$INSTALL_APALACHE" = "true" ]; then
    ## Install Apalache
    wget -qN https://github.com/informalsystems/apalache/releases/latest/download/apalache.tgz -P /tmp
    tar -zxvf /tmp/apalache.tgz --directory "$TOOLSPATH"/
    echo "export PATH=\$PATH:\"$TOOLSPATH\"/apalache/bin" >> "$HOME/.bashrc"
    "$TOOLSPATH"/apalache/bin/apalache-mc config --enable-stats=true
fi

if [ "$INSTALL_TLAUC" = "true" ]; then
    ## Install TLAUC
    wget -qN https://github.com/tlaplus-community/tlauc/releases/latest/download/tlauc-linux.tar.gz -P /tmp
    mkdir -p "$TOOLSPATH"/tlauc
    tar -zxvf /tmp/tlauc-linux.tar.gz --directory "$TOOLSPATH"/tlauc/
    echo "export PATH=\$PATH:\"$TOOLSPATH\"/tlauc" >> "$HOME/.bashrc"
fi
