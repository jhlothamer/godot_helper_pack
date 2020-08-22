extends Node
class_name CameraShake


export var use_simplex_noise: bool = true
export var simplex_noise_speed: float = 1.0
export var max_rotation_degrees: float = 0.0


var noise_y: float = 0.0
var current_priority: int = -1
var camera_shake_timer: float = 0
var camera_shake_timer_max: float = 0
var camera_shake_amount: float = 0


onready var camera: Camera2D = get_parent() if typeof(get_parent()) == typeof(Camera2D) else null
onready var noise = OpenSimplexNoise.new()


static func enable_camera_shake(shaker: Object):
	assert(shaker != null)
	if !shaker.has_user_signal("CameraShake"):
		shaker.add_user_signal("CameraShake", [ 
		{ "name": "priority", "type": TYPE_INT},
		{ "name": "duration", "type": TYPE_REAL},
		{ "name": "amount", "type": TYPE_REAL}
		])
		SignalMgr.register_publisher(shaker, "CameraShake")


static func shake_camera(shaker: Object, priority: int, duration: float, amount: float):
	shaker.emit_signal("CameraShake", priority, duration, amount)


func _ready():
	SignalMgr.register_subscriber(self, "CameraShake", "on_camera_shake")
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2


func on_camera_shake(priority: int, duration: float, amount: float) -> void:
	start_camera_shake(priority, duration, amount)


func start_camera_shake(priority: int, duration: float, amount: float):
	if priority < current_priority || camera == null:
		return
	current_priority = priority
	camera_shake_amount = amount
	camera_shake_timer_max = duration
	camera_shake_timer = 0.0


func _physics_process(delta):
	if current_priority < 0:
		return
	camera_shake_timer += delta
	if camera_shake_timer >= camera_shake_timer_max:
		camera.offset = Vector2.ZERO
		camera.rotation_degrees = 0.0
		current_priority = -1
		#print("done shaking camera at timer value " + str(camera_shake_timer))
		return
	var camera_offset = Vector2()
	var rotation: float
	if use_simplex_noise:
		noise_y += simplex_noise_speed
		if max_rotation_degrees > 0:
			rotation = max_rotation_degrees * noise.get_noise_2d(noise.seed, noise_y)
		else:
			rotation = 0.0
		camera_offset.x = camera_shake_amount * noise.get_noise_2d(noise.seed*2, noise_y)
		camera_offset.y = camera_shake_amount * noise.get_noise_2d(noise.seed*3, noise_y)
	else:
		rotation = max_rotation_degrees * rand_range(-1,1) if max_rotation_degrees > 0 else 0.0
		camera_offset = Vector2(rand_range(-1,1)*camera_shake_amount, rand_range(-1,1)*camera_shake_amount)
	camera.offset = camera_offset
	camera.rotation_degrees = rotation

