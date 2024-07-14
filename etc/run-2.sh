#!/bin/sh

APP_NAME="be-api"
APP_PATH="/home/jenkins/be-api/main"
PID_FILE="/var/run/$APP_NAME.pid"

start() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE"); then
        echo "$APP_NAME is already running"
        exit 0
    fi
    echo "Starting $APP_NAME..."
    nohup $APP_PATH > /var/log/$APP_NAME.log 2>&1 &
    echo $! > "$PID_FILE"
    echo "$APP_NAME started with PID $(cat $PID_FILE)"
}

stop() {
    if [ ! -f "$PID_FILE" ] || ! kill -0 $(cat "$PID_FILE"); then
        echo "$APP_NAME is not running"
        exit 0
    fi
    echo "Stopping $APP_NAME..."
    kill -TERM $(cat "$PID_FILE")
    rm -f "$PID_FILE"
    echo "$APP_NAME stopped"
}

status() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE"); then
        echo "$APP_NAME is running with PID $(cat $PID_FILE)"
    else
        echo "$APP_NAME is not running"
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}"
        exit 1
esac
