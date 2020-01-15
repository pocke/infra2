HOST = 'skitty'

if ENV['UPDATE_ALL']
  execute 'pacman -Syu' do
    user 'root'
  end
end

# --- system

user 'root' do
  user 'root'
  password node['root_password']
end

user 'alarm' do
  password node['alarm_password']
end

execute "hostnamectl set-hostname #{HOST}" do
  user 'root'
  not_if "hostnamectl status | grep 'Static hostname: #{HOST}$'"
end

# --- packages

%w[vim].each do |pkg|
  package pkg do
    user 'root'
  end
end
