cd /$USER/public_projects/node_automation/
myString=$(ls | find -type d -name "*net")
network="${myString:2}"
echo $network
echo -------------------------------------------------------------------------------------
echo ----------------------------Source the environment-----------------------------------
echo -------------------------------------------------------------------------------------
# Source the environment
source $HOME/.cargo/env

echo -------------------------------------------------------------------------------------
echo ----------------------------Clone nearcore from repo---------------------------------
echo -------------------------------------------------------------------------------------
# Clone nearcore from repo
cd ~
git clone https://github.com/near/nearcore
cd nearcore
git fetch
git checkout master

echo -------------------------------------------------------------------------------------
echo ----------------------------Compile nearcore binary----------------------------------
echo -------------------------------------------------------------------------------------
# Compile nearcore binary
cargo build -p neard --release --features "$network"

echo -------------------------------------------------------------------------------------
echo ----------------------------Initialize Working Directory-----------------------------
echo -------------------------------------------------------------------------------------
# Initialize Working Directory
cd ~/nearcore
./target/release/neard --home ~/.near init --chain-id "$network" --download-genesis

echo -------------------------------------------------------------------------------------
echo ----------------------------Replace Config.json--------------------------------------
echo -------------------------------------------------------------------------------------
# Replace Config.json
cd ~/.near
rm ~/.near/config.json
wget -O ~/.near/config.json https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/"$network"/config.json

echo -------------------------------------------------------------------------------------
echo ----------------------------Download Latest Snapshot---------------------------------
echo -------------------------------------------------------------------------------------
# Download Latest Snapshot
cd ~/.near
aws s3 --no-sign-request cp s3://near-protocol-public/backups/"$network"/rpc/latest .
LATEST=$(cat latest)
aws s3 --no-sign-request cp --no-sign-request --recursive s3://near-protocol-public/backups/"$network"/rpc/$LATEST ~/.near/data

echo -------------------------------------------------------------------------------------
echo ----------------------------Run node-------------------------------------------------
echo -------------------------------------------------------------------------------------
# Run node
cd ~/nearcore
./target/release/neard --home ~/.near run

echo -------------------------------------------------------------------------------------
echo ----------------------------COMPLETED-------------------------------------------------
echo -------------------------------------------------------------------------------------
