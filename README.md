# Example of how to create AMI with Consul/Nomad/Vault installed on AWS with Packer

## You beed 1st to install packer

`brew install packer`

## Fork this repo

You need to make env variables for your AWS keys
```
export AWS_ACCESS_KEY_ID=MYACCESSKEYID
export AWS_SECRET_ACCESS_KEY=MYSECRETACCESSKEY
```

**Execute below build command**

`packer build -var 'CONSUL_VER=1.6.1' -var 'NOMAD_VER=0.10.1' -var 'VAULT_VER=1.2.4' createami.json`


## After AMI is created

# Kitchen test included

## Install kitchen
-  gem install inspec
-  gem install bundler
-  gem install kitchen-ec2
-  gem install test-kitchen
-  bundle install

## Test

- bundle exec kitchen converge
- bundle exec kitchen verify
- bundle exec kitchen destroy
