#!/usr/bin/env bash

TOOLSPATH=${TOOLSPATH:-"/tlaplus"}
SETUP_SHORTHAND=${SETUPSHORTHAND:-true}
INSTALL_TLAPLUS=${INSTALLTLAPLUS:-true}
VERSION_FOR_TLAPLUS=${VERSIONFORTLAPLUS:-"latest"}
INSTALL_COMMUNITY_MODULES=${INSTALLCOMMUNITYMODULES:-true}
VERSION_FOR_COMMUNITY_MODULES=${VERSIONFORCOMMUNITYMODULES:-"latest"}
INSTALL_TLAPM=${INSTALLTLAPM:-true}
VERSION_FOR_TLAPM=${VERSIONFORTLAPM:-"1.6.0-pre"}
INSTALL_APALACHE=${INSTALLAPALACHE:-true}
VERSION_FOR_APALACHE=${VERSIONFORAPALACHE:-"latest"}
INSTALL_TLAUC=${INSTALLTLAUC:-true}
VERSION_FOR_TLAUC=${VERSIONFORTLAUC:-"latest"}

set -e

if [ "$SETUP_SHORTHAND" = "true" ]; then
    ## Install git if not present
    if ! command -v git >/dev/null 2>&1; then
        apt-get update -y
        apt-get install -y git
    fi

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
    [ "$INSTALL_TLAPM" = "false" ] && \
    [ "$INSTALL_APALACHE" = "false" ] && \
    [ "$INSTALL_TLAUC" = "false" ]; then
     echo "No TLA+ tools selected for installation. Exiting."
     exit 0
fi

## Place to install TLC, TLAPM, Apalache, ...
mkdir -p "$TOOLSPATH"

## Install wget if not present
if ! command -v wget >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y wget
fi

if [ "$INSTALL_TLAPLUS" = "true" ]; then
    ## Install TLA+ Tools https://nightly.tlapl.us/ or https://github.com/tlaplus/tlaplus/releases
    if [ "$VERSION_FOR_TLAPLUS" = "nightly" ]; then
        wget -qN "https://nightly.tlapl.us/dist/tla2tools.jar" -P "$TOOLSPATH"/
    else
        TLA_PLUS_VERSION_TAG="latest/download"
        if [ "$VERSION_FOR_TLAPLUS" != "latest" ]; then
            TLA_PLUS_VERSION_TAG="download/v${VERSION_FOR_TLAPLUS}"
        fi
        wget -qN "https://github.com/tlaplus/tlaplus/releases/${TLA_PLUS_VERSION_TAG}/tla2tools.jar" -P "$TOOLSPATH"/
    fi
    for tool in tlcrepl:tlc2.REPL tlc:tlc2.TLC sany:tla2sany.SANY pcal:pcal.trans tla2tex:tla2tex.TLA; do
        TOOL_NAME="${tool%%:*}"
        TOOL_CLASS="${tool#*:}"
        (
            echo "#!/bin/sh"
            echo "java -cp \"$TOOLSPATH/tla2tools.jar\" \"$TOOL_CLASS\" \"\$@\""
        ) > "/usr/local/bin/$TOOL_NAME"
        chmod +x "/usr/local/bin/$TOOL_NAME"
    done
fi

if [ "$INSTALL_COMMUNITY_MODULES" = "true" ]; then
    ## Install CommunityModules https://github.com/tlaplus/CommunityModules/releases
    COMMUNITY_MODULES_VERSION_TAG="latest/download"
    if [ "$VERSION_FOR_COMMUNITY_MODULES" != "latest" ]; then
        COMMUNITY_MODULES_VERSION_TAG="download/${VERSION_FOR_COMMUNITY_MODULES}"
    fi
    wget -qN "https://github.com/tlaplus/CommunityModules/releases/${COMMUNITY_MODULES_VERSION_TAG}/CommunityModules-deps.jar" -P "$TOOLSPATH"/
fi

if [ "$INSTALL_TLAPM" = "true" ]; then
    ## Install TLAPM (TLA⁺ Proof Manager) https://github.com/tlaplus/tlapm/releases/
    if [ "$VERSION_FOR_TLAPM" = "1.6.0-pre" ]; then
        TLAPM_INSTALLER="tlapm-${VERSION_FOR_TLAPM}-x86_64-linux-gnu.tar.gz"
        wget -N "https://github.com/tlaplus/tlapm/releases/download/${VERSION_FOR_TLAPM}/${TLAPM_INSTALLER}" -P "$TOOLSPATH"/
        mkdir -p "$TOOLSPATH"/tlapm
        tar -xzf "$TOOLSPATH/${TLAPM_INSTALLER}" -C "$TOOLSPATH"/tlapm --strip-components=1
    else
        TLAPM_VERSION_TAG="latest/download"
        if [ "$VERSION_FOR_TLAPM" != "latest" ]; then
            TLAPM_VERSION_TAG="download/v${VERSION_FOR_TLAPM}"
        fi
        TLAPM_INSTALLER="tlaps-${VERSION_FOR_TLAPM}-x86_64-linux-gnu-inst.bin"
        wget -N "https://github.com/tlaplus/tlapm/releases/download/${TLAPM_VERSION_TAG}/${TLAPM_INSTALLER}" -P "$TOOLSPATH"/
        chmod +x "$TOOLSPATH/${TLAPM_INSTALLER}"
        "$TOOLSPATH/${TLAPM_INSTALLER}" -d "$TOOLSPATH"/tlaps
    fi
    if [ -d "$TOOLSPATH"/tlapm/bin ] && [ "$(ls -A "$TOOLSPATH"/tlapm/bin)" ]; then
        ln -s "$TOOLSPATH"/tlapm/bin/* /usr/local/bin/
    else
        echo "Warning: '$TOOLSPATH/tlapm/bin' directory does not exist or is empty. Skipping symbolic link creation."
    fi
fi

if [ "$INSTALL_APALACHE" = "true" ]; then
    ## Install Apalache https://github.com/informalsystems/apalache/releases
    APALACHE_VERSION_TAG="latest/download"
    if [ "$VERSION_FOR_APALACHE" != "latest" ]; then
        APALACHE_VERSION_TAG="download/v${VERSION_FOR_APALACHE}"
    fi
    wget -qN "https://github.com/informalsystems/apalache/releases/${APALACHE_VERSION_TAG}/apalache.tgz" -P "$TOOLSPATH"/
    tar -zxvf "$TOOLSPATH"/apalache.tgz --directory "$TOOLSPATH"/
    if [ -d "$TOOLSPATH"/apalache/bin ] && [ "$(ls -A "$TOOLSPATH"/apalache/bin)" ]; then
        ln -s "$TOOLSPATH"/apalache/bin/* /usr/local/bin/
    else
        echo "Error: Directory '$TOOLSPATH/apalache/bin' does not exist or is empty. Skipping symlink creation."
    fi
    "$TOOLSPATH"/apalache/bin/apalache-mc config --enable-stats=true
fi

if [ "$INSTALL_TLAUC" = "true" ]; then
    ## Install TLAUC https://github.com/tlaplus-community/tlauc/releases/
    TLAUC_VERSION_TAG="latest/download"
    if [ "$VERSION_FOR_TLAUC" != "latest" ]; then
        TLAUC_VERSION_TAG="download/v${VERSION_FOR_TLAUC}"
    fi
    wget -qN "https://github.com/tlaplus-community/tlauc/releases/${TLAUC_VERSION_TAG}/tlauc-linux.tar.gz" -P /tmp
    mkdir -p "$TOOLSPATH"/tlauc/bin
    tar -zxvf /tmp/tlauc-linux.tar.gz --directory "$TOOLSPATH"/tlauc/bin
    if [ "$(ls -A "$TOOLSPATH"/tlauc/bin/ 2>/dev/null)" ]; then
        ln -sf "$TOOLSPATH"/tlauc/bin/* /usr/local/bin/
    else
        echo "Warning: Source directory '$TOOLSPATH/tlauc/bin/' is empty. No symbolic links created."
    fi
fi
