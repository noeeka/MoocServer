#ipaddr=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
ipaddr="$(ifconfig | grep -A 1 'eth0' | tail -1 | cut -d ':' -f 2 | cut -d ' ' -f 1)"
sed -i 's/http\:\/\/.*\:/http\:\/\/'"$ipaddr"'\:/g' /etc/nginx/conf.d/demo-mooc.conf
sed -i 's/--host=.* --/--host='"$ipaddr"' --/g' /data/www/mooc_admin/package.json
sed -i 's/http\:\/\/.*\:/http\:\/\/'"$ipaddr"'\:/g' /data/www/mooc_center/time.php
