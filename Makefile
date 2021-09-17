

RELNAME := $(shell lsb_release -cs)
#PWD := $(shell pwd)


.PHONY: 
all: docker-setup docker-build
	@echo "All done!"

.PHONY: docker-prereqs
docker-prereqs:
	@sudo apt update
	@sudo apt-get install \
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

.PHONY: docker-install
docker-setup: docker-repo
	@sudo apt update
	@sudo apt install docker-ce docker-ce-cli containerd.io
	sudo groupadd -f docker
	[ -z "$(groups | grep docker)" ] && \
		sudo usermod -aG docker $(USER); \
		echo "User added to the docker group."; \
		echo "Please login again before using docker."; \
		exec sudo su -l $(USER)

PHON: docker-build
docker-build:
	@docker build .
