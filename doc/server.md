# Server handling service

The server handling service (defined in [server.proto](../protos/grpc_helper/api/server.proto)) allows to fetch information about available services for 
the serving RPC server, and more generally to control the server behavior.


---
### info

**`rpc info (Filter) returns (MultiServiceInfo);`**

#### *Behavior*
List known available services information, according to the provided **`Filter`**:
* if the filter is empty, return all information items
* otherwise, return all the items exactly matching with the filter names

#### *Return*
On success, a **`MultiServiceInfo`** message is returned, including information for each available service (or specified ones if **`Filter`** request is non-empty):
* "module.service" name and version
* current and supported API version
* additional information if the service is a proxied one

Proxied services are services for which all method calls are forwarded to another RPC server.

Otherwise, possible error codes are:
* **`ERROR_ITEM_UNKNOWN`**: if at least one of the filter names doesn't match with a known service item.


---
### shutdown

**`rpc shutdown (ShutdownRequest) returns (Result)`**

#### *Behavior*
This method will trigger an RPC server graceful shutdown (terminating all pending calls). Then behavior depends on the provided **`timeout`** field:
* if <0: the RPC server will shutdown immediately without waiting (may be usefull to restart immediately the server)
* if =0: the RPC server will wait for delay configured in **rpc-shutdown-timeout** configuration item, then shutdown
* if >0: the RPC server will wait for provided delay (in seconds), then shutdown

#### *Return*
The method always succeeds.


---
### proxy_register

**`rpc proxy_register (ProxyRegisterRequest) returns (Result);`**

#### *Behavior*
Register services (by names) on the proxy server, to be forwarded to the provided port (+ host is provided).

Note that services must be known to the proxy server as to be served as proxy ones.
The proxy server is actually waiting for this register method to be called to know where to forward them.
In the meantime, service calls to these pre-declared services will answer an **`ERROR_PROXY_UNREGISTERED`** error.

#### *Return*

On success, the registration is persisted, and all service calls will be forwarded as configured.

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: if one the provided **`port`**, **`version`** or **`names`** input fields is empty
* **`ERROR_ITEM_UNKNOWN`**: if any of the required services is unknown to the proxy server
* **`ERROR_PARAM_INVALID`**: if any of the required services is not a proxy one


---
### proxy_forget

**`rpc proxy_forget (Filter) returns (Result);`**

#### *Behavior*
Remove services registration (by names) from the proxy server..

#### *Return*

On success, the registration is removed, and all service calls won't be forwarded anymore.

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: if one the provided **`names`** input field is empty
* **`ERROR_ITEM_UNKNOWN`**: if any of the required services is unknown to the proxy server
* **`ERROR_PARAM_INVALID`**: if any of the required services is not a proxy one
