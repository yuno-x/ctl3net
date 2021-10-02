#!/bin/bash


if [ "`which docker`" == "" ]
then
  echo -n "Do you want to install docker? [y/n]: "
  read $ANS
  if [ "$ANS" == "y" ]
  then
    sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt -y install docker-ce
  else
    echo "Install Canceled."
  fi
fi


IMAGENAME=node
if [ "$1" != "" ]
then
  IMAGENAME=$1
fi

#cat << EOF > /dev/null
EXISTIMAGE=$(sudo docker images $IMAGENAME | grep -v "REPOSITORY")

if [ "$EXISTNODE" != "" ]
then
  exit -1
fi

EXISTIMAGE=$(sudo docker images ubuntu | grep -v "REPOSITORY")
if [ "$EXISTIMAGE" == "" ]
then
  sudo docker pull ubuntu
fi
sudo docker run --hostname ubuntu --name ubuntu --detach ubuntu bash -c "while [ 1 ]; do sleep 60; done"
sudo docker commit ubuntu $IMAGENAME
sudo docker rm -f `sudo docker ps -aq`
#EOF

CNAME=$IMAGENAME

sudo docker run --hostname $CNAME --name $CNAME --detach $IMAGENAME bash -c "while [ 1 ]; do sleep 60; done"
sudo docker exec $CNAME bash -c 'echo "Asia/Tokyo" > /etc/timezone'
sudo docker exec $CNAME bash -c 'ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime'
sudo docker exec $CNAME bash -c 'cat << EOF >> ~/.bashrc
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
EOF'

sudo docker exec -it $CNAME apt update
sudo docker exec -it $CNAME apt-file update
sudo docker exec -it $CNAME bash -c 'yes | unminimize'
sudo docker exec -it $CNAME apt -y install tmux vim iproute2 iputils-ping curl nmap tcpdump apt-file w3m x11-apps systemd man openssh-server openssh-client telnetd quagga apache2 dsniff isc-dhcp-server
sudo docker exec -it $CNAME bash -c 'echo no | apt -y install wireshark'
sudo docker exec $CNAME bash -c 'for FILE in `ls /usr/share/doc/quagga-core/examples/*.sample`; do echo $FILE - /etc/quagga/$(basename -s .sample $FILE); done'
sudo docker commit $CNAME $IMAGENAME
sudo docker rm -f `sudo docker ps -aq`
