#安装系统必须组件服务
install_needs(){

	echo "SELINUX=disabled
	SELINUXTYPE=targeted
	" > /etc/selinux/config
	yum -y update
	if test $? != 0 ; then
		echo "yum -y update" >> log
	fi
	yum -y upgrade
	if test $? != 0 ; then
		echo "yum -y upgrade" >> log
	fi
	rpm -Uvh http://mirror.centos.org/centos/6/extras/x86_64/Packages/epel-release-6-8.noarch.rpm
	if test $? != 0 ; then
		echo "rpm -Uvh http://mirror.centos.org/centos/6/extras/x86_64/Packages/epel-release-6-8.noarch.rpm" >> log
	fi
	yum install -y epel-release
	if test $? != 0 ; then
		echo "yum  install -y epel-release" >> log
	fi
	yum install epel -y
	if test $? != 0 ; then
		echo "yum install epel -y" >> log
	fi
	yum install -y libmcrypt libmcrypt-devel mcrypt mhash git
	if test $? != 0 ; then
		echo "yum install -y libmcrypt libmcrypt-devel mcrypt mhash git" >> log
	fi
	yum install sudo -y
	if test $? != 0 ; then
		echo "yum install sudo -y" >> log
	fi
	rpm -Uvh http://mirror.centos.org/centos/6/os/x86_64/Packages/gcc-c++-4.4.7-23.el6.x86_64.rpm
	if test $? != 0 ; then
		echo "rpm -Uvh http://mirror.centos.org/centos/6/os/x86_64/Packages/gcc-c++-4.4.7-23.el6.x86_64.rpm" >> log
	fi
	yum install -y gcc-c++
	if test $? != 0 ; then
		echo "yum install -y gcc-c++" >> log
	fi
	rpm -Uvh http://mirror.centos.org/centos/6/os/x86_64/Packages/make-3.81-23.el6.x86_64.rpm
	if test $? != 0 ; then
		echo "rpm -Uvh http://mirror.centos.org/centos/6/os/x86_64/Packages/make-3.81-23.el6.x86_64.rpm" >> log
	fi
	yum install -y make
	if test $? != 0 ; then
		echo "yum install -y make" >> log
	fi
	yum install wget -y
	if test $? != 0 ; then
		echo "yum install wget -y" >> log
	fi
	yum install unzip -y
	if test $? != 0 ; then
		echo "yum install unzip -y" >> log
	fi
	yum install ntpdate -y
	if test $? != 0 ; then
		echo "yum install ntpdate -y" >> log
	fi
}

#安装LNMP服务
install_LNMP(){
	rpm -Uvh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
	if test $? != 0 ; then
		echo "rpm -Uvh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm" >> log
	fi
	yum -y install nginx
	if test $? != 0 ; then
		echo "yum -y install nginx" >> log
	fi
	rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
	if test $? != 0 ; then
		echo "yum -y install nginx" >> log
	fi
	rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
	if test $? != 0 ; then
		echo "rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm" >> log
	fi
	yum -y install php70w php70w-fpm php70w-mbstring php70w-mysqlnd php70w-mcrypt php70w-gd php70w-imap php70w-ldap php70w-odbc php70w-pear php70w-xml php70w-xmlrpc php70w-pdo php70w-apcu php70w-pecl-redis php70w-pecl-memcached php70w-devel
	if test $? != 0 ; then
		echo "yum -y install php70w php70w-fpm php70w-mbstring php70w-mysqlnd php70w-mcrypt php70w-gd php70w-imap php70w-ldap php70w-odbc php70w-pear php70w-xml php70w-xmlrpc php70w-pdo php70w-apcu php70w-pecl-redis php70w-pecl-memcached php70w-devel" >> log
	fi
	rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm
	if test $? != 0 ; then
		echo "rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el6-9.noarch.rpm" >> log
	fi
	yum install -y mysql-community-server
	if test $? != 0 ; then
		echo "yum install -y mysql-community-server" >> log
	fi

}

#安装redis服务
install_redis(){
	rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
	if test $? != 0 ; then
		echo "rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm" >> log
	fi
	yum install -y redis
	if test $? != 0 ; then
		echo "yum install -y redis" >> log
	fi
	wget https://github.com/nicolasff/phpredis/archive/master.zip
	if test $? != 0 ; then
		echo "wget https://github.com/nicolasff/phpredis/archive/master.zip" >> log
	fi

	unzip master.zip && cd phpredis-master
	if test $? != 0 ; then
		echo "unzip master.zip && cd phpredis-master" >> log
	fi
	phpize
	if test $? != 0 ; then
		echo "phpize" >> log
	fi
	./configure --with-php-config=/usr/bin/php-config
	if test $? != 0 ; then
		echo "./configure --with-php-config=/usr/bin/php-config" >> log
	fi
	make && make install
	if test $? != 0 ; then
		echo "make && make install" >> log
	fi
}

#配置LNMP服务
config_LNMP(){

	echo "sql_mode='NO_ENGINE_SUBSTITUTION'" >> /etc/my.cnf
	echo 'server{
	listen 80 default_server;
	listen [::]:80 default_server;
	root /data/www/mooc_center/public;
	index index.html index.htm index.php;
	server_name mooc.com;
	location / {
		if (!-e $request_filename) {
			rewrite  ^(.*)$  /index.php?s=$1  last;
			break;
		}
	}

	location ~ [^/]\.php(/|$){
		fastcgi_pass  127.0.0.1:9000;
		fastcgi_buffer_size 128k;
		fastcgi_buffers 8 128k;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_param  QUERY_STRING       $query_string;
		fastcgi_param  REQUEST_METHOD     $request_method;
		fastcgi_param  CONTENT_TYPE       $content_type;
		fastcgi_param  CONTENT_LENGTH     $content_length;
		fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
		fastcgi_param  REQUEST_URI        $request_uri;
		fastcgi_param  DOCUMENT_URI       $document_uri;
		fastcgi_param  DOCUMENT_ROOT      $document_root;
		fastcgi_param  SERVER_PROTOCOL    $server_protocol;
		fastcgi_param  REQUEST_SCHEME     $scheme;
		fastcgi_param  HTTPS              $https if_not_empty;
		fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
		fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
		fastcgi_param  REMOTE_ADDR        $remote_addr;
		fastcgi_param  REMOTE_PORT        $remote_port;
		fastcgi_param  SERVER_ADDR        $server_addr;
		fastcgi_param  SERVER_PORT        $server_port;
		fastcgi_param  SERVER_NAME        $server_name;
		fastcgi_param  REDIRECT_STATUS    200;
	}
}' > /etc/nginx/conf.d/mooc_center.conf
echo 'server
{
	listen 80;

	server_name demo-mooc.com;
	index index.php index.html index.htm;
	root  /data/www/chaoxingwhg/public;


	#error_page   404   /404.html;
	#include enable-php.conf;

	fastcgi_connect_timeout 300;
	fastcgi_send_timeout 300;
	fastcgi_read_timeout 300;

	#pc 反向代理
	location = /themes/simpleboot3/mooc-admin {
		proxy_pass http://127.0.0.1:8082/#/login;
	}
	location ^~ /dist/{
		proxy_pass http://127.0.0.1:8082;
	}
	#wx 反向代理
	location = /themes/simpleboot3/mooc-wx {
		proxy_pass http://127.0.0.1:8081/#/index;
	}
	location ^~ /static/img/{
		proxy_pass http://127.0.0.1:8081;
	}
	location ^~ /themes/simpleboot3/static/{
		proxy_pass http://127.0.0.1:8081/static/;
	}
	location ^~ /app.js{
		proxy_pass http://127.0.0.1:8081;
	}

	location /nginx_status
	{
		stub_status on;
		access_log   off;
	}

	location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
	{
		expires      30d;
	}

	location ~ .*\.(js|css)?$
	{
		expires      12h;
	}
	location ~ /\.
	{
		deny all;
	}
	location / {
		if (!-e $request_filename) {
			rewrite  ^(.*)$  /index.php?s=$1  last;
			break;
		}
	}
	location ~ [^/]\.php(/|$)
	{
		try_files $uri =404;
		fastcgi_pass  127.0.0.1:9000;# unix:/tmp/php-cgi.sock;
		fastcgi_buffer_size 128k;
		fastcgi_buffers 32 32k;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
		fastcgi_param  QUERY_STRING       $query_string;
		fastcgi_param  REQUEST_METHOD     $request_method;
		fastcgi_param  CONTENT_TYPE       $content_type;
		fastcgi_param  CONTENT_LENGTH     $content_length;
		fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
		fastcgi_param  REQUEST_URI        $request_uri;
		fastcgi_param  DOCUMENT_URI       $document_uri;
		fastcgi_param  DOCUMENT_ROOT      $document_root;
		fastcgi_param  SERVER_PROTOCOL    $server_protocol;
		fastcgi_param  REQUEST_SCHEME     $scheme;
		fastcgi_param  HTTPS              $https if_not_empty;
		fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
		fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;
		fastcgi_param  REMOTE_ADDR        $remote_addr;
		fastcgi_param  REMOTE_PORT        $remote_port;
		fastcgi_param  SERVER_ADDR        $server_addr;
		fastcgi_param  SERVER_PORT        $server_port;
		fastcgi_param  SERVER_NAME        $server_name;
		fastcgi_param  REDIRECT_STATUS    200;
	}
}' > /etc/nginx/conf.d/demo-mooc.conf
echo 'user nginx;
worker_processes  4;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
	worker_connections  1024;
}


http {

    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Headers X-Requested-With;
    add_header Access-Control-Allow-Methods GET,POST,OPTIONS;

	sendfile on;
	tcp_nopush on;
	tcp_nodelay on;
	client_max_body_size 200m;
	keepalive_timeout 65;
	types_hash_max_size 2048;
	include /etc/nginx/mime.types;
	default_type application/octet-stream;
	access_log  /var/log/nginx/access.log;
	include /etc/nginx/conf.d/*.conf;
}' > /etc/nginx/nginx.conf
sed -i "s/post_max_size = .*M/post_max_size = 200M/g" /etc/php.ini
sed -i "s/upload_max_filesize = .*M/upload_max_filesize = 200M/g" /etc/php.ini
sed -i "s/^.*date\.timezone =.*$/date\.timezone = \"Asia\/Shanghai\"/" /etc/php.ini
sed -i "s/^.*ignore_user_abort.*$/ignore_user_abort = On/" /etc/php.ini
echo 'extension = "redis.so"' >> /etc/php.ini
chown -R mysql:mysql /var/lib/mysql
}

#安装GO服务
install_GO(){
git clone http://chenchen:1q2w3e4r@gitlab.szwhg.chaoxing.com/chenchen/goland.git
mkdir /usr/local/go
cp -r ./goland/go/* /usr/local/go
chmod -R 777 /usr/local/go
echo 'export GOROOT=/usr/local/go
export GOPATH=/usr/local/go
export PATH=$PATH:$GOROOT/bin' >> /etc/profile
source /etc/profile
}

#安装ffmpeg服务
install_ffmpeg(){
wget https://ffmpeg.org/releases/ffmpeg-4.0.2.tar.bz2
if test $? != 0 ; then
	echo "wget https://ffmpeg.org/releases/ffmpeg-4.0.2.tar.bz2" >> log
fi
tar -xvf ffmpeg-4.0.2.tar.bz2 && cd ffmpeg-4.0.2
if test $? != 0 ; then
	echo "tar -xvf ffmpeg-4.0.2.tar.bz2 && cd ffmpeg-4.0.2" >> log
fi

./configure --disable-x86asm
if test $? != 0 ; then
	echo "./configure --disable-x86asm" >> log
fi
make && make install
if test $? != 0 ; then
	echo "make && make install" >> log
fi
}

#安装nodejs服务
install_node(){
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
if test $? != 0 ; then
	echo "curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -" >> log
fi
yum install nodejs -y
if test $? != 0 ; then
	echo "yum install nodejs -y" >> log
fi
}

#部署慕课代码服务
install_code(){
/etc/init.d/nginx restart
/etc/init.d/php-fpm restart
/etc/init.d/mysqld restart
/etc/init.d/redis restart
mkdir /data && mkdir /data/www && cd /data/www
git clone http://chenchen:1q2w3e4r@gitlab.szwhg.chaoxing.com/chaoxing/mooc_center.git
git clone http://chenchen:1q2w3e4r@gitlab.szwhg.chaoxing.com/chaoxing/mooc_admin.git
git clone http://chenchen:1q2w3e4r@gitlab.szwhg.chaoxing.com/jiafan/mooc.git

git clone http://chenchen:1q2w3e4r@gitlab.szwhg.chaoxing.com/chenchen/goland.git
mkdir /usr/local/weeds
cp -r ./goland/weed/* /usr/local/weeds
chmod -R 777 /usr/local/weeds
cp -r ./goland/weeds /data/
mkdir /data/www/chaoxingwhg
cp -r ./mooc/* /data/www/chaoxingwhg
chmod -R 777 /data
dbpass=$(grep 'temporary password' /var/log/mysqld.log |cut -d ":" -f 4,10 | sed 's/^[ \t]*//g')
echo "<?php
return [
// 数据库类型
'type'            => 'mysql',
// 服务器地址
'hostname'        => '127.0.0.1',
// 数据库名
'database'        => 'mooc_center',
// 用户名
'username'        => 'root',
// 密码
'password'        => '${dbpass}',
// 端口
'hostport'        => '',
// 连接dsn
'dsn'             => '',
// 数据库连接参数
'params'          => [],
// 数据库编码默认采用utf8
'charset'         => 'utf8',
// 数据库表前缀
'prefix'          => '',
// 数据库调试模式
'debug'           => true,
// 数据库部署方式:0 集中式(单一服务器),1 分布式(主从服务器)
'deploy'          => 0,
// 数据库读写是否分离 主从式有效
'rw_separate'     => false,
// 读写分离后 主服务器数量
'master_num'      => 1,
// 指定从服务器序号
'slave_no'        => '',
// 是否严格检查字段是否存在
'fields_strict'   => true,
// 数据集返回类型
'resultset_type'  => 'array',
// 自动写入时间戳字段
'auto_timestamp'  => false,
// 时间字段取出后的默认时间格式
'datetime_format' => false,
// 是否需要进行SQL性能分析
'sql_explain'     => false,
];
" > /data/www/mooc_center/application/database.php
echo "<?php
return [
// 数据库类型
'type'     => 'mysql',
// 服务器地址
'hostname' => 'localhost',
// 数据库名
'database' => 'demo-mooc',
// 用户名
'username' => 'root',
// 密码
'password' => '${dbpass}',
// 端口
'hostport' => '3306',
// 数据库编码默认采用utf8
'charset'  => 'utf8mb4',
// 数据库表前缀
'prefix'   => 'cxtj_',
'authcode' => 'HmyDzUUsgsAPtBNUpM',
//#COOKIE_PREFIX#
];" > /data/www/chaoxingwhg/data/conf/database.php
cd /data/www/mooc_admin
echo '{
"presets": ["stage-3", "env"],
"plugins": ["transform-runtime", "syntax-dynamic-import"],
"comments": false
}
' > .babelrc
ipaddr="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
sed -i 's/http\:\/\/.*\:/http\:\/\/'"$ipaddr"'\:/g' /etc/nginx/conf.d/demo-mooc.conf
sed -i 's/--host=.* --/--host='"$ipaddr"' --/g' /data/www/mooc_admin/package.json
sed -i 's/http\:\/\/.*\:/http\:\/\/'"$ipaddr"'\:/g' /data/www/mooc_center/time.php
sed -i 's/http\:\/\/.*\:/http\:\/\/'"$ipaddr"'\:/g' /data/www/mooc_center/application/v1/model/WeedModel.php
npm config set registry "http://r.cnpmjs.org/"
npm install
npm install --save-dev babel-preset-stage-3
npm install --save-dev babel-preset-env
npm install --save-dev babel-plugin-transform-runtime
npm install --save-dev babel-plugin-syntax-dynamic-import
npm install jquery
npm install --save wangeditor@2.1.22
npm audit fix

echo "127.0.0.1	demo-mooc.com
127.0.0.1	mooc.com
" >> /etc/hosts
cat > /etc/rc.local <<EOF
#!/bin/sh
touch /var/lock/subsys/local
/etc/init.d/nginx restart
/etc/init.d/php-fpm restart
/etc/init.d/mysqld restart
/etc/init.d/redis restart
cd /data/www/mooc_admin/ && nohup npm run dev &
cd /data/www/mooc_center && php time.php start -d
ntpdate cn.pool.ntp.org
cd /usr/local/weeds && nohup ./weed -log_dir=/data/weeds/masterData/logs  master -mdir=/data/weeds/masterData/data -port=9333 -whiteList="127.0.0.1,$ipaddr" >> ./server_sfs.log &
cd /usr/local/weeds && nohup ./weed -v 3 -log_dir "/data/weeds/volumeData/logs" volume  -port 9334 -dir "/data/weeds/volumeData/v1" -dataCenter=v1 -whiteList "127.0.0.1,$ipaddr" >>./volume_v1_sfs.log &
EOF
ntpdate cn.pool.ntp.org
yum -y update
if test $? != 0 ; then
	echo "yum -y update" >> log
fi
/etc/init.d/iptables stop
chkconfig iptables off
}

install_needs
install_LNMP
install_redis
config_LNMP
install_GO
install_ffmpeg
install_node
install_code

