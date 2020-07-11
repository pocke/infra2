rbenv_root = "/home/alarm/.rbenv"
rbenv_init = <<-EOS
  export RBENV_ROOT=#{rbenv_root}
  export PATH="#{rbenv_root}/bin:${PATH}"
  eval "$(rbenv init --no-rehash -)"
EOS

execute "gem install hatenikki" do
  command "#{rbenv_init} gem install hatenikki:0.2.0"
  not_if "#{rbenv_init} gem list --installed hatenikki -v 0.2.0"
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

service 'hatenikki.timer' do
  user 'root'
  action [:enable, :start]
end

execute 'systemctl daemon-reload' do
  user 'root'
  action :nothing
end
