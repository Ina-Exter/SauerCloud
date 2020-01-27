FROM debian:latest

WORKDIR /root

RUN /bin/bash -c 'apt-get update; apt-get install awscli default-mysql-client curl unzip -y'
RUN /bin/bash -c 'curl https://releases.hashicorp.com/terraform/0.12.12/terraform_0.12.12_linux_amd64.zip --output terraform.zip; unzip terraform.zip; rm terraform.zip; mv terraform /usr/bin'

