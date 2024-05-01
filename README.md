"# test-goland-api-jenkin" 

HW-001 run script:
[run in wsl]

// copy docker
cp -r /mnt/h/work/iam/jenkin-course/01-simple-docker-helloworld-api/* /home/tserver/jenkin-course/docker-golang-api

// build docker file
docker build -t hello-world-api:latest .

// run docker
docker run -d hello-world-api
