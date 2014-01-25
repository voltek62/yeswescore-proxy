#!/bin/sh

# verifying parameters
if [ $# -ne 1 ]
then
  echo "usage : ./deploy-proxy.sh branch"
  exit 1
fi

# if not master, ask for confirmation
if [ "$1" != "master" ]
then
  echo "press Y to confirm you want to checkout branch '$1' [Y/N]"
  read y
  if [ $y = "Y" ]
  then
    echo "confirmed"
  else
    echo "canceled"
    exit 1
  fi
fi

# start checkout
echo "checkouting $1"
# cleaning deploy directory
rm -rf ~/deploy/
mkdir ~/deploy/
cd ~/deploy/
# grabbing code from github
#git clone -b $1 git@github.com:yeswescore/yeswescore-proxy.git
git clone -b $1 git@github.com:voltek62/yeswescore-proxy.git
# analysing result
if [ $? -eq 0 ]
then
  echo "branch $1 is deployed in ~/deploy/yeswescore-proxy/"
else
  echo "error during clone, abort."
  exit 1
fi

# rsync
echo "sending code to integration environment"
sudo rsync -rltov --del --ignore-errors --exclude node_modules --exclude .git --force -e 'ssh -p 42' yeswescore-proxy node@www.yeswescore.com:/opt/web/
#echo "sending code to prod server"
#sudo rsync -rltov --del --ignore-errors --exclude node_modules --exclude .git --force -e 'ssh -p 42' yeswescore-proxy root@188.165.247.143:/opt/web/
