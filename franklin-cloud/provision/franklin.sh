#
# Global Installs
#

sudo apt-get update
sudo apt-get -y install apt-transport-https vim libreadline-dev libncurses5-dev libpcre3-dev \
    libssl-dev perl make build-essential upstart

#
# Create a 'Franklin' user, with the password 'franklin'
#
useradd -m -p pa4go24cAi1hA -s /bin/bash franklin

#
# Docker Specific Provisioning
#

# Adding the GPG key for Docker
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Add 'Debian'
sudo bash -c "echo 'deb https://apt.dockerproject.org/repo debian-jessie main' >> /etc/apt/sources.list.d/docker.list"

sudo apt-get -y update
sudo apt-get -y install docker-engine

sudo service docker start

#
# Install 'GO'
#

wget https://storage.googleapis.com/golang/go1.5.2.linux-amd64.tar.gz -P /usr/local
tar -C /usr/local -xzf /usr/local/go1.5.2.linux-amd64.tar.gz

# Clean-up
rm /usr/local/go1.5.2.linux-amd64.tar.gz

# Add 'Go' to the user Franklin's PATH
sudo -u franklin -H sh -c 'echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile'


#
# Install and configure nginx and openresty
#

sudo -u franklin -H sh -c 'echo "export PATH=$PATH:/sbin" >> $HOME/.profile'

wget https://openresty.org/download/ngx_openresty-1.9.7.1.tar.gz
tar -xzf ngx_openresty-1.9.7.1.tar.gz

cd ngx_openresty-1.9.7.1 && ./configure --with-luajit && make && sudo make install

sudo -u franklin -H sh -c 'echo "export PATH=/usr/local/openresty/nginx/sbin:$PATH" >> $HOME/.profile'

#
# Set-up all the fun static stuff
#

sudo mkdir -p /var/nginx/conf
sudo cp /franklin-static/nginx/nginx.conf /var/nginx/conf/
sudo cp /franklin-static/nginx/router.lua /var/nginx/conf/
sudo cp /franklin-static/nginx/mime.types /var/nginx/conf/
sudo cp /franklin-static/upstart/franklin-static.conf /etc/init/resty

# Start the service
sudo service resty start
