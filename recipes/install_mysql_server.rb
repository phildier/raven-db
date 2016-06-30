
bash "mysql-makesure-uptodate" do
	code <<-EOH
	yum -y update mysql*
	EOH
end

case node[:raven_db][:version]
when "56"
	bash "install-mysql" do
		code <<-EOH
		echo "erase mysql*
			install mysql56u mysql56u-libs  mysql56u-common mysql56u-server mysql56u-devel mysqlclient16
			run" |yum -y shell
		EOH
	end
when "57"
	bash "install-mysql" do
		code <<-EOH
		echo "erase mysql*
			install mysql57u mysql57u-libs  mysql57u-common mysql57u-server mysql57u-devel mysqlclient16
			run" |yum -y shell
		EOH
	end

end


template "/etc/my.cnf" do
	source "my.cnf.erb"
end

service "mysqld" do
	action [:start, :enable]
end

# set password if blank
bash "set-mysql-root-pw" do
	code <<-EOH
	set -x
	mysqladmin -u root password '#{node[:raven_db][:root_password]}'
	mysql -u root -p'#{node[:raven_db][:root_password]}' -e 'GRANT ALL PRIVILEGES on *.* to root@127.0.0.1 identified by "#{node[:raven_db][:root_password]}"'
	EOH
	only_if "mysql -u root -e 'show databases' 2>/dev/null"
end

# set up mysql timezones table
bash "set-timezone-info" do
	code "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -h 127.0.0.1 -u root -p#{node[:raven_db][:root_password]} mysql"
	not_if "mysql -u root -p#{node[:raven_db][:root_password]} -e 'set session time_zone = \"US/Eastern\"'"
end
