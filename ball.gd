extends RigidBody2D

class_name Ball

signal hit_other_ball(other: Ball)

var level: int = 1

var real_global_position: Vector2:
	get:
		return global_position
	set(new_position):
		global_position = new_position

var global_radius: float:
	get:
		var width = $CollisionShape2D.shape.get_rect().size.x
		var radius = width * $CollisionShape2D.global_scale.x / 2
		return radius

var corporeal: bool:
	get:
		return not $CollisionShape2D.disabled
	set(value):
		$CollisionShape2D.disabled = not value
		freeze = not value

func _ready():
	$CollisionShape2D.scale *= scale
	$Sprite2D.scale *= scale
	scale = Vector2.ONE
	corporeal = false

func scale_by(amount: float):
	$CollisionShape2D.scale *= Vector2(amount, amount)
	$Sprite2D.scale *= Vector2(amount, amount)

func shift_hue():
	var material = $Sprite2D.material as ShaderMaterial
	var color = material.get_shader_parameter("to") as Color
	color.h += 0.2
	material.set_shader_parameter("to", color)

func get_real_scale() -> Vector2:
	return $CollisionShape2D.scale

func get_touching_balls() -> Array[Ball]:
	var balls: Array[Ball] = []
	
	balls.assign(
		get_colliding_bodies()
		.filter(func(body): return body is Ball)
	)

	return balls

func can_merge_with(other: Ball) -> bool:
	if is_queued_for_deletion() or other.is_queued_for_deletion():
		return false

	return level == other.level

func merge_with(other: Ball):
	if not can_merge_with(other):
		return

	real_global_position = (real_global_position + other.real_global_position) / 2
	scale_by(1.5)
	shift_hue()
	level += 1
	other.queue_free()
