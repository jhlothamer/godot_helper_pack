extends Control

@onready var _2d_grid: GridContainer = $MarginContainer/VBoxContainer/GridContainer2D
@onready var _3d_grid: GridContainer = $MarginContainer/VBoxContainer/GridContainer3D
@onready var _audio_grid: GridContainer = $MarginContainer/VBoxContainer/GridContainerAudio
@onready var _demo_hud = $DemoHud

const DEMO_SCENES_2D = {
	"Camera Behavior": "res://demos/core/2d/camera/behavior/camera_behavior_demo.tscn",
	"Blocking": "res://demos/core/2d/shape/blocking_block_demo.tscn",
	"Shape Draw": "res://demos/core/2d/shape/shape_draw_2d_demo.tscn",
	"Shape Draw (texture)": "res://demos/core/2d/shape/shape_draw_2d_texture_demo.tscn",
	"Mover Utility": "res://demos/core/2d/util/mover_2d_demo.tscn",
	"MultiMeshInstance Distribution": "res://demos/core/2d/util/multi_mesh_instance_distribution_area_demo.tscn",
	"Rand Distribution Area": "res://demos/core/2d/util/random_distribution_area_demo.tscn",
	"Rand Distribution Area Carving": "res://demos/core/2d/util/rand_dist_carving_demo.tscn",
}

const DEMO_SCENES_3D = {
	"Camera Move": "res://demos/core/3d/camera3d_move_demo.tscn",
	"Shape Draw": "res://demos/core/3d/shape_demo.tscn",
}

const AUDIO_SCENES = {
	"Sound Track Change": "res://demos/core/audio/audio_demo.tscn"
}

func _ready():
	_add_buttons(DEMO_SCENES_2D, _2d_grid)
	_add_buttons(DEMO_SCENES_3D, _3d_grid)
	_add_buttons(AUDIO_SCENES, _audio_grid)


func _add_buttons(demo_scenes: Dictionary, grid: GridContainer):
	for key in demo_scenes.keys():
		_create_button(grid, key, demo_scenes[key])


func _create_button(parent: Control, text: String, scene_path: String) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.pressed.connect(_on_button_pressed.bind(scene_path))
	parent.add_child(btn)
	return btn


func _on_button_pressed(scene_path: String) -> void:
	_demo_hud.reparent(get_tree().root)
	_demo_hud.visible = true
	get_tree().change_scene_to_file(scene_path)

