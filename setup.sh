#!/usr/bin/env bash

print() {
    echo "[+] $1"
}

bar(){
    echo "++++++++++++++++++++++++++++++++++"
}
salt (){
    echo ""
}

title(){
    bar
    print "INSTALLING GIT DEPLOY SYSTEM NGINX & NODE"
    print "Author s0c5<david.barinas.dev@gmail.com>"
    bar
    salt
}

dependencies(){
    #   apt dependencies
    sudo apt-get install -y awscli jq git
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
}

download(){
    print "downloading $1 in $2"
    wget $1 -O $2
}

title

print "installing dependencies"
# dependencies
salt
print "Download archive"
download https://github.com/S0c5/nginx-node-git-deployer/archive/master.zip  /tmp/master.zip
unzip -f /tmp/master.zip -d /tmp/
rm -rf /tmp/master.zip
mv /tmp/nginx-node-git-deployer/archives/tags-to-env.sh /etc/profiles.d/tags-to-env.sh
