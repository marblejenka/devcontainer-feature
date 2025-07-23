#!/usr/bin/env bash

TOOLSPATH=${TOOLSPATH:-"tools"}
SETUP_SHORTHAND=${SETUPSHORTHAND:-true}
INSTALL_TLAPLUS=${INSTALLTLAPLUS:-true}
VERSION_FOR_TLAPLUS=${VERSIONFORTLAPLUS:-"latest"}
INSTALL_COMMUNITY_MODULES=${INSTALLCOMMUNITYMODULES:-true}
VERSION_FOR_COMMUNITY_MODULES=${VERSIONFORCOMMUNITYMODULES:-"latest"}
INSTALL_TLAPM=${INSTALLTLAPM:-true}
VERSION_FOR_TLAPM=${VERSIONFORTLAPM:-"1.4.5"}
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
    [ "$INSTALL_TLAPM" = "false" ] && \
    [ "$INSTALL_APALACHE" = "false" ] && \
    [ "$INSTALL_TLAUC" = "false" ]; then
     echo "No TLA+ tools selected for installation. Exiting."
     exit 0
fi

## Place to install TLC, TLAPM, Apalache, ...
if [ "$TOOLSPATH" = "defalut" ]; then
    TOOLSPATH="/tools"
fi
mkdir -p "$TOOLSPATH"


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
    echo "alias tlcrepl='java -cp \"$TOOLSPATH\"/tla2tools.jar tlc2.REPL'" >> "$HOME/.bashrc"
    echo "alias tlc='java -cp \"$TOOLSPATH\"/tla2tools.jar tlc2.TLC'" >> "$HOME/.bashrc"
    echo "alias sany='java -cp \"$TOOLSPATH\"/tla2tools.jar tla2sany.SANY'" >> "$HOME/.bashrc"
    echo "alias pcal='java -cp \"$TOOLSPATH\"/tla2tools.jar pcal.trans'" >> "$HOME/.bashrc"
    echo "alias tla2tex='java -cp \"$TOOLSPATH\"/tla2tools.jar tla2tex.TLA'" >> "$HOME/.bashrc"
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
        wget -N "https://github.com/tlaplus/tlapm/releases/download/v${VERSION_FOR_TLAPM}/${TLAPM_INSTALLER}" -P "$TOOLSPATH"/
        tar -xzf "/tmp/${TLAPM_INSTALLER}" -C "$TOOLSPATH"/tlapm --strip-components=1
        echo "export PATH=\$PATH:\"$TOOLSPATH\"/tlapm/bin"
    else
        TLAPM_VERSION_TAG="latest/download"
        if [ "$VERSION_FOR_TLAPM" != "latest" ]; then
            TLAPM_VERSION_TAG="download/v${VERSION_FOR_TLAPM}"
        fi
        TLAPM_INSTALLER="tlaps-${VERSION_FOR_TLAPM}-x86_64-linux-gnu-inst.bin"
        wget -N "https://github.com/tlaplus/tlapm/releases/download/${TLAPM_VERSION_TAG}/${TLAPM_INSTALLER}" -P "$TOOLSPATH"/
        chmod +x "$TOOLSPATH/${TLAPM_INSTALLER}"
        "$TOOLSPATH/${TLAPM_INSTALLER}" -d "$TOOLSPATH"/tlaps
        echo "export PATH=\$PATH:\"$TOOLSPATH\"/tlaps/bin" >> "$HOME/.bashrc"
    fi
fi

if [ "$INSTALL_APALACHE" = "true" ]; then
    ## Install Apalache https://github.com/informalsystems/apalache/releases
    APALACHE_VERSION_TAG="latest/download"
    if [ "$VERSION_FOR_APALACHE" != "latest" ]; then
        APALACHE_VERSION_TAG="download/v${VERSION_FOR_APALACHE}"
    fi
    wget -qN "https://github.com/informalsystems/apalache/releases/${APALACHE_VERSION_TAG}/apalache.tgz" -P /tmp
    tar -zxvf /tmp/apalache.tgz --directory "$TOOLSPATH"/
    echo "export PATH=\$PATH:\"$TOOLSPATH\"/apalache/bin" >> "$HOME/.bashrc"
    "$TOOLSPATH"/apalache/bin/apalache-mc config --enable-stats=true
fi

if [ "$INSTALL_TLAUC" = "true" ]; then
    ## Install TLAUC https://github.com/tlaplus-community/tlauc/releases/
    TLAUC_VERSION_TAG="latest/download"
    if [ "$VERSION_FOR_TLAUC" != "latest" ]; then
        TLAUC_VERSION_TAG="download/v${VERSION_FOR_TLAUC}"
    fi
    wget -qN "https://github.com/tlaplus-community/tlauc/releases/${TLAUC_VERSION_TAG}/tlauc-linux.tar.gz" -P /tmp
    mkdir -p "$TOOLSPATH"/tlauc
    tar -zxvf /tmp/tlauc-linux.tar.gz --directory "$TOOLSPATH"/tlauc/
    echo "export PATH=\$PATH:\"$TOOLSPATH\"/tlauc" >> "$HOME/.bashrc"
fi
