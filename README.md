# Containerized Development Environment

This Python development environment is containerized & configured to run in VS Code. Once set up, the extensions and environment dependencies are stored as configuration files within the repository, making sharing and building atop simple and straightforward.

## Setup Instructions

1. Install [Docker](https://docs.docker.com/desktop/install/mac-install/)
2. Install [Remote Development VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
3. in Command Pallet (⌘ + ⇧ + P) type/select "Reopen in container"
4. Run & Develop with the VS Code Debugger, launch script included!
5. Develop something!

## Tour

This environment is meant as a blueprint; as such I'll detail below the important pieces of the setup.

### `requirements.txt`

Similar to a package.json, this file describes the environment dependencies the repository depends on. There are several python utilities that use this format: `pip` is the package manager that ships with python, `conda` and `venv` both generate virtualized environments using `requirements.txt` as an input. The `pip` way of generating this file is `pip freeze > requirements.txt` while using this file with pip is achieved via `pip install -r requirements.txt`.

#### Details

- `<package_name>==<version_number>` -- Simple file format: 1 package per line, as described

#### Links
- [requirements.txt explained](https://www.freecodecamp.org/news/python-requirementstxt-explained/)

### `Dockerfile`

Describes the "image" that will be generated to run the application with all the requirements.

#### Details
- `FROM python:3.12-slim-bookworm` -- start with a slim linux distribution (all containers are linux internally) w/ python 3.12 pre-installed. Docker Hub lists available images: [python official](https://hub.docker.com/_/python/)
- `WORKDIR /usr/src/app` -- set's the default director for subsequent commands
- `COPY ./requirements.txt /usr/src/app/` -- copies files from the host machine (local) into the docker container
- `RUN ["pip", "install", "-r", "requirements.txt"]` -- Run will run the arguments on the internal command line: this installs all files listed in `requiremnts.txt`
- `CMD ["flask", "--app", "src/hello.py", "--debug", "run"]` -- CMD is like run, but is expected to be the main command for the container. Once the "image" is "built" this will be what is run inside the container when you call `docker run <my-container>`

#### Links

- [Dockerfile reference](https://docs.docker.com/engine/reference/builder)

### `devcontainer.json`

This file contains the configuration for the portable Dockerized development environment. Importantly, it does not execute the CMD in the Dockerfile above

#### Details

- `build.dockerfile` -- Docker configuration file to build the development environment: relative from variable `"${localWorkspaceFolder}/Dockerfile.develop"`
- `build.context` -- Folder the Docker configuration file should treat as its context: variable `${localWorkspaceFolder}`
- `workspaceFolder` -- the folder within the docker computer to be used when logging in: `"/usr/src/app"`,
- `workspaceMount` -- mount the source directory into the container such that editing within the container updates the same host file, think of them as shared: `"type=bind,source=${localWorkspaceFolder},target=/usr/src/app"`,
    - `type=bind` -- either `bind` or `volume`, but `bind` is preferable here because we may edit the same files outside of the container.
    - `source=${localWorkspaceFolder}` -- the source folder to mount into
    - `target=/usr/src/app` --
- `customizations.vscode.extensions` -- VS Code extensions to be installed as the development environment is built:

#### Links
- [Reference `devcontainer.json`](https://containers.dev/implementors/json_reference/)
- [Dev Containers tutorial](https://code.visualstudio.com/docs/devcontainers/tutorial)

### `.vscode/settings.json`

This file configures VS Code for the workspace.
The settings in this file would overwrite the global settings you may already have configured.
Within the container environment many of your local configurations for VS Code will be lost, so a portable and embedded version is ideal in this context.

#### Details

- `[python]` -- applies the contained settings only to python language files.
- `[python].editor.defaultFormatter` -- There likely won't be a formatter installed inside the container so we must install it (in `devcontainer.json`) and then set it as the default formatter. : `"ms-python.autopep8"`
