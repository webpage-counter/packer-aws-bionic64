#!/usr/bin/env bash
set -x

export DEBIAN_FRONTEND=noninteractive
export APTARGS="-qq -o=Dpkg::Use-Pty=0"
sudo apt-get clean ${APTARGS}
sudo apt-get update ${APTARGS}

sudo apt-get upgrade -y ${APTARGS}
sudo apt-get dist-upgrade -y ${APTARGS}

which unzip socat jq dnsutils net-tools vim curl sshpass &>/dev/null || {
sudo apt-get update -y ${APTARGS}
sudo apt-get install unzip socat jq dnsutils net-tools vim curl sshpass -y ${APTARGS}
}

#Plugin for consul connect on nomad
curl -L -o /tmp/cni-plugins.tgz https://github.com/containernetworking/plugins/releases/download/v0.8.1/cni-plugins-linux-amd64-v0.8.1.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf /tmp/cni-plugins.tgz

# Install docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl enable docker
sudo systemctl start docker

# install consul
mkdir -p /tmp/pkg/
if [ -z "$CONSUL_VER" ]; then
    CONSUL_VER=$(curl -sL https://releases.hashicorp.com/consul/index.json | jq -r '.versions[].version' | sort -V | egrep -v 'ent|beta|rc|alpha' | tail -n1)
fi
response=$(curl -LI https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip -o /tmp/pkg/consul_${CONSUL_VER}_linux_amd64.zip -w '%{http_code}\n' -s)

if [ $response == 200 ]; then
    curl -s https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip -o /tmp/pkg/consul_${CONSUL_VER}_linux_amd64.zip
else
   exit 1
fi



echo "Installing Consul version ${CONSUL_VER} ..."
pushd /tmp/pkg
unzip consul_${CONSUL_VER}_linux_amd64.zip 
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul
popd

# install nomad
mkdir -p /tmp/pkg/
if [ -z "$NOMAD_VER" ]; then
    CONSUL_VER=$(curl -sL https://checkpoint-api.hashicorp.com/v1/check/nomad | jq .current_version | tr -d '"')
fi
response=$(curl -LI https://releases.hashicorp.com/nomad/${NOMAD_VER}/nomad_${NOMAD_VER}_linux_amd64.zip -o /tmp/pkg/nomad_${NOMAD_VER}_linux_amd64.zip -w '%{http_code}\n' -s)

if [ $response == 200 ]; then
    curl -s https://releases.hashicorp.com/nomad/${NOMAD_VER}/nomad_${NOMAD_VER}_linux_amd64.zip -o /tmp/pkg/nomad_${NOMAD_VER}_linux_amd64.zip
else
   exit 1
fi



echo "Installing Nomad version ${NOMAD_VER} ..."
pushd /tmp/pkg
unzip nomad_${NOMAD_VER}_linux_amd64.zip 
sudo chmod +x nomad
sudo mv nomad /usr/local/bin/nomad
popd

# Install vault
which vault || {
  pushd /tmp/pkg
  [ -f vault_${VAULT_VER}_linux_amd64.zip ] || {
    sudo wget https://releases.hashicorp.com/vault/${VAULT_VER}/vault_${VAULT_VER}_linux_amd64.zip
  }

  popd
  pushd /tmp/pkg

  sudo unzip vault_${VAULT_VER}_linux_amd64.zip
  sudo chmod +x vault
  sudo mv vault /usr/local/bin/vault
  popd
}

sudo rm -fr /tmp/pkg
set +x
