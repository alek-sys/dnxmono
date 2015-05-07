FROM ubuntu:vivid

MAINTAINER Alexey Nesterov <alexey.nesterov@live.com>

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36F08F83ADA8FD6F \
	&& echo "deb http://ppa.launchpad.net/inizan-yannick/mono/ubuntu vivid main " > /etc/apt/sources.list.d/mono-ppa.list \
	&& apt-get update \
	&& apt-get install -y curl unzip mono-devel nuget autoconf automake build-essential libtool \
	&& rm -rf /var/lib/apt/lists/*

RUN mozroots --import --sync

RUN LIBUV_VERSION=1.4.2 \
	&& curl -sSL https://github.com/libuv/libuv/archive/v${LIBUV_VERSION}.tar.gz | tar zxfv - -C /usr/local/src \
	&& cd /usr/local/src/libuv-$LIBUV_VERSION \
	&& sh autogen.sh && ./configure && make && make install \
	&& rm -rf /usr/local/src/libuv-$LIBUV_VERSION \
	&& ldconfig

RUN curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh \
	&& bash -c "source $HOME/.dnx/dnvm/dnvm.sh \
	&& dnvm install 1.0.0-beta4 -r mono -a default \
	&& ln -s $HOME/.dnx/runtimes/dnx-mono.1.0.0-beta4 $HOME/.dnx/runtimes/default"

ENV PATH $PATH:/root/.dnx/runtimes/default/bin