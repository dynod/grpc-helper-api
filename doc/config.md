# Config service

The config service (defined in [config.proto](../protos/grpc_helper_api/config.proto)) allows to handle (get/set/reset) configuration items.


---
## Configuration items

A configuration item is defined with the following attributes:
* **`name`**: a unique item identifier string matching with the **`"[a-z][a-z0-9-]*"`** pattern
* **`description`**: a free string providing a one-line description of the item
* **`value`**: the current value of the item
* **`default_value`**: the default value of the item
* **`can_be_empty`**: a boolean flag stating if this configuration item can be empty
* **`validator`**: identifier of the built-in validator used for this configuration item


---
## Built-in validators

Configuration items can be validated by one of the following validators:
* **`CONFIG_VALID_STRING`**: any string
* **`CONFIG_VALID_CUSTOM`**: service-defined validation method
* **`CONFIG_VALID_INT`**: any integer
* **`CONFIG_VALID_POS_INT`**: only strictly positive integer


---
## Proxied services config

If a server instance is handling proxied services, all config service operations will be propagated to the proxied servers.
Behavior depend on used methods:
* **`set`**/**`reset`** methods will apply the value to all servers knowing required config items
* **`get`** method will success only if the got value is homogenous among all the proxied servers


---
## Service methods

---
### get

**`rpc get (Filter) returns (ConfigStatus);`**

#### *Behavior*

Get configuration items, according to the provided **`Filter`**:
* if the filter is empty, return all configuration items
* otherwise, return all the items exactly matching with the filter names

#### *Return*

On success, returns the matching list of configuration items with their current value, in a **`ConfigStatus`** message.

Otherwise, possible error codes are:
* **`ERROR_ITEM_UNKNOWN`**: if at least one of the filter names doesn't match with a known configuration item (and filter **`ignore_unknown`** field is **`false`**).
* **`ERROR_ITEM_CONFLICT`**: if current value is not the same among the different proxied servers (if proxy services are registered)

---
### set

**`rpc set(ConfigUpdate) returns (ConfigStatus);`**

#### *Behavior*

Update configuration items, according to the provided **`ConfigUpdate`** message (holding a list of **`name`** + **`value`** strings).
The operation is atomic and will be applied only if all required updates are valid (i.e. don't raise an error).

The updated configuration is persisted and will be reloaded when the server restarts.

**Note:** if proxy services are registered, config is updated on all proxied servers knowing the updated item(s)

#### *Return*

On success, returns a list of updated configuration items with their new values, in a **`ConfigStatus`** message.

Otherwise, possible error codes are:
* **`ERROR_ITEM_UNKNOWN`**: if at least one of the required item names doesn't match with a known configuration item (and request **`ignore_unknown`** field is **`false`**).
* **`ERROR_PARAM_MISSING`**: if
  * either the **`ConfigUpdate`** message list is empty
  * or one of the updated item name is empty
* **`ERROR_PARAM_INVALID`**: if
  * either one of the updated item value is not set, while the item can't be empty
  * or the one of the updated item value is considered as invalid by the item validator

---
### reset

**`rpc reset (Filter) returns (ConfigStatus);`**

#### *Behavior*

Reset configuration items to their default values, according to the provided **`Filter`**

The updated configuration is persisted and will be reloaded when the server restarts.

**Note:** if proxy services are registered, config is reset on all proxied servers knowing the impacted item(s)

#### *Return*

On success, returns the list of configuration items that have been reset to their default values, in a **`ConfigStatus`** message.

Otherwise, possible error codes are:
* **`ERROR_ITEM_UNKNOWN`**: if at least one of the filter names doesn't match with a known configuration item (and filter **`ignore_unknown`** field is **`false`**).
* **`ERROR_PARAM_MISSING`**: if the **`Filter`** message list is empty
