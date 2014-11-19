#!/bin/bash
# Simple setup.sh for configuring Ubuntu

#Essentials
sudo apt-get install -y build-essential
sudo apt-get install -y git

#Remove open source implementation of java
sudo apt-get purge openjdk-\* icedtea-\* icedtea6-\*

#Add repository and install oracle java
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update && sudo apt-get install oracle-java8-installer

# Install vim and vundle
sudo apt-get install -y vim-gtk
mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim +PluginInstall +qall

#Add public key from "Richard Kreuter <richard@10gen.com>"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
#Create the /etc/apt/sources.list.d/mongodb.list list file
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list
sudo apt-get update
#Install mongodb
sudo apt-get install -y mongodb-10gen

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y curl
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
#source $HOME/.nvm/nvm.sh
#nvm install v0.10.12
#nvm use v0.10.12

#Install nodejs dependencies
sudo apt-get install python-software-properties python g++ make
#Add chris-lea PPA to the system 
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
#Install nodejs
sudo apt-get install -y nodejs

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

#Install expressjs
sudo npm install express -g

#Install bower
sudo npm install bower -g

#Install grunt
sudo npm install grunt-cli -g

