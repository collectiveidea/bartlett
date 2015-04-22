#!/bin/bash

source ./env.sh


echo "Installing github-auth..."
bundle install --binstubs

echo "Creating the user ${PAIR_USERNAME}..."
sudo mkdir ${PAIR_HOME}
sudo dscl . create /Users/${PAIR_USERNAME}
sudo dscl . create /Users/${PAIR_USERNAME} RealName ${PAIR_FULL_NAME}
sudo dscl . create /Users/${PAIR_USERNAME} UserShell /bin/bash
sudo dscl . create /Users/${PAIR_USERNAME} UniqueID 1337
sudo dscl . create /Users/${PAIR_USERNAME} PrimaryGroupID 1000
sudo dscl . create /Users/${PAIR_USERNAME} PASSWORD
sudo dscl . create /Users/${PAIR_USERNAME} NFSHomeDirectory ${PAIR_HOME}

echo "Creating the group ${PAIR_GROUP}"
sudo dscl . create /Groups/${PAIR_GROUP}
sudo dscl . create /Groups/${PAIR_GROUP} RealName ${PAIR_GROUP}
sudo dscl . create /Groups/${PAIR_GROUP} passwd "*"
sudo dscl . create /Groups/${PAIR_GROUP} gid 400
sudo dscl . create /Groups/${PAIR_GROUP} GroupMembership ${PAIR_USERNAME}
sudo dscl . append /Groups/${PAIR_GROUP} GroupMembership ${CURRENT_USERNAME}

sudo chown -R ${PAIR_USERNAME}:${PAIR_GROUP} ${PAIR_HOME}

# Set up the SSH directory
sudo -u ${PAIR_USERNAME} mkdir -p ${PAIR_HOME}/.ssh
sudo -u ${PAIR_USERNAME} touch ${PAIR_HOME}/.ssh/authorized_keys
sudo -u ${PAIR_USERNAME} chmod 700 ${PAIR_HOME}/.ssh
sudo -u ${PAIR_USERNAME} chmod 600 ${PAIR_HOME}/.ssh/authorized_keys

# Set up the bin directory
sudo -u ${PAIR_USERNAME} mkdir -p ${PAIR_HOME}/bin
sudo cp ./bin/ssh.sh ${PAIR_HOME}/bin
sudo chown ${PAIR_USERNAME}:${PAIR_GROUP} ${PAIR_HOME}/bin/ssh.sh
sudo -u pair chmod +x ${PAIR_HOME}/bin/ssh.sh

sudo chgrp -R pair /Users/${PAIR_USERNAME}/.ssh

echo "Updating sshd_config..."
sudo sed -E -i.bak 's/^#?(PasswordAuthentication|ChallengeResponseAuthentication).*$/\1 no/' /etc/sshd_config

echo "Symlinking default socket file.."
sudo ln ~/.tmux.socket ${PAIR_HOME}/.tmux.socket
sudo chown ${CURRENT_USERNAME}:${PAIR_GROUP} ${PAIR_HOME}/.tmux.socket
