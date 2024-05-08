FROM golang:1.18.2-alpine3.15 AS builder

WORKDIR /app

COPY ./main.go .

RUN go mod init my-app

RUN go get github.com/gofiber/fiber/v2

RUN GOOS=linux GOARCH=amd64 go build -o ./main ./main.go

EXPOSE 3000

CMD ["./main"]
