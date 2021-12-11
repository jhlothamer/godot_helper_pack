# Godot Helper Pack
This Godot Engine add-on is a collection of helper scripts and classes.  Please see below for a list of classes and utilities for details.


## How to Install
1. Download the project zip file and unzip it.
2. Copy the folder godot_helper_pack\helper_pack_project\addons\godot_helper_pack into the addons folder of your Godot project
3. Go to the Plugins tab in the Project Settings of your Godot project and enable the GodotHelperPack plugin.

Now all of the classes and utilities will be available for use.  Also, after enabling the plugin 3 Autoload Singletons will be registered under the Autoload tab in Project Settings.  These are Globals, SignalMgr and ServiceMgr.  Please see their description of these services below.


## Classes and Utilities

The Godot Helper Pack contains the following:

- **Globals** - a singleton for storing global data
- **SignalMgr**- a singleton for registering signal publishers and subscribers
- **ServiceMgr** - a singleton for registering services
- **Camera behaviors** - nodes that can be added as children of a 2D camera that implement
- - moving
- - zooming
- - shaking
- - limiting
- **Circle2D** - 2D circle shape. Useful for prototyping
- **ShapeDraw2D** - When added as a child to 2D collision node, draws that shape. Useful for prototyping. Handles the following node classes:
- - CollisionShape2D (including all allowed shapes)
- - CollisionPolygon2D
- **RandomDistributionArea/RandomDistributionLayer** - used for cloning sub-nodes as children of a target node using Poisson disk sampling. Can handle layering.
- **SoundTrackMgr/SceneSoundTrack** - Have soundtrack music play without interruption in multiple scenes
- **StateMachine/State** - node based state machine
- **2D Level Blocking Helper** - Blocking out a level in 2D is easier with the BlockingBlock scene. This scene is added to the FileSystem dock's Favorites list.  Just drag it directly into your 2D level's scene.  Resize and move block as usual in the 2D editor.  Control the color of all blocking blocks in the project settings (Godot Helpr Pack Plugin -> Blocking Global Color) or set block colors individually.
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

