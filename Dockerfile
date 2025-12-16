FROM python:3.10.8-slim-buster
WORKDIR /app

# Forces Python to print logs immediately
ENV PYTHONUNBUFFERED=1

# --- NEW: Install System Dependencies (Aria2, FFmpeg, Zip) ---
RUN apt-get update && apt-get install -y \
    aria2 \
    ffmpeg \
    zip \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .

# Ensure Aria2 runs in the background (Daemon mode) before starting the bot
# We use a shell command to start aria2c first, then python
CMD aria2c --enable-rpc --rpc-listen-all=false --daemon && python3 restrict_bot.py
