describe command('which consul') do
  its('stdout') { should eq "/usr/local/bin/consul\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('which nomad') do
  its('stdout') { should eq "/usr/local/bin/nomad\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('which vault') do
  its('stdout') { should eq "/usr/local/bin/vault\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('which docker') do
  its('stdout') { should eq "/usr/bin/docker\n" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('nomad version') do
  its('stdout') { should include "v0.11.1" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('vault version') do
  its('stdout') { should include "v1.4.0" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('consul version') do
  its('stdout') { should include "v1.7.2" }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe systemd_service('docker') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end
