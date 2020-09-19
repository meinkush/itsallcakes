extends Node

class_name Game

signal start()

signal explode()

signal end()

var file = 'user://savegame.save'

var data = {}

var original = {}

export(Array, PackedScene) var cakes

var baseDict = {
	'highScore': 0
}

func explosion():
	get_tree().call_group('interactable', 'stop')
	emit_signal("explode")
	game.emit_signal('end')

func get_cake():
	return cakes[randi() % cakes.size()].instance()

func remove_interactables():
	get_tree().call_group('interactable', 'queue_free')

func load_data():
	var save_game = File.new()
	if not save_game.file_exists(file):
		original = baseDict
	else:
		save_game.open(file, File.READ)
		var save_data = parse_json(save_game.get_line())
		save_game.close()
		if typeof(save_data) != TYPE_DICTIONARY:
			original = baseDict
			print('ERROR: damaged savefile')
		else:
			original = save_data
	data = original.duplicate(true)
	return data['highScore']

func _notification(what: int):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		save_data()

func save_data():
	if data['highScore'] > original['highScore']:
		var save_game = File.new()
		save_game.open(file, File.WRITE)
		save_game.store_line(to_json(data))
		save_game.close()
		original = data.duplicate(true)

func screen_position(space_position: Vector3) -> Vector2:
	return get_tree().current_scene.screen_position(space_position)
