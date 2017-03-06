FROM ubuntu:14.04
MAINTAINER mpneuried

RUN sudo apt-get -y update
RUN sudo apt-get -y install -f build-essential wget curl

RUN wget -c -O- http://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -

RUN echo "deb http://packages.erlang-solutions.com/ubuntu trusty contrib" | sudo tee -a /etc/apt/sources.list.d/erlang_solutions.list > /dev/null
RUN sudo apt-get update

RUN apt-get -f -y install erlang

RUN erl -eval 'erlang:display(erlang:system_info(otp_release)), halt().'  -noshell

# INSTALL ELIXIR
# lend by https://github.com/c0b/docker-elixir/blob/master/1.3/Dockerfile

# elixir expects utf8.
ENV ELIXIR_VERSION="v1.4.2" \
	LANG=C.UTF-8

RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip" \
	&& ELIXIR_DOWNLOAD_SHA256="3ff610166612db10d3f97895972882a6912e99628e31116d22406389c1de48cc"\
	&& buildDeps=' \
		unzip \
	' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL -o elixir-precompiled.zip $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256 elixir-precompiled.zip" | sha256sum -c - \
	&& unzip -d /usr/local elixir-precompiled.zip \
	&& rm elixir-precompiled.zip \
	&& apt-get purge -y --auto-remove $buildDeps \
&& rm -rf /var/lib/apt/lists/*

RUN elixir -v

ENV PATH $PATH:/opt/elixir-${ELIXIR_V}/bin

RUN mix local.hex --force
RUN mix local.rebar --force
