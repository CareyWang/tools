#/bin/bash

sudo apt update 

mkdir -p /opt/nginx && cd /opt/nginx 

wget http://nginx.org/download/nginx-1.19.1.tar.gz -O nginx-1.19.1.tar.gz
tar zxvf nginx-1.19.1.tar.gz

git clone https://github.com/leev/ngx_http_geoip2_module.git ngx_http_geoip2_module

# 更新 geoip2 database
sudo add-apt-repository ppa:maxmind/ppa -y
sudo apt update 
sudo apt install libmaxminddb0 libmaxminddb-dev mmdb-bin geoipupdate libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev -y
sed -i 's/YOUR_ACCOUNT_ID_HERE/197938/g' /etc/GeoIP.conf
sed -i 's/YOUR_LICENSE_KEY_HERE/1mZlEmCP8obxGdvC/g' /etc/GeoIP.conf
geoipupdate 

# 编译安装 nginx
cd nginx-1.19.1
sudo apt install build-essential libtool libpcre3 libpcre3-dev zlib1g-dev openssl -y 
./configure --add-dynamic-module=/opt/nginx/ngx_http_geoip2_module $(nginx -V) \
    --with-compat \
    --with-http_ssl_module \
    --with-http_dav_module \
    --with-http_v2_module \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx/nginx.pid \
    --lock-path=/var/lock/nginx.lock
make
make install

# 加载 geoip 模块 
# /etc/nginx/nginx.conf events 前添加如下：
# load_module modules/ngx_http_geoip2_module.so;
# 或
# echo 'load_module modules/ngx_http_geoip2_module.so;' > /etc/nginx/modules-available/mod-ngx_http_geoip2.conf
# ln -s /etc/nginx/modules-available/mod-ngx_http_geoip2.conf /etc/nginx/modules-enabled/50-mod-ngx_http_geoip2.conf

# 修改 /etc/nginx/nginx.conf in http section

# geoip2 /usr/share/GeoIP/GeoLite2-Country.mmdb {
#     auto_reload 60m;
#     $geoip2_metadata_country_build metadata build_epoch;
#     $geoip2_data_country_code country iso_code;
#     $geoip2_data_country_name country names en;
# }
# 
# geoip2 /usr/share/GeoIP/GeoLite2-City.mmdb {
#     auto_reload 60m;
#     $geoip2_metadata_city_build metadata build_epoch;
#     $geoip2_data_city_name city names en;
# }
# 
# fastcgi_param COUNTRY_CODE $geoip2_data_country_code;
# fastcgi_param COUNTRY_NAME $geoip2_data_country_name;
# fastcgi_param CITY_NAME    $geoip2_data_city_name;

# 访问黑白名单
# map $geoip2_data_country_code $domain_xyz_allowed_country {
#     default no;
#     CN yes;
#     HK yes;
# }

# server section 添加该代码块
# if ($domain_xyz_allowed_country = no) {
#     return 403;
# }