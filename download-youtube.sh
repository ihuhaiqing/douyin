#!/bin/bash

DATE_DIR=$(date +%Y%m%d)
TIME_HM=$(date +%H%M)
RESOURCE_DIR="/c/Users/haiqi/Desktop/douyin/${DATE_DIR}/Resource"
Product_DIR="/c/Users/haiqi/Desktop/douyin/${DATE_DIR}/Product"
V_FILENAME=$(yt-dlp --proxy socks5://127.0.0.1:1080/ --get-filename --output "${TIME_HM}.%(ext)s" $1)
R_FILENAME=${TIME_HM}.wav

mkdir -pv $RESOURCE_DIR $Product_DIR

cd $RESOURCE_DIR

yt-dlp --format "bestvideo+bestaudio" --output "$V_FILENAME"  --proxy socks5://127.0.0.1:1080/ $1

ffmpeg -i ${V_FILENAME} -ac 1 -ar 16000 ${R_FILENAME}

/c/whisper/bin/main.exe --model /c/whisper/models/ggml-base.bin --translate --output-srt --file ${R_FILENAME}