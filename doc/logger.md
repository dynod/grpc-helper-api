# Logger service

The logger service (defined in [logger.proto](../protos/grpc_helper/api/logger.proto)) allows to handle (get/set/reset) loggers configuration.


---
## Logger configuration

A logger configuration is defined with the following attributes:
* **`name`**: a unique name string identifying the logger.
  *__Note:__* an empty (**`""`**) string identifies the **root** logger (i.e. default level for all loggers)
* **`enabled`**: a boolean flag stating if the logger is enabled (i.e. actively emitting logs) or not
* **`level`**: the enabled level for this logger (e.g. all logs emitted with a level lower than the enabled one will be filtered)


---
## Service methods

---
### get

**`rpc get (Filter) returns (LoggerStatus);`**

#### *Behavior*

Get logger configurations, matching with the names defined in the provided **`Filter`**

#### *Return*

On success, returns the matching list of logger configurations, in a **`LoggerStatus`** message.

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: if the provided **`Filter`** is empty

---
### set

**`rpc set(LoggerUpdate) returns (LoggerStatus);`**

#### *Behavior*

Update logger configurations, according to the provided **`LoggerUpdate`** message.
The operation is atomic and will be applied only if all required updates are valid (i.e. don't raise an error).

The updated configuration is persisted and will be reloaded when the server restarts.

#### *Return*

On success, returns a list of updated logger configurations with their new values, in a **`LoggerStatus`** message.

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: if the **`LoggerUpdate`** message list is empty

---
### reset

**`rpc reset (Filter) returns (LoggerStatus);`**

#### *Behavior*

Reset logger configurations to their default values, according to the provided **`Filter`**

The updated configuration is persisted and will be reloaded when the server restarts.

#### *Return*

On success, returns the list of logger configurations that have been reset to their default values, in a **`LoggerStatus`** message.

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: if the **`Filter`** message list is empty
