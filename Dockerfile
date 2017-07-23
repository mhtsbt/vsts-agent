FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y apt-transport-https wget ca-certificates curl software-properties-common git nodejs npm

# install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

RUN apt-get update

# get ubuntu packages
RUN apt-get install -y docker-ce

# install dotnet
RUN sh -c 'echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
RUN apt-get update

RUN apt-get install -y dotnet-dev-1.0.4

# install vsts
RUN mkdir /vsts && cd /vsts

WORKDIR /vsts

RUN wget https://github.com/Microsoft/vsts-agent/releases/download/v2.119.1/vsts-agent-ubuntu.14.04-x64-2.119.1.tar.gz
RUN tar xvf vsts-agent-ubuntu.14.04-x64-2.119.1.tar.gz

RUN useradd vsts

ENV VSTS_ACCOUNT=gozwo
ENV VSTS_POOL=gozwo
ENV VSTS_TOKEN=xxx

RUN wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu52_52.1-3ubuntu0.6_amd64.deb
RUN dpkg -i libicu52_52.1-3ubuntu0.6_amd64.deb

# Accept the TEE EULA
RUN mkdir -p "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && cd "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && echo '<ProductIdData><eula-14.0 value="true"/></ProductIdData>' > "com.microsoft.tfs.client.productid.xml"

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && apt-add-repository ppa:git-core/ppa && apt-get update && apt-get install -y --no-install-recommends curl git jq libcurl3 libicu55 libunwind8 && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install -y --no-install-recommends git-lfs && rm -rf /var/lib/apt/lists/*

COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]