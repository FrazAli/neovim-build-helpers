RELNAME := $(shell lsb_release -cs)


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
	@if [ -z "$(shell groups | grep docker)" ]; then  \
		sudo groupadd -f docker; \
		sudo usermod -aG docker $(USER); \
		echo "User added to the docker group."; \
		echo "Please reboot this machine or login again before using docker."; \
	fi

PHON: docker-build
docker-build:
	@docker build .
