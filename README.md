"# test-goland-api-jenkin" 

HW-001 run script:
[run in wsl]

// copy docker
cp -r /mnt/h/work/iam/jenkin-course/01-simple-docker-helloworld-api/* /home/tserver/jenkin-course/docker-golang-api

// build docker file
docker build -t hello-world-api:latest .

// run docker
docker run -d hello-world-api



HW-LAST:

-- be-bank container

// create container 
docker run -d \
  --name=be-bank \
  --hostname=openssh-server `#optional` \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e SUDO_ACCESS=false `#optional` \
  -e PASSWORD_ACCESS=true `#optional` \
  -e USER_PASSWORD=P@ssw0rd `#optional` \
  -e USER_NAME=jenkins `#optional` \
  -e LOG_STDOUT= `#optional` \
  -p 2224:2222 \
  -p 3001:3000 \
  --restart unless-stopped \
  lscr.io/linuxserver/openssh-server:latest

// add ssh key for files transfering
ssh-copy-id  -p 2224 -i /home/ruchapol/.ssh/id_rsa jenkins@localhost

// test shelling to be-bank container
ssh jenkins@localhost -p 2224 -i /home/ruchapol/.ssh/id_rsa

// add known host for jenkins
ssh-keyscan -H localhost -p 2224 >> /var/lib/jenkins/.ssh/known_hosts

// make folder to run a project [at be-api container]
mkdir -p /home/jenkins/be-api
chown -R jenkins:jenkins /home/jenkins

// make own be-api service
write to "/home/jenkins/be-api/run-2.sh":

```
#!/bin/sh

APP_NAME="be-api"
APP_PATH="/home/jenkins/be-api/main"
PID_FILE="/var/run/$APP_NAME.pid"

start() {
    if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE"); then
        echo "$APP_NAME is already running"
        exit 1
    fi
    echo "Starting $APP_NAME..."
    nohup $APP_PATH > /var/log/$APP_NAME.log 2>&1 &
    echo $! > "$PID_FILE"
    echo "$APP_NAME started with PID $(cat $PID_FILE)"
}

stop() {
    if [ ! -f "$PID_FILE" ] || ! kill -0 $(cat "$PID_FILE"); then
        echo "$APP_NAME is not running"
        exit 1
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

```

chmod +x /home/jenkins/be-api/run-2.sh
chown -R jenkins:jenkins /home/jenkins/be-api/run-2.sh

// create log/pid files
touch /var/run/be-api.pid
chown jenkins:jenkins /var/run/be-api.pid

touch /var/log/be-api.log
chown jenkins:jenkins /var/log/be-api.log

// run/start/stop service
/home/jenkins/be-api/run-2.sh [start|stop|status|restart]

// test server 
curl localhost:3000