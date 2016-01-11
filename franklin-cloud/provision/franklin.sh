#
# Global Installs
#

sudo apt-get update
sudo apt-get -y install apt-transport-https
sudo apt-get -y install vim

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
# Install Postgres
#

sudo apt-get install -y postgresql postgresql-contrib
