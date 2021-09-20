#FROM debian:buster
FROM node:14.17.3-buster

RUN apt-get update \
	&& apt-get install --yes ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl git 

RUN git clone https://github.com/neovim/neovim

RUN cd neovim \
	&& git checkout stable \
	&& make -j4 \
	&& make install

# vRUN curl -sL install-node.now.sh | sh

# RUN curl --compressed -o- -L https://yarnpkg.com/install.sh | bash

WORKDIR /tmp

COPY setup-coc /tmp/

RUN /tmp/setup-coc

ENTRYPOINT ["nvim"]
