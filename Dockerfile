# استخدام صورة تحتوي على FFmpeg كقاعدة أساسية
FROM linuxserver/ffmpeg:latest

# إعداد المتغيرات لعدم التفاعل أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_VERSION=22

# تثبيت الأدوات الأساسية و Node.js
RUN apt-get update && apt-get install -y git curl make psmisc v4l-utils uvcdynctrl jq && \
    curl -L https://bit.ly/n-install | bash -s -- -y && \
    /root/n/bin/n $NODE_VERSION && \
    ln -s /root/n/bin/node /usr/bin/node && \
    ln -s /root/n/bin/npm /usr/bin/npm

# تثبيت سيرفر MediaMTX (النسخة الأخيرة)
RUN MEDIAMTX_VERSION=$(curl -s https://api.github.com/repos/bluenviron/mediamtx/releases/latest | jq -r .tag_name) && \
    wget https://github.com/bluenviron/mediamtx/releases/download/${MEDIAMTX_VERSION}/mediamtx_${MEDIAMTX_VERSION}_linux_amd64.tar.gz && \
    tar -xzf mediamtx_${MEDIAMTX_VERSION}_linux_amd64.tar.gz -C /usr/local/bin/ && \
    rm mediamtx_${MEDIAMTX_VERSION}_linux_amd64.tar.gz

# تجهيز مجلد العمل وتحميل واجهة التحكم MediaMTX-UI
WORKDIR /app
RUN git clone https://github.com/seekwhencer/mediamtx-ui.git .

# تثبيت مكتبات واجهة التحكم
WORKDIR /app/server
RUN npm install

# العودة للمجلد الرئيسي وتجهيز الإعدادات الافتراضية
WORKDIR /app
RUN cp config/mediamtx.default.yml config/mediamtx.yml || true && \
    cp .env.default .env || true

# كشف المنافذ (Ports)
EXPOSE 3000
EXPOSE 8554
EXPOSE 1935
EXPOSE 8888
EXPOSE 8889

# سكريبت بدء التشغيل
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
