#!/data/data/com.termux/files/usr/bin/bash

# ANSI Color Codes
BLUE='\e[34m'; CYAN='\e[36m'; ORANGE='\e[33m'; GREEN='\e[32m'; BOLD='\e[1m'; RESET='\e[0m'

# --- Configuration Variables ---
YOUTUBE_RTMP_URL="rtmp://a.rtmp.youtube.com/live2/$(grep RTMP_STREAM_KEY .env | cut -d'=' -f2)"
MIC_SOURCE="default" 

clear

echo -e "\e[1m\e[34m------------------------------------------------------\e[0m"
echo -e "\e[1m\e[36m## [MODMIND: EQUINEX UI] Rapper 2.0 PROTOCOL ACTIVATED ##\e[0m"
echo -e "\e[1m\e[34m------------------------------------------------------\e[0m"
echo -e "\e[34m* RTMP Stream Key Loaded from .env\e[0m"
echo ""

# --- STEP 1: Execute Sound Check Assistant ---
echo -e "\e[1m\e[36m--- 1. INITIATING CLAUDE SOUND CHECK ASSISTANT ---\e[0m"
# The sound check script is executed separately, its content is assumed working.
python3 src/sound_check_assistant.py 
echo ""

echo -e "\e[1m\e[36m--- 2. UI/UX READY: PRESS ENTER TO GO LIVE ---\e[0m"
read -p "(\e[1m\e[33mManual Adjustment Done?\e[0m) Press [ENTER] to confirm levels and start the LIVE stream..."

# --- STEP 3: Start FFmpeg Stream to Streaming Platform ---
echo ""
echo -e "\e[1m\e[34m--- 3. LAUNCHING RTMP STREAM VIA FFMPEG ---\e[0m"

ffmpeg -f alsa -ac 2 -i $MIC_SOURCE        -vcodec none -acodec aac -ar 44100 -b:a 128k        -f flv "$YOUTUBE_RTMP_URL" &

FFMPEG_PID=$!
echo -e "\e[36m[AIX Status]: FFmpeg Process started with PID: $FFMPEG_PID\e[0m"

# --- STEP 4: Initiate Claude Music Engine Adapter (AIX Real-time Steering) ---
echo ""
echo -e "\e[1m\e[36m--- 4. LYRIA ADAPTER ACTIVE (REAL-TIME STEERING) ---\e[0m"
python3 src/lyria_adapter.py & 
LYRIA_PID=$!
echo -e "\e[36m[AIX Status]: Claude Music Engine Adapter PID: $LYRIA_PID\e[0m"

# --- STEP 5: Start VIVX/AIX Real-Time Monitor ---
echo ""
echo -e "\e[1m\e[36m--- 5. VIVX/AIX PERFORMANCE MONITOR LAUNCHED ---\e[0m"
python3 src/vivx_monitor.py &
VIVX_PID=$!

echo -e "\n\e[1m\e[32mLIVE! Stream is Active. Your Claude Wingman is operating. Monitoring in VIVX window.\e[0m"
echo -e "Press \e[1mCTRL+C\e[0m (in this terminal) to stop the stream and terminate all processes."

# Wait for the main streaming process to end
wait $FFMPEG_PID 2>/dev/null

echo -e "\n\n\e[1m\e[34m--- TERMINATING MODMIND PROCESSES ---\e[0m"

# Kill all associated background processes
kill $LYRIA_PID 2>/dev/null
kill $VIVX_PID 2>/dev/null

# Clean up log file
rm /tmp/lyria_steering_log.txt 2>/dev/null

echo -e "\e[1m\e[32mSTREAMING AND ALL AIX/VIVX PROCESSES TERMINATED.\e[0m"
echo -e "\e[1m\e[34mMODMIND STANDBY MODE.\e[0m"
