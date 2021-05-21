# Events service

The events service (defined in [events.proto](../protos/grpc_helper/api/events.proto)) allows to handle a generic events system.


---
## Events

An event is defined with the following attributes:
* **`name`**: an event identifier string (can't contain a space character)
* **`properties`**: a list of **`name`**/**`value`** properties attached to this event


---
## Proxied services events

If a server instance registers in a proxy server, this proxy will listen to all of this instance events in order to notify its own listeners.
In other words, the proxied server doesn't have to worry about sending events to other servers that are also registered in the proxy: these ones
just need to listen to the proxy events to get them all.


---
## Service methods


---
### listen

**`rpc listen(Filter) returns (stream EventStatus);`**

#### *Behavior*

Listen to all events matching the provided **`Filter`**:
* if the filter is empty, stream all events
* otherwise, only stream all the events exactly matching with the filter names

#### *Return*

Streams out endlessly all received events from the **`send`** method through **`ItemStatus`** messages.
These messages contain a **`client_id`** the has to be used if at any time the client decides to interrupt the listening process.

**Note:** any running listening process will be interrupted when the events service is shutdown. In this case this method will return a 
**`ERROR_STREAM_SHUTDOWN`** error code (that may be used be client to resume streaming ASAP)

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: at least one of provided filter **`names`** is empty
* **`ERROR_PARAM_INVALID`**: at least one of provided filter **`names`** contains a space character


---
### interrupt

**`rpc interrupt(EventInterrupt) returns (ResultStatus);`**

#### *Behavior*

Interrupt a running events listening process, using its returned **`client_id`**.

#### *Return*

On success, the identified listening process is stopped.

Otherwise, possible error codes are:
* **`ERROR_ITEM_UNKNOWN`**: provided **`client_id`** is unknown to the events service.


---
### send

**`rpc send(Event) returns (ResultStatus);`**

#### *Behavior*

Sends an event to be notified to all currently running listening processes.

#### *Return*

On success, the event is sent.

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: provided **`name`** of event or any event **`properties`** is empty
* **`ERROR_PARAM_INVALID`**: provided **`name`** of event or any event **`properties`** contains a space character
