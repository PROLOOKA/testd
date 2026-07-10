#!/bin/bash

# 1. تشغيل سيرفر MediaMTX في الخلفية
echo "Starting MediaMTX Server..."
mediamtx /app/config/mediamtx.yml &

# 2. تشغيل واجهة التحكم (Node.js UI)
echo "Starting MediaMTX Web UI..."
cd /app/server
# Railway يستخدم متغير PORT، سنقوم بتعديل بورت الواجهة ليتناسب معه
export PORT=${PORT:-3000}
node server.js
