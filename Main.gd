extends Node

class_name Main

signal no_more_cakes()

onready var margins = {
	'left': 0,
	'right': 0,
	'bottom': 0,
	'top': 0
}

const layers = 80

export var bomb: PackedScene

var spawning := false setget set_spawning

var current_layer = layers

func _ready() -> void:
	resize_margins()
	get_tree().connect('screen_resized', self, 'resize_margins')
	game.connect('end', self, 'set_spawning', [false])
	
	game.connect('start', self, 'start')
	set_spawning(false)

func start():
	set_spawning(true)

func space_position(screen_position: Vector2) -> Vector3:
	return $UI/ViewportContainer/Viewport/Camera.project_position(screen_position, abs($UI/ViewportContainer/Viewport/Camera.translation.z))

func screen_position(space_position: Vector3) -> Vector2:
	return $UI/ViewportContainer/Viewport/Camera.unproject_position(space_position)

func spawn_cake() -> void:
	for spawning_cake in randi() % 2 + 1: 
		var new_cake = game.get_cake() if randi() % 10 > 1 else bomb.instance()
		var x_position = rand_range(margins['left'],margins['right'])
		var x_percentage = x_position / margins['right']
		var launch_angle = rand_range(-0.15* abs(x_percentage - 1),0.15 * x_percentage)
		current_layer = wrapi(current_layer - 1, 1, layers)
		new_cake.layer = current_layer
		new_cake.translation = Vector3(x_position, margins['bottom'] - 1, 1)
		new_cake.apply_central_impulse(Vector3(0,rand_range(margins['top']*1.8,margins['top']*2.6),0).rotated(Vector3(0,0,1),launch_angle))
		add_child(new_cake)
		new_cake.connect('sliced', $UI, 'add_score')
		new_cake.connect('uncut' , $UI, 'miss')
		new_cake.connect('tree_exited', self, 'check_cakes')

func check_cakes():
	if !spawning and get_tree().get_nodes_in_group('interactable').size() == 1:
		emit_signal("no_more_cakes")

func resize_margins() -> void:
	var top = space_position(Vector2(0,0))
	var bottom = space_position(OS.window_size)
	margins['top'] = top.y
	margins['left'] = top.x
	margins['right'] = bottom.x
	margins['bottom'] = bottom.y

func set_spawning(status: bool) -> void:
	$ThrowTimer.paused = !status
	spawning = status
