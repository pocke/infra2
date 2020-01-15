HOST = 'skitty'

if ENV['UPDATE_ALL']
  execute 'pacman -Syu base-devel --noconfirm' do
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

execute 'timedatectl set-ntp true' do
  user 'root'
  not_if 'timedatectl status | grep synchronized | grep yes'
end

execute 'timedatectl set-timezone Asia/Tokyo' do
  user 'root'
  not_if 'timedatectl status | grep "Time zone: Asia/Tokyo"'
end

execute 'echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen' do
  user 'root'
  not_if 'grep "^en_US.UTF-8 UTF-8" /etc/locale.gen'
  notifies :run, 'execute[locale-gen]', :immediately
end

execute 'locale-gen' do
  user 'root'
  action :nothing
end

execute 'localectl set-locale LANG=en_US.UTF-8' do
  user 'root'
  not_if 'localectl status | grep "System Locale: LANG=en_US.UTF-8"'
end

# --- packages

%w[vim tmux].each do |pkg|
  package pkg do
    user 'root'
  end
end

# aur_package 'yay' do
#   user 'alarm'
# end
# aur_package 'ruby-build'
# aur_package 'rbenv'
