# Events service

The events service (defined in [events.proto](../protos/grpc_helper/api/events.proto)) allows to handle a generic events system.


---
## Events

An event is defined with the following attributes:
* **`name`**: an event identifier string (can't contain a space character)
* **`properties`**: a list of **`name`**/**`value`** properties attached to this event


---
## Proxied services events

By convention, proxied managers shall both listen and send events from/to the proxy server. Proxied servers shouldn't be started with the enabled events service.


---
## Service methods


---
### listen

**`rpc listen(Filter) returns (stream EventStatus);`**

#### *Behavior*

Listen to all events matching the provided **`EventFilter`**:
* if the filter is empty, stream all events
* otherwise, only stream all the events exactly matching with the filter names

The **`EventFilter`** message also contains a **`client_id`** field.
When starting to listen to events for the first time, this field shall be unset.
It can be used to resume listening after a previous events listening loop has been interrupted (whatever it is from server or client side).
When a loop is interrupted, event queue is retained for the matching **`client_id`**, giving the capability for the client to resume listening.
The event queue is retained until timeout (configured through **rpc-event-retain-timeout** config item) expired.

#### *Return*

Streams out endlessly all received events from the **`send`** method through **`EventStatus`** messages.
These messages contain a **`client_id`** field that has to be used if at any time the client decides to interrupt or resume the listening process.

**Note 1:** a first status will always be immediately streamed out with an empty event name, to let the client know its **`client_id`** even if no event was received yet.

**Note 2:** any running listening process will be interrupted when the events service is shutdown. In this case this method will return a 
**`ERROR_STREAM_SHUTDOWN`** error code (that may be used be client to resume streaming ASAP)

Otherwise, possible error codes are:
* **`ERROR_PARAM_MISSING`**: at least one of provided filter **`names`** is empty
* **`ERROR_PARAM_INVALID`**: at least one of provided filter **`names`** contains a space character
* **`ERROR_ITEM_UNKNOWN`**: provided **`client_id`** is unknown to the events service.


---
### interrupt

**`rpc interrupt(EventInterrupt) returns (ResultStatus);`**

#### *Behavior*

Interrupt a running events listening process, using its returned **`client_id`**.

#### *Return*

On success, the identified listening process is stopped.

Otherwise, possible error codes are:
* **`ERROR_ITEM_UNKNOWN`**: provided **`client_id`** is unknown to the events service.
* **`ERROR_STATE_UNEXPECTED`**: events queue identified with provided **`client_id`** is already interrupted


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


---
### inspect

**`rpc inspect(Empty) returns (EventQueueStatus);`**

#### *Behavior*

Inspect currently running event queues.

#### *Return*

Returns an **`EventQueueStatus`** message, containing a list of all (retained or running) event queues.
