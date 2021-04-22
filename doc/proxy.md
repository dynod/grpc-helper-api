# Proxy registration service

The proxy service (defined in [proxy.proto](../protos/grpc_helper/api/proxy.proto)) allows to register a set of services.
Once registered, service method calls on the proxy server will be forwarded to the registered server.


---
## list

**`rpc list(Empty) returns (ProxyStatus);`**

#### *Behavior*
List known proxy services to the server, per host/port combinations.


---
## register

**`rpc register (ProxyRegistration) returns (ProxyStatus);`**

#### *Behavior*
Register services (by names) on the proxy server, to be forwarded to the provided port (+ host is provided).

Note that services must be known to the proxy server as to be served as proxy ones.
The proxy server is actually waiting for this register method to be called to know where to forward them.
In the meantime, service calls to these pre-declared services will answer an **`ERROR_PROXY_UNREGISTERED`** error.

#### *Return*

On success, the registration is persisted, and all service calls will be forwarded as configured.
The returned **`ProxyStatus`** message includes all registered proxy services for this host/port combination.

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: if one the provided **`port`** or **`names`** input fields is empty
* **`ERROR_ITEM_UNKNOWN`**: if one of the required services is unknown to the proxy server
