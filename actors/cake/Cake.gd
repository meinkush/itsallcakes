extends Interactable

class_name Cake

signal sliced(points)

export var points = 1

func _ready():
	$Whoosh.play()
	

func slice(angle: float, speed: float) -> void:
	if !touched:
		var final_dir = Vector2(-1,0).rotated(angle)
		apply_central_impulse(Vector3(final_dir.x,final_dir.y,0) * clamp(speed,.2,2))
		rotation = Vector3(0,0,angle)
		$CollisionShape.disabled = true
		$Tween.interpolate_property($figure/L,'rotation_degrees',Vector3(),Vector3(20,-100,-360),5,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.interpolate_property($figure/L,'translation',Vector3(),Vector3(0,-2,0),5,Tween.TRANS_QUINT,Tween.EASE_OUT)
		$Tween.interpolate_property($figure/R,'rotation_degrees',Vector3(),Vector3(20,100,-360),5,Tween.TRANS_LINEAR,Tween.EASE_IN)
		$Tween.interpolate_property($figure/R,'translation',Vector3(),Vector3(0,2,0),5,Tween.TRANS_QUINT,Tween.EASE_OUT)
		$Tween.start()
		$Slice.play()
		emit_signal('sliced', points)
		angular_velocity = Vector3()
		touched = true
		$Meringue.position = game.screen_position(translation)
		$Meringue.emitting = true
