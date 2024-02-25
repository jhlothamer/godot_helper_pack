## This node shakes its parent Camera2D.
@tool
class_name CameraShake2D
extends Node

## The speed of change for the noise input. Used to advance through noise values.
@export var noise_speed_factor: float = 4.0
## Maximum rotation applied to camera during shake. Default is zero, meaning by default no rotation occurs.
@export var max_rotation: float = 0.0
## Used for computing locations to move camera to to produce shaking.
## This smooths out the shaking effect. If not supplied, the locations are generated randomly.
@export var noise:FastNoiseLite


@onready var _camera: Camera2D


var _noise_coordinate: float = 0.0
var _current_priority: int = -1
var _camera_shake_timer: float = 0
var _camera_shake_timer_max: float = 0
var _camera_shake_amount: float = 0
var _rand := RandomNumberGenerator.new()


func _enter_tree():
	if Engine.is_editor_hint():
		return
	ServiceMgr.register_service(CameraShake2D, self)


func _ready():
	var parent = get_parent()
	if parent is Camera2D:
		_camera = parent
	set_physics_process(false)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if !get_parent() is Camera2D:
		warnings = ['CameraShake2D must be child of Camera2D']
	return warnings


## Starts the camera shaking for the given duration and amount
## if the priority is greater than the currently running camera shake.
func shake_camera(priority: int, duration: float, amount: float) -> void:
	if priority < _current_priority || _camera == null:
		return
	_current_priority = priority
	_camera_shake_amount = amount
	_camera_shake_timer_max = duration
	_camera_shake_timer = 0.0
	set_physics_process(true)

func _physics_process(delta):
	_camera_shake_timer += delta
	if _camera_shake_timer >= _camera_shake_timer_max:
		_camera.offset = Vector2.ZERO
		_camera.rotation = 0.0
		_current_priority = -1
		set_physics_process(false)
		return
	var camera_offset = Vector2()
	var rotation: float
	if noise:
		_noise_coordinate += noise_speed_factor
		if max_rotation > 0:
			rotation = max_rotation * noise.get_noise_2d(noise.seed, _noise_coordinate)
		else:
			rotation = 0.0
		camera_offset.x = _camera_shake_amount * noise.get_noise_2d(noise.seed*10, _noise_coordinate)
		camera_offset.y = _camera_shake_amount * noise.get_noise_2d(_noise_coordinate, noise.seed*30)
		if camera_offset.x >= _camera_shake_amount * .75 or camera_offset.y >= _camera_shake_amount * .75:
			pass
	else:
		rotation = max_rotation * _rand.randf_range(-1,1) if max_rotation > 0 else 0.0
		camera_offset = Vector2(_rand.randf_range(-1,1)*_camera_shake_amount, _rand.randf_range(-1,1)*_camera_shake_amount)
	_camera.offset = camera_offset
	_camera.rotation = rotation

