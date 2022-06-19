class_name ShakeIt
extends Node

signal completed()

enum ShakeType {
	RANDOM,
	NOISE,
	SINE
}

export var simplex_noise_speed: float = 1.0
export (ShakeType) var shake_type: int = 0
export (float, .001, 10000.0) var shake_duration := 1.0
export var shake_amount := 20.0
export var shake_speed := 1.0


var shaking := false

var _noise :OpenSimplexNoise
var _parent: Node2D


var _noise_y: float = 0.0
var _current_shake_type: int

var _shake_timer: float = 0
var _shake_timer_max: float = 0
var _camera_shake_amount: float = 0
var _camera_shake_speed: float = 1.0

var _rand :RandomNumberGenerator
var _parent_original_position: Vector2


func _ready():
	set_physics_process(false)
	var parent = get_parent()
	if parent is Node2D:
		_parent = parent
	else:
		printerr("ShakeIt:  parent must be a Node2D")
		return
	_parent_original_position = _parent.position
	_rand = RandomNumberGenerator.new()
	_rand.randomize()
	_noise = OpenSimplexNoise.new()
	_noise.seed = _rand.randi()
	_noise.period = 4
	_noise.octaves = 2


func stop_shake() -> void:
	if !_parent:
		return
	_shake_timer = _shake_timer_max
	set_physics_process(false)
	shaking = false


func start_shake(type: int = -1, duration: float = -1.0, amount: float = -1.0, speed: float = -1.0):
	if !_parent:
		return
	
	if type < 0:
		type = shake_type
	if duration < 0:
		duration = shake_duration
	if amount < 0:
		amount = shake_amount
	if speed < 0:
		speed = shake_speed
	
	_current_shake_type = shake_type
	_camera_shake_amount = amount
	_shake_timer_max = duration
	_shake_timer = 0.0
	_camera_shake_speed = speed
	set_physics_process(true)
	shaking = true



func _physics_process(delta):
	
	_shake_timer += delta
	if _shake_timer >= _shake_timer_max:
		_parent.position = _parent_original_position
		set_physics_process(false)
		shaking = false
		emit_signal("completed")
		return

	var offset = Vector2()
	
	if _current_shake_type == ShakeType.NOISE:
		_noise_y += simplex_noise_speed
		offset.x = _camera_shake_amount * _noise.get_noise_2d(_noise.seed*2, _noise_y)
		offset.y = _camera_shake_amount * _noise.get_noise_2d(_noise.seed*3, _noise_y)
	elif _current_shake_type == ShakeType.RANDOM:
		offset = Vector2(_rand.randf_range(-1,1)*_camera_shake_amount, _rand.randf_range(-1,1)*_camera_shake_amount)
	else:
		var ticks_ms := OS.get_ticks_msec()*_camera_shake_speed
		offset.x = _camera_shake_amount * sin(ticks_ms * .03)
		offset.y = _camera_shake_amount * cos(ticks_ms * .07)
	
	_parent.position = _parent_original_position + offset

