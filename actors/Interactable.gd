extends RigidBody

class_name Interactable

signal uncut()

var touched = false

var layer := 0

func _ready() -> void:
	rotation.z = rand_range(-1,1)
	angular_velocity = Vector3(rand_range(-3,3),rand_range(-3,3),rand_range(-3,3))

func _process(_delta):
	$figure.translation = to_local(translation - Vector3(0,0,layer))
	if translation.y < get_tree().current_scene.margins['bottom'] - 2:
		if !touched:
			emit_signal('uncut')
		queue_free()

func stop():
	sleeping = true
	disable()

func disable():
	$CollisionShape.disabled = true

