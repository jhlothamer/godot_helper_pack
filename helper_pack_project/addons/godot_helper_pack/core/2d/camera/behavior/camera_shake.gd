class_name CameraShake2D
extends Node


export var use_simplex_noise: bool = true
export var simplex_noise_speed: float = 1.0
export var max_rotation_degrees: float = 0.0


onready var _camera: Camera2D
onready var _noise = OpenSimplexNoise.new()


var _noise_y: float = 0.0
var _current_priority: int = -1
var _camera_shake_timer: float = 0
var _camera_shake_timer_max: float = 0
var _camera_shake_amount: float = 0
var _rand := RandomNumberGenerator.new()


func _enter_tree():
	ServiceMgr.register_service(self.get_script(), self)


func _ready():
	var parent = get_parent()
	if parent is Camera2D:
		_camera = parent
	_rand.randomize()
	_noise.seed = _rand.randi()
	_noise.period = 4
	_noise.octaves = 2
	set_physics_process(false)


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
		_camera.rotation_degrees = 0.0
		_current_priority = -1
		set_physics_process(false)
		return
	var camera_offset = Vector2()
	var rotation: float
	if use_simplex_noise:
		_noise_y += simplex_noise_speed
		if max_rotation_degrees > 0:
			rotation = max_rotation_degrees * _noise.get_noise_2d(_noise.seed, _noise_y)
		else:
			rotation = 0.0
		camera_offset.x = _camera_shake_amount * _noise.get_noise_2d(_noise.seed*2, _noise_y)
		camera_offset.y = _camera_shake_amount * _noise.get_noise_2d(_noise.seed*3, _noise_y)
	else:
		rotation = max_rotation_degrees * _rand.randf_range(-1,1) if max_rotation_degrees > 0 else 0.0
		camera_offset = Vector2(_rand.randf_range(-1,1)*_camera_shake_amount, _rand.randf_range(-1,1)*_camera_shake_amount)
	_camera.offset = camera_offset
	_camera.rotation_degrees = rotation

