
case node[:platform_family]
when "debian"

	package "mysql-server-5.5"

	mysql_service_name = "mysql"

when "rhel"

	if node['platform_version'].to_f > 7.0
		package "MySQL-server"
		package "MySQL-client"
		mysql_service_name = "mysql"
	else
		package "mysql56u"
		mysql_service_name = "mysqld"
	end

end

service mysql_service_name do
	action [:start, :enable]
end

template "/etc/my.cnf" do
	source "my.cnf.erb"
	notifies :restart, "service[#{mysql_service_name}]", :immediately
end

# set password if blank
bash "set-mysql-root-pw" do
	code <<-EOH
	set -x
	mysqladmin -u root password '#{node[:raven_db][:root_password]}'
	mysql -u root -p'#{node[:raven_db][:root_password]}' -e 'GRANT ALL PRIVILEGES on *.* to root@127.0.0.1 identified by "#{node[:raven_db][:root_password]}"'
	EOH
	only_if "mysql -h 127.0.0.1 -u root -e 'show databases' 2>/dev/null"
end

# set password if set by installer
bash "set-mysql-root-pw-installer" do
	code <<-EOH
	set -x
	oldpass=`grep password /root/.mysql_secret |tail -1 |awk '{print $NF}'`
	mysqladmin -u root -p$oldpass password '#{node[:raven_db][:root_password]}'
	mysql -u root -p'#{node[:raven_db][:root_password]}' -e 'GRANT ALL PRIVILEGES on *.* to root@127.0.0.1 identified by "#{node[:raven_db][:root_password]}"'
	EOH
	only_if  { ::File.exist?('/root/.mysql_secret') }
end


# set up mysql timezones table
bash "set-timezone-info" do
	code "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -h 127.0.0.1 -u root -p#{node[:raven_db][:root_password]} mysql"
	not_if "mysql -u root -p#{node[:raven_db][:root_password]} -e 'set session time_zone = \"US/Eastern\"'"
end

