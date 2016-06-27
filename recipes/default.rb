# tmp dir for deploy keys
directory "/tmp/.ssh"

# installs and configures a mysql server
include_recipe "raven-db::install_mysql_server"

