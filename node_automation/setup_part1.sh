network=$1
nearcore_version=$2
echo $network
echo $nearcore_version

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
echo ----------------------------Set $network---------------------------------------------
echo -------------------------------------------------------------------------------------
# Set $network
export NEAR_ENV=$network

echo -------------------------------------------------------------------------------------
echo ----------------------------Set $network Environment persistent----------------------
echo -------------------------------------------------------------------------------------
# Set Shardnet Environment persistent:
echo 'export NEAR_ENV=$network' >> ~/.bashrc

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
echo ----------------------------Clone nearcore from repo---------------------------------
echo -------------------------------------------------------------------------------------
# Clone nearcore from repo
cd ~
git clone https://github.com/near/nearcore
cd nearcore
git fetch origin --tags
git checkout tags/"$nearcore_version" -b mynode

echo -------------------------------------------------------------------------------------
echo ----------------------------COMPLETED-------------------------------------------------
echo -------------------------------------------------------------------------------------
exec bash
