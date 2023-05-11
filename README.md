# JetBrains IDE Installation Script

The `install-ide.sh` script will install a JetBrains IDE on the invoking machine.

## Usage

This script takes a single argument. The argument is the IDE Code for a JetBrains IDE. The map from code to IDE is below:

- `IU` -> `IntelliJ IDEA Ultimate`
- `RM` -> `RubyMine`
- `PY` -> `PyCharm Professional Edition`
- `PS` -> `PhpStorm`
- `WS` -> `WebStorm`
- `RD` -> `Rider`
- `GO` -> `GoLand`

### Local

`./install-ide.sh <IDE_CODE>`

### Remotely

_This is intended for users creating their own Docker base images_

`curl -s https://raw.githubusercontent.com/thomas-sickert/ide-install-script/main/install-ide.sh | sh -s RD`

_You may need to run the `sh` command with `sudo`:

`curl -s https://raw.githubusercontent.com/thomas-sickert/ide-install-script/main/install-ide.sh | sudo sh -s RD`

or, in a Dockerfile

`RUN curl -s https://raw.githubusercontent.com/thomas-sickert/ide-install-script/main/install-ide.sh | sh -s RD`





The IDE is installed in `/opt/jetbrains`.
