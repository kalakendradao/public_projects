network=$1
echo $network
#install node npm
echo -------------------------------------------------------------------------------------
echo ----------------------------install node npm-----------------------------------------
echo -------------------------------------------------------------------------------------
curl --silent --location https://rpm.nodesource.com/setup_16.x | bash -
yum -y install nodejs

echo -------------------------------------------------------------------------------------
echo ----------------------------Install Yarn---------------------------------------------
echo -------------------------------------------------------------------------------------
#Install Yarn
echo 
npm install yarn -g

echo -------------------------------------------------------------------------------------
echo ----------------------------Install Near CLI-----------------------------------------
echo -------------------------------------------------------------------------------------
# Install Near CLI
npm install -g near-cli

echo -------------------------------------------------------------------------------------
echo ----------------------------Verify Near Version--------------------------------------
echo -------------------------------------------------------------------------------------
# Verify Near Version
near --version

echo -------------------------------------------------------------------------------------
echo ----------------------------Set Shardnet---------------------------------------------
echo -------------------------------------------------------------------------------------
# Set Shardnet
export NEAR_ENV=shardnet

echo -------------------------------------------------------------------------------------
echo ----------------------------Set Shardnet Environment persistent----------------------
echo -------------------------------------------------------------------------------------
# Set Shardnet Environment persistent:
echo 'export NEAR_ENV=shardnet' >> ~/.bashrc

echo -------------------------------------------------------------------------------------
echo ----------------------------Install developer tools----------------------------------
echo -------------------------------------------------------------------------------------
# Install developer tools:
sudo yum install -y git wget awscli curl binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo

echo -------------------------------------------------------------------------------------
echo ----------------------------Install Python-------------------------------------------
echo -------------------------------------------------------------------------------------
# Install Python
sudo yum install python3-pip

echo -------------------------------------------------------------------------------------
echo ----------------------------Setup the configuration----------------------------------
echo -------------------------------------------------------------------------------------
# Setup the configuration:
USER_BASE_BIN=$(python3 -m site --user-base)/bin
export PATH="$USER_BASE_BIN:$PATH"

echo -------------------------------------------------------------------------------------
echo ----------------------------Install Building env-------------------------------------
echo -------------------------------------------------------------------------------------
# Install Building env
sudo yum install clang build-essential make -y

echo -------------------------------------------------------------------------------------
echo ----------------------------Install rust---------------------------------------------
echo -------------------------------------------------------------------------------------
#install rust
sudo yum remove rustc -y
sh ~/public_projects/node_automation/rustup-init.sh -y

echo -------------------------------------------------------------------------------------
echo ----------------------------Source the environment-----------------------------------
echo -------------------------------------------------------------------------------------
# Source the environment
source $HOME/.cargo/env || true
source ~/.cargo/env || true

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
aws s3 --no-sign-request cp s3://build.openshards.io/stakewars/"$network"/data.tar.gz .  
tar -xzvf data.tar.gz

echo -------------------------------------------------------------------------------------
echo ----------------------------Run node-------------------------------------------------
echo -------------------------------------------------------------------------------------
# Run node
cd ~/nearcore
./target/release/neard --home ~/.near run

echo -------------------------------------------------------------------------------------
echo ----------------------------COMPLETED-------------------------------------------------
echo -------------------------------------------------------------------------------------

