extends Node2D

var ballScene: PackedScene = preload("res://ball.tscn")
var ball: Ball = null

func _ready():
	setup_next_ball()

func setup_next_ball():
	ball = ballScene.instantiate() as Ball
	ball.corporeal = false
	
	move_ball_to_mouse()
	$Balls.add_child(ball, true)

func drop_ball():
	ball.corporeal = true
	
	setup_next_ball()

func move_ball_to_mouse():
	ball.global_position.x = clamp(
		get_global_mouse_position().x,
		$Field/Left.global_position.x + ball.global_radius,
		$Field/Right.global_position.x - ball.global_radius,
	)

func _physics_process(_delta):
	for ball1: Ball in $Balls.get_children():
		for ball2: Ball in ball1.get_touching_balls():
			ball1.merge_with(ball2)

func _process(_delta):	
	move_ball_to_mouse()

	if Input.is_action_just_released("primary_action"):
		drop_ball()
