FROM mono:latest

MAINTAINER Alexey Nesterov <alexey.nesterov@live.com>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sh \
	&& source ~/.dnx/dnvm/dnvm.sh \
	&& dnvm upgrade