extends Control

class_name UI

var score = 0

var misses = 0

onready var max_score = game.load_data()

func _ready():
	game.connect("explode", self, 'explode')
	formated_score($Score/MaxScore, max_score)
	show_start()

func add_score(points):
	score += points
	formated_score($Score,score)
	if score > max_score:
		max_score = score
		game.data['highScore'] = max_score
		formated_score($Score/MaxScore, max_score)

func show_start():
	$Start.show()
	var cake = game.get_cake()
	cake.gravity_scale = 0
	add_child(cake)
	cake.points = 1
	cake.connect('sliced', cake, 'set_gravity_scale')
	cake.connect('sliced', self, 'start_sliced')

func start_sliced(p: int):
	game.emit_signal('start')
	$Start.hide()

func miss():
	if $Misses.get_children().back().pressed:
		end()
	else:
		for miss in $Misses.get_children():
			if !miss.pressed:
				miss.pressed = true
				$Splat.play()
				break

func explode():
	$AnimationPlayer.play("explosion")
	yield($AnimationPlayer, "animation_finished")
	end()
	game.remove_interactables()
	$AnimationPlayer.play('fade out')
	yield($AnimationPlayer, "animation_finished")

func end():
	game.emit_signal('end')
	if get_tree().get_nodes_in_group('interactable').size() > 0:
		for interactable in get_tree().get_nodes_in_group('interactable'):
			interactable.disconnect('uncut', self, 'miss')
			interactable.disable()
		yield(get_parent(), 'no_more_cakes')
	for miss in $Misses.get_children():
		miss.pressed = false
	show_start()
	score = 0
	formated_score($Score,score)

func formated_score(label: Label, score: int) -> void:
	label.set_text("%03d" % score)
