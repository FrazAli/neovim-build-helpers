RELNAME := $(shell lsb_release -cs)
WORKDIR := /tmp


.PHONY:
all: docker-setup docker-build
	@echo "All done!"

.PHONY: nerdfont-install
nerdfont-install:
	@mkdir -p $(HOME)/.local/share/fonts
	@sudo apt-get update
	@sudo apt-get install fonts-hack-ttf curl wget
	@cd ~/.local/share/fonts && \
		curl -fLo /tmp/Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip && \
		unzip /tmp/Hack.zip -d $(HOME)/.local/share/fonts/

.PHONY: neovim-prereqs
neovim-prereqs:
	@sudo apt-get update
	@sudo apt-get install --yes \
		ninja-build \
		gettext libtool \
		libtool-bin \
		autoconf \
		automake \
		cmake \
		g++ \
		pkg-config \
		unzip \
		curl \
		git

.PHONY: neovim-fetch
neovim-fetch:
	@cd ${WORKDIR} && git clone https://github.com/neovim/neovim || echo "'neovim' directory alreaydy exists, skipping 'git clone'"

.PHONY: neovim-build
neovim-build: neovim-fetch
	@cd ${WORKDIR}/neovim \
		&& git checkout stable \
		&& CMAKE_BUILD_TYPE=RelWithDebInfo make -j4

.PHONY: neovim-install
neovim-install: neovim-build
	@cd ${WORKDIR}/neovim \
		&& sudo make install


.PHONY: docker-prereqs
docker-prereqs:
	@sudo apt update
	@sudo apt-get install --yes \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		lsb-release

.PHONY: docker-repo
docker-repo: docker-prereqs
	@curl -fsSL https://download.docker.com/linux/debian/gpg | \
		sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	@echo \
		"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
		${RELNAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

.PHONY: docker-setup
docker-setup: docker-repo
	@sudo apt update
	@sudo apt install docker-ce docker-ce-cli containerd.io
	@if [ -z "$(shell groups | grep docker)" ]; then  \
		sudo groupadd -f docker; \
		sudo usermod -aG docker $(USER); \
		echo "User added to the docker group."; \
		echo "Please reboot this machine or login again before using docker."; \
	fi

PHON: docker-build
docker-build:
	@docker build -t docker-neovim .
