rbenv_root = "/home/alarm/.rbenv"
rbenv_init = <<-EOS
  export RBENV_ROOT=#{rbenv_root}
  export PATH="#{rbenv_root}/bin:${PATH}"
  eval "$(rbenv init --no-rehash -)"
EOS

execute "gem install hatenikki" do
  command "#{rbenv_init} gem install hatenikki"
  not_if "#{rbenv_init} gem list hatenikki | grep '^hatenikki'"
end

remote_file '/etc/systemd/system/hatenikki.service' do
  user 'root'
  owner 'root'
  group 'root'

  notifies :run, 'execute[systemctl daemon-reload]'
end

remote_file '/etc/systemd/system/hatenikki.timer' do
  user 'root'
  owner 'root'
  group 'root'
end

directory '/home/alarm/.config/hatenikki' do
  owner 'alarm'
  group 'users'
end

template '/home/alarm/.config/hatenikki/hatenablog.yaml' do
  owner 'alarm'
  group 'users'
end

execute 'systemctl enable hatenikki.timer' do
  user 'root'
  not_if "systemctl status hatenikki.timer | grep 'Loaded:' | grep enabled"
end

execute 'systemctl start hatenikki.timer' do
  user 'root'
  not_if "systemctl status hatenikki.timer | grep 'Active: active'"
end

execute 'systemctl daemon-reload' do
  user 'root'
  action :nothing
end
