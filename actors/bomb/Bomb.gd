extends Interactable

class_name Bomb

signal sliced(points)

var spark_origin = Vector3(0,1.907,-0.028)

func _ready() -> void:
	$Light.play()
	yield(get_tree().create_timer(0.3),"timeout")
	$Wick.play()
	touched = true

func slice(angle: float, speed: float) -> void:
	$CollisionShape.disabled = true
	$Cling.play()
	game.explosion()
