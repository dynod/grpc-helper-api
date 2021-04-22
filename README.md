# grpc-helper-api

Shared API files for [GRPC helpers](https://github.com/dynod/grpc-helper)

## Common API

The [common.proto](protos/grpc_helper/api/common.proto) file provides reusable API elements for other services (error codes, return status, etc)

## Info API

This API defines an [info service](doc/info.md) that can be used to fetch services/components information.

## Config API

This API defines a [config service](doc/config.md) that handles configuration items.

## Logger API

This API defines a [logger service](doc/logger.md) that handles loggers configuration.

## Proxy API

This API defines a [proxy service](doc/proxy.md) that handles services proxy registration.
