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
  -p 3001:3001 \
  --restart unless-stopped \
  lscr.io/linuxserver/openssh-server:latest

// add ssh key for files transfering
ssh-copy-id  -p 2224 -i /home/ruchapol/.ssh/id_rsa jenkins@localhost

// test shelling to be-bank container
ssh jenkins@localhost -p 2224 -i /home/ruchapol/.ssh/id_rsa

// make folder to run a project
mkdir -P /home/jenkins/be-api
chown -R jenkins:jenkins /home/jenkins

// set up openrc to manage service 
// [on be-bank container]
apk update
apk add openrc
rc-status --list
rc-service --list

// add service file 
mkdir -p /etc/init.d

write down to "/etc/init.d/be-api":
```
#!/sbin/openrc-run
name="be-api"

command="/home/jenkins/be-api/main"
command_args=""
pidfile="/var/run/be-api.pid"
command_background="true"

depend() {
    need localmount netmount
    use net
}

---
#!/sbin/openrc-run

name="be-api"
command="/home/jenkins/be-api/main"
command_args=""
pidfile="/var/run/be-api.pid"
command_background=true
output_log="/var/log/be-api.log"
error_log="/var/log/be-api-error.log"

depend() {
    need localmount
    use net
}

start_pre() {
    touch "$output_log" "$error_log"
}

start() {
    ebegin "Starting $name"
    start-stop-daemon --start --exec $command -- $command_args >> "$output_log" 2>> "$error_log"
    eend $?
}

stop() {
    ebegin "Stopping $name"
    start-stop-daemon --stop --exec $command
    eend $?
}


```

chmod +x /etc/init.d/be-api

write down to "/home/jenkins/be-api/run.sh":
```
#!/bin/sh

/etc/init.d/be-api start
tail -f /dev/null
```

chmod +x /home/jenkins/be-api/run.sh

// start/stop service
rc-status be-api start
rc-status be-api stop

/etc/init.d/be-api start
/etc/init.d/be-api stop
