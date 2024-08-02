FROM alpine:latest

RUN apk --no-cache add curl

RUN curl -L -o opa https://openpolicyagent.org/downloads/v0.66.0/opa_linux_amd64_static

RUN chmod 755 ./opa

WORKDIR /

COPY . /

RUN chmod 777 opa_test.sh

CMD ["sh", "/opa_test.sh"]