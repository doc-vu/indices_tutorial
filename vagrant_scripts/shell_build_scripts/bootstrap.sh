#!/usr/bin/env bash
# Yogesh Barve <yogesh.d.barve@vanderbilt.edu>


set_env_var_func(){
    USER_ENV_FILE="/home/vagrant/.bashrc"
    echo $1 >> $USER_ENV_FILE
    source $USER_ENV_FILE
}

disable_ipv6() {
    # Multicast in a VM doesn't work properly with IPv6, so we must
    # disable IPv6 on all network interfaces.
    sudo sh -c 'echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf'
    sudo sh -c 'echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf'
    sudo sh -c 'echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf'
    sudo sysctl -p
}

git_func(){
    sudo apt-get install git -y
    sudo apt-get install gitk -y
}

python27_func(){
    sudo add-apt-repository ppa:fkrull/deadsnakes -y
    sudo apt-get update -y
    sudo apt-get install python2.7 -y
}

##########
# Docker #
##########
docker_func(){
    sudo apt-get install linux-image-extra-"$(uname -r)" -y
    sudo apt-get install apparmor -y
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo sh -c "echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list"
    sudo apt-get update --fix-missing
    sudo apt-get purge lxc-docker -y
    sudo apt-cache policy docker-engine
    sudo apt-get update --fix-missing
    sudo apt-get install docker-engine -y
    sudo service docker start
    sudo usermod -aG docker vagrant
}

docker_compose_func(){
    sudo apt-get install python-pip -y
    sudo pip install docker-compose
}

######################
# WebGME Development #
######################
mongodb_func(){
    # Add the MongoDB v3.0 repository
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

    sudo apt-get update
    sudo apt-get install -y mongodb-org

    # add robomongo
    cd $HOME/Downloads/
    wget https://download.robomongo.org/0.9.0/linux/robomongo-0.9.0-linux-x86_64-0786489.tar.gz
    tar -xvzf robomongo-0.9.0-linux-x86_64-0786489.tar.gz
    sudo mkdir /usr/local/bin/robomongo
    sudo mv  robomongo-0.9.0-linux-x86_64-0786489/* /usr/local/bin/robomongo
    cd /usr/local/bin/robomongo/bin
}

node_func(){
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
    source /home/vagrant/.nvm/nvm.sh
    nvm install 4.5.0
    nvm use 4.5.0
    nvm alias default 4.5.0
}

webgme_func()
{

    cd $CPSWT_WEBGME_HOME
    npm install

    # Autostart WebGME on crash and reboot
    sudo cp /vagrant/config/webgme.conf /etc/init/webgme.conf
    sudo service webgme start

   
    cd $CPSWT_WEBGMEGLD_HOME
    npm install

    # Autostart WebGMEGld on crash and reboot
    sudo cp /vagrant/config/webgmegld.conf /etc/init/webgmegld.conf
    sudo service webgmegld start
}


chrome_browser_func()
{
    # Add the chrome debian repository
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

    sudo apt-get update
    sudo apt-get install google-chrome-stable -y

    # Set chrome as the default browser
    xdg-mime default google-chrome.desktop text/html
    xdg-mime default google-chrome.desktop x-scheme-handler/http
    xdg-mime default google-chrome.desktop x-scheme-handler/https
    xdg-mime default google-chrome.desktop x-scheme-handler/about
}


######################
# Other Applications #
######################
terminator_func(){
    sudo apt-get install terminator -y
}

sublime3_func(){
    sudo add-apt-repository ppa:webupd8team/sublime-text-3
    sudo apt-get update
    sudo apt-get install sublime-text-installer -y
}

ansible_func(){
    sudo apt-get install  -y software-properties-common
    sudo apt-add-repository  -y ppa:ansible/ansible
    sudo apt-get update -y
    sudo apt-get install  -y ansible
    sudo apt-get install -y libxml2-dev libxslt-dev python-dev
    sudo apt-get install -y python3-lxml
}


# Installs the webgme_cli_tool
webgme_cli_func(){

  npm install -g webgme/webgme-setup-tool

}

#openjdk7_func
java8_func
ansible_func

# docker
docker_func
docker_compose_func

# webgme development
node_func
webgme_func
# misc applications
chrome_browser_func
terminator_func
sublime3_func
