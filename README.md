# mi-core-kumquat-mail

This repository is based on [Joyent mibe](https://github.com/joyent/mibe). Please note this repository should be build with the [mi-core-base](https://github.com/skylime/mi-core-base) mibe image.

## description

This is a minimal version of the awesome standalone webservice / webhosting
services provided by [kumquat](https://github.com/wiedi/kumquat). All services
are disabled the only you could use is the mail function.

## mdata variables

No mdata variable is required. Everything could be automatically generated on
provision state. We recommend a valid `kumquat_ssl` certificate.

- `kumquat_ssl`: ssl certificate for kumquat web interface
- `kumquat_admin`: admin password for kumquat interface
- `core_mail_token`: mail export token from kumquat
- `core_mail_whitelist`: mail whitelist for all accounts

## services

- `22/tcp`: ssh connections
- `80/tcp`: http webserver
- `443/tcp`: https webserver
