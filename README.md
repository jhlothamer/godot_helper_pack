# Godot Helper Pack
This add on is a collection of scripts and classes that offer functionality that is not present in the Godot Engine.

## Singletons
The helper pack comes with a plugin which registers the following singltons into the project.

### Globals
Use Globals to set make data available to every component in your game.

The methods are:

 1. set(property_name, value) - sets a property's value.
 2. get(property_name) - get a property's value.  If the value has never been set, then this will return null.
 3. erase(property_name) - removes a property's value
 4. clear()

### SignalMgr
The SignalMgr singleton automatically connects objects signals when an object is registered as a publisher of a signal or a subscriber.

The methods are:

 1. register_publisher(publisher, signal_name) - registers a publisher object for a signal name.
 2. register_subscriber(subscriber, signal_name, method_name = "", binds=Array()) - registers a subscriber object for a signal


Here's an example component with a signal it want's to pubish.

```
#Foo.gd
signal my_signal()

func _ready():
	SignalMgr.register_publisher(self, "my_signal")
```

And here's a subscriber registering to be connected to the publisher for that signal.

```
#Bar.gd
func _ready():
	SignalMgr.register_subscriber(self, "my_signal", "on_my_signal")

func on_my_signal():
	print("my_signal sent")
```

Now the publisher just emits the signal as usual with emit_signal.

## Core
Core components are those that aren't specifically for UI, 2D or 3D.

### StateMachine and State
The StateMachine class is a state machine implemented using child nodes for states.  The child nodes should all extend the State class, and one of the child's is_starting_state property must be set to true.

The state nodes can override the following methods:

 1. init(state_machine, host) - Do any initialization code in this method being sure to call the base classes init function too.  The state_machine parameter is a reference to the StateMachine node and the host parameter is a reference to the parent node to the StateMachine node.
 2. enter() - This function is called each time the state is activated.  Do any re-set code in this method or anything else that needs done each time the state is entered.
 3. physics_process(delta) - This function is called each frame for the active state.  Note the missing "_" at the beginning of this function.  Do not implement the _physics_process function in your state code.
 4. exit() - This function is called each time the state is existed.
 5. unhandled_input(event) - This method is called on whenever there is an unhandled event for the active state.  Note the missing "_" at the beginning ofthis function.  Do not implement the _uhandled_input(event) in your state code.

Other than these functions, the State class has the following properties:

 1. state_machine - a reference to the state machine node
 2. host - a reference to the state machine node's parent node









