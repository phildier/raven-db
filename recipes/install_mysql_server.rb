
case node[:platform_family]
when "debian"
	package "mysql-server-5.5"

	service "mysql" do
		action [:enable, :start]
	end

when "rhel"
	include_recipe "yum-mysql-community::mysql56"
	package "mysql-community-server"
end

# set password if blank
bash "set-mysql-root-pw" do
	code "mysqladmin -u root password '#{node[:raven_db][:root_password]}'"
	only_if "mysql -u root -e 'show databases' 2>/dev/null"
end

# set up mysql timezones table
bash "set-timezone-info" do
	code "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -h 127.0.0.1 -u root -p#{node[:raven_db][:root_password]} mysql"
	not_if "mysql -u root -p#{node[:raven_db][:root_password]} -e 'set session time_zone = \"US/Eastern\"'"
end

