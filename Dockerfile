FROM ubuntu:20.04

LABEL maintainer="Manus AI"

ENV DEBIAN_FRONTEND=noninteractive

# تحديث النظام وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    wget curl git dnsutils net-tools tzdata mariadb-client mariadb-server \
    nginx php-fpm php-cli php-mysql php-curl php-json php-gd php-mbstring php-xml php-zip php-soap php-opcache \
    libxslt1-dev libcurl4-openssl-dev libgeoip-dev python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# تحميل سكريبت تثبيت Xtream UI
RUN wget -O /tmp/install.sh https://raw.githubusercontent.com/amidevous/xtream-ui-ubuntu20.04/master/install.sh && \
    chmod +x /tmp/install.sh

# تنفيذ سكريبت التثبيت بصمت مع تحديد المنافذ والبيانات الأساسية
# المنافذ: Admin Port (25500), Client Port (80), Apache Port (8080)
RUN /tmp/install.sh -a admin -t Europe/Paris -p admin -o 25500 -c 80 -r 8080 -e admin@example.com -m xtreamuipassword -s yes

# كشف المنافذ المطلوبة
EXPOSE 80
EXPOSE 1935
EXPOSE 1936
EXPOSE 6000/udp
EXPOSE 25500
EXPOSE 8080

ENV PORT=80

# سكريبت بدء التشغيل
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
