#!/bin/bash

apt-get update -qq

function install_toolset()
{
    apt-get install -y htop mc bc git-core unzip unrar rar zip wget curl i3 feh \
                       nano vim moc gmpc \
                       chromium-browser \
                       remmina shutter filezilla \
                       vlc thunderbird \
                       python-software-properties \
                       software-properties-common \
                       make gcc \
                       ssh sshfs \
}


function install_docker()
{
    wget -qO- https://get.docker.com/ | sh
    apt-get install -y docker-compose python-pip
}

function install_vbox()
{
    wget -O vbox.deb http://download.virtualbox.org/virtualbox/5.1.14/virtualbox-5.1_5.1.14-112924~Ubuntu~xenial_amd64.deb
    dpkg -i vbox.deb
    apt-get install -f -y
    dpkg -i vbox.deb
    rm vbox.deb
}

function install_vagrant()
{
    wget -O vagrant.deb https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.deb
    dpkg -i vagrant.deb
    rm vagrant.deb
}

function install_st3()
{
    add-apt-repository ppa:webupd8team/sublime-text-3
    apt-get update
    apt-get install -y sublime-text-installer
}

function install_nodejs()
{
    apt-get install -y nodejs \
                       nodejs-legacy \
                       npm
}

function install_npm_tools()
{
    npm install -g bower
}
