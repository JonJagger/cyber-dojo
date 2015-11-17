
if [ -z "$1" ]; then
  echo "${0} <NODE>"
  exit
fi

node=$1

sudo -u cyber-dojo docker-machine create \
  --driver google \
  --google-project cyber-dojo \
  --google-zone europe-west1-b \
  --google-machine-type n1-standard-1 \
  --google-disk-size 50 \
  $node
