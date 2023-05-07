#!/bin/bash
#Steam Deck Mount External Drive by scawp
#License: DBAD: https://github.com/araujorm/Steam-Deck.Mount-External-Drive/blob/master/LICENSE.md
#Source: https://github.com/araujorm/Steam-Deck.Mount-External-Drive
# Use at own Risk!

#curl -sSL https://raw.githubusercontent.com/araujorm/Steam-Deck.Mount-External-Drive/master/curl_install.sh | bash

user="$(id -u deck)"
#stop running script if anything returns an error (non-zero exit )
set -e

repo_url="https://raw.githubusercontent.com/araujorm/Steam-Deck.Mount-External-Drive/master"
repo_lib_dir="$repo_url/lib"

tmp_dir="`mktemp -d`"
trap "rm -rf $tmp_dir" EXIT

rules_install_dir="/etc/udev/rules.d"
service_install_dir="/etc/systemd/system"

function prompt() {
  TEXT=$1
  set +e
  if [ -n "$DISPLAY" ]; then
    zenity --question --width=400 --text="$TEXT"
  else
    TEXT=${TEXT//\\n/$'\n'}
    read -p "$TEXT (y/n) " -e -r REPLY
    [ "$REPLY" = y ]
  fi
  EX=$?
  set -e
  return $EX
}


if [ ! -e /etc/steamos-release ] || [ "$user" != "1000" ]; then
  prompt "This code has been written specifically for the Steam Deck with user Deck \
  \nIt appears you are running on a different system/non-standard configuration. \
  \nAre you sure you want to continue?"
  if [ "$?" != 0 ]; then
    #NOTE: This code will never be reached due to "set -e", the system will already exit for us but just incase keep this
    echo "bye then! xxx"
    exit 1;
  fi
fi

function install_automount () {
  prompt "Read $repo_url/README.md before proceeding. \
  \nDo you want to install the Auto-Mount Service?"
  if [ "$?" != 0 ]; then
    #NOTE: This code will never be reached due to "set -e", the system will already exit for us but just incase keep this
    echo "bye then! xxx"
    exit 0;
  fi

  echo "Downloading Required Files"
  curl -o "$tmp_dir/external-drive-mount@.service" "$repo_lib_dir/external-drive-mount@.service"
  curl -o "$tmp_dir/99-external-drive-mount.rules" "$repo_lib_dir/99-external-drive-mount.rules"

  echo "Copying $tmp_dir/99-external-drive-mount.rules to $rules_install_dir/99-external-drive-mount.rules"
  sudo cp "$tmp_dir/99-external-drive-mount.rules" "$rules_install_dir/99-external-drive-mount.rules"

  echo "Copying $tmp_dir/external-drive-mount@.service to $service_install_dir/external-drive-mount@.service"
  sudo cp "$tmp_dir/external-drive-mount@.service" "$service_install_dir/external-drive-mount@.service"

  echo "Reloading Services"
  sudo udevadm control --reload
  sudo systemctl daemon-reload
}

install_automount

echo "Done."
