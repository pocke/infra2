rbenv_root = "/home/alarm/.rbenv"
rbenv_init = <<-EOS
  export RBENV_ROOT=#{rbenv_root}
  export PATH="#{rbenv_root}/bin:${PATH}"
  eval "$(rbenv init --no-rehash -)"
EOS

execute "gem install yudachi" do
  version = '0.0.1'
  command "#{rbenv_init} gem install yudachi -v #{version}"
  not_if "#{rbenv_init} gem list --installed yudachi -v #{version}"
end

template '/etc/systemd/system/yudachi.service' do
  user 'root'
  owner 'root'
  group 'root'

  notifies :run, 'execute[systemctl daemon-reload]'
end

remote_file '/etc/systemd/system/yudachi.timer' do
  user 'root'
  owner 'root'
  group 'root'
end

service 'yudachi.timer' do
  user 'root'
  action [:enable, :start]
end

execute 'systemctl daemon-reload' do
  user 'root'
  action :nothing
end
