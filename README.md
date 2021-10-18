# neovim configuration and setup inside a docker container (WIP)

The aim of the project is to setup a docker container that handles the build and configuration of neovim.

The motivation is that one should be able to setup and deploy neovim on a new machine without having to go through the build and config. process each time.

## Usage:

```
docker run --rm -it docker-neovim:latest <filename>
```
