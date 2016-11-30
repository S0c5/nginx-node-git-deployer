#!/usr/bin/env bash
#   variables
export GIT_SERVER_DIR=${1:-/opt/server.git}
export APP_DOMAIN=${2:-localhost}
export APP_PORT=${3:-3000}

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
    sudo apt-get update
    sudo apt-get install -y awscli jq git nginx unzip zip
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash
    #   aws configure
}

download(){
    print "downloading $1 in $2"
    wget $1 -O $2
}

start_services(){
    sudo service nginx restart
}

title

bar
print " git dir: $GIT_SERVER_DIR"
print " app domain: $APP_DOMAIN"
print " app port: $APP_PORT"
bar

print "installing dependencies"
dependencies
salt
print "Download archive"
download https://github.com/S0c5/nginx-node-git-deployer/archive/master.zip  /tmp/master.zip

unzip  -o /tmp/master.zip -d /tmp/
rm -rf /tmp/master.zip
sudo mv /tmp/nginx-node-git-deployer-master/archives/tags-to-env.sh /etc/profile.d/tags-to-env.sh


print "Init git Bare"

sudo mkdir ${GIT_SERVER_DIR}
sudo chmod 777 ${GIT_SERVER_DIR}
cd ${GIT_SERVER_DIR}
git init --bare
sudo rm -rf ${GIT_SERVER_DIR}/hooks/post-receive
sudo mv /tmp/nginx-node-git-deployer-master/archives/post-receive ${GIT_SERVER_DIR}/hooks/
sudo chmod +x ${GIT_SERVER_DIR}/hooks/post-receive


print "setup nginx"

sed -i -e "s/_DOMAIN_/$APP_DOMAIN/g" /tmp/nginx-node-git-deployer-master/archives/nginx-http.conf
sed -i -e "s/_PORT_/$APP_PORT/g" /tmp/nginx-node-git-deployer-master/archives/nginx-http.conf
sudo mv /tmp/nginx-node-git-deployer-master/archives/nginx-http.conf /etc/nginx/sites-enabled/default


print "starting nginx"
start_services