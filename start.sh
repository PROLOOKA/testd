#!/bin/bash

# بدء خدمة MariaDB
service mysql start

# بدء خدمة PHP-FPM
service php7.4-fpm start || service php8.1-fpm start || service php-fpm start

# بدء خدمة Nginx
service nginx start

# بدء خدمات Xtream UI
if [ -d "/home/xtreamcodes/iptv_xtream_codes" ]; then
    /home/xtreamcodes/iptv_xtream_codes/start_services.sh
fi

# إبقاء الحاوية قيد التشغيل
tail -f /dev/null
