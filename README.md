# Godot Helper Pack
This Godot add-on is a collection of helper scripts and classes. It contains the following:

- **Globals** - a singleton for storing global data
- **SignalMgr**- a singleton for registering signal publishers and subscribers
- **ServiceMgr** - a singleton for registering services
- **Camera behaviors** - nodes that can be added as children of a 2D camera that implement
- - moving
- - zooming
- - shaking
- - limiting
- **Circle2d** - 2D circle shape. Useful for prototyping
- **ShapeDraw2d** - When added as a child to 2D shape node, draws that shape. Useful for prototyping. Handles the following node classes:
- - CollisionShape2D
- - - handles shapes: CircleShape2D, RectangleShape2D, CapsuleShape2D, convexPolygonShape2D, ConcavePolygonShape2D
- - CollisionPolygon2D
- **RandomDistributionArea/RandomDistributionLayer** - used for cloning sub-nodes as children of a target node using Poisson disk sampling. Can handle layering.
- **SoundTrackMgr/SceneSoundTrack** - Have soundtrack music play without interruption in multiple scenes
- **StateMachine/State** - node based state machine
- **Many utility classes**
- - **ArrayUtil** - append all array elements to another array, get random item, etc.
- - **EnumUtil** - Lookup integer values from enumeration string and vice versa, etc.
- - **FileUtil** - load/save text and JSON data without having to write the file code
- - **NodeUtil** - remove all child nodes
- - **PropertyUtil** - test if an object has a property
- - **YieldUtil** - wait on multiple signals - either wait for all for wait for any to be signaled
- - **StatsUtil** - implements linear regression as well as mean and sum
- - **StopWatch** - measure how long something takes in code
- - **StringUtil** - check if string is null or empty, get file name without extension

