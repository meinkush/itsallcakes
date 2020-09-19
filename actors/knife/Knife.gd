extends Line2D

class_name Knife

var index = -1 setget set_index

onready var space = get_viewport().get_world().get_direct_space_state()

var cut_query = PhysicsShapeQueryParameters.new()

var query_shape = BoxShape.new()

func _ready() -> void:
	cut_query.set_shape(query_shape)

func _process(_delta):
	if points.size() > 1:
		set_point_position(0, points[0].linear_interpolate(points[1], 0.9))
		if points[0].distance_to(points[1]) < 1 or points.size() > 10:
			remove_point(0)

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed() and index == -1:
			set_index(event.index)
			$Sparks.position = event.position
		elif !event.is_pressed() and event.index == index:
			set_index(-1)
	elif event is InputEventScreenDrag and event.index == index:
		if points.size() > 3:
			if abs(points[points.size() - 2].angle_to_point(points[points.size() - 1]) - points[points.size() - 1].angle_to_point(event.position)) > PI/2:
				$Swing.play()
		$Sparks.position = event.position
		if points.size() > 1 and !$Swing.playing:
			$Swing.play()
		if points.size() > 0:
			var length = get_parent().space_position(points[points.size() - 1]).distance_to(get_parent().space_position(event.position))
			var angle = points[points.size() - 1].angle_to_point(event.position)
			query_shape.set_extents(Vector3(length,0.1,2))
			cut_query.transform = Transform(Basis().rotated(Vector3(0,0,-1),angle), get_parent().space_position(event.position) + Vector3(length/2,0,1).rotated(Vector3(0,0,-1),angle))
			for cake in space.intersect_shape(cut_query):
				cake['collider'].slice(-angle, length)
		add_point(event.position)

func set_index(new_index):
	if new_index > -1:
		$Sparks.emitting = true
		clear_points()
	else:
		$Sparks.emitting = false
	index = new_index
