#!/bin/bash

# 安装更新 yt-dlp
## python -m pip install -U --pre "yt-dlp[default]"

# 创建虚拟环境
## yt-dlp 与 whisper python版本不一致，ytdlp python 版本3.10，whisper python 3.90
## "/C/Users/huhaq/AppData/Local/Programs/Python/Python310/python.exe" -m venv venv310
## "/C/Users/huhaq/AppData/Local/Programs/Python/Python39/python.exe" -m venv venv39

for url in $(cat urls.txt); do
	source /d/venv/venv310/Scripts/activate
	
	echo "开始下载 $url"
	DATE_TAG=$(date +%Y%m%d)
	TIME_TAG=$(date +%H.%M.%S)
	SAVE_DIR="/d/桌面/youtube/${DATE_TAG}/${TIME_TAG}"
	EXT_NAME=$("/d/venv/venv310/Scripts/yt-dlp" --proxy "socks5://127.0.0.1:1080" --get-filename -o "%(ext)s" "$url" </dev/null)
	VIDEO_NAME=${TIME_TAG}.${EXT_NAME}
	
	mkdir -pv ${SAVE_DIR}
	cd ${SAVE_DIR}
	
	"/d/venv/venv310/Scripts/yt-dlp" \
		--proxy "socks5://127.0.0.1:1080" \
		--format "bestvideo+bestaudio/best" "$url" \
		-o "${VIDEO_NAME}" </dev/null

	ffmpeg -i "${VIDEO_NAME}" -vn -c:a pcm_s16le "${TIME_TAG}.wav"
	
	source /d/venv/venv39/Scripts/activate
	# model: base small medium
	whisper "${TIME_TAG}.wav" --language Chinese --model small --fp16 False --output_format srt
	
	rm -f "${TIME_TAG}.wav"
done < "urls.txt"
