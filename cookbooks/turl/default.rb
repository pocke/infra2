rbenv_root = "/home/alarm/.rbenv"
rbenv_init = <<-EOS
  export RBENV_ROOT=#{rbenv_root}
  export PATH="#{rbenv_root}/bin:${PATH}"
  eval "$(rbenv init --no-rehash -)"
EOS

execute "gem install turl" do
  command "#{rbenv_init} gem install turl"
  not_if "#{rbenv_init} gem list turl | grep '^turl'"
end

template '/etc/systemd/system/turl-collect.service' do
  user 'root'
  owner 'root'
  group 'root'

  notifies :restart, 'service[turl-collect.service]'
end

service 'turl-collect.service' do
  user 'root'
  action [:enable, :start]
end

template '/etc/systemd/system/turl-web.service' do
  user 'root'
  owner 'root'
  group 'root'

  notifies :restart, 'service[turl-web.service]'
end

service 'turl-web.service' do
  user 'root'
  action [:enable, :start]
end

execute 'systemctl daemon-reload' do
  user 'root'
  action :nothing
end
