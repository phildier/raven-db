package "memcached"

template "/etc/sysconfig/memcached" do
    source "memcached.erb"
    owner "root"
    mode 0644
    variables ({
        :max_conn => node[:raven_db][:memcached_max_conn],
        :max_mem => node[:raven_db][:memcached_max_mem],
        :socket => node[:raven_db][:memcached_socket],
        :user => node[:raven_db][:memcached_user],
        :port => node[:raven_db][:memcached_port]
    })
end

service "memcached" do
    action [ :enable, :start ]
end
