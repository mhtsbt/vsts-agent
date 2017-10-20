FROM ubuntu:17.04

RUN apt-get update
RUN apt-get install -y apt-transport-https wget ca-certificates curl software-properties-common git

# install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"

RUN apt-get update

# get ubuntu packages
RUN apt-get install -y docker-ce

# install dotnet
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-zesty-prod zesty main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-get update
RUN apt-get install -y dotnet-runtime-2.0.0 dotnet-sdk-2.0.0


# install vsts
RUN mkdir /vsts && cd /vsts

WORKDIR /vsts

RUN wget https://github.com/Microsoft/vsts-agent/releases/download/v2.123.0/vsts-agent-ubuntu.16.04-x64-2.123.0.tar.gz
RUN tar xvf vsts-agent-ubuntu.16.04-x64-2.123.0.tar.gz

RUN useradd vsts

ENV VSTS_ACCOUNT=gozwo
ENV VSTS_POOL=gozwo
ENV VSTS_TOKEN=xxx

# Accept the TEE EULA
RUN mkdir -p "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && cd "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && echo '<ProductIdData><eula-14.0 value="true"/></ProductIdData>' > "com.microsoft.tfs.client.productid.xml"

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && apt-add-repository ppa:git-core/ppa && apt-get update && apt-get install -y --no-install-recommends curl git jq libcurl3 libunwind8 && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install -y --no-install-recommends git-lfs && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

RUN wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu55_55.1-7ubuntu0.2_amd64.deb
RUN dpkg -i ./libicu55_55.1-7ubuntu0.2_amd64.deb
RUN rm ./libicu55_55.1-7ubuntu0.2_amd64.deb

COPY ./start.sh .
RUN chmod +x start.sh

CMD bash