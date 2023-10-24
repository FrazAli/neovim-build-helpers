FROM node:16.10.0-buster

RUN apt-get update \
	&& apt-get install --yes ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl git 

RUN git clone https://github.com/neovim/neovim

RUN cd neovim \
	&& git checkout stable \
	&& make -j4 \
	&& make install

WORKDIR /tmp

COPY setup-coc /tmp/

RUN /tmp/setup-coc

ENTRYPOINT ["nvim"]
