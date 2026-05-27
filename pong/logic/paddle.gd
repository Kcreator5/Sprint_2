extends Area2D


const MOVE_SPEED = 100

@export var follow_mouse = false
@export var follow_mouse_horizontal = false
@export var mouse_follow_speed = 180.0
@export var mouse_min_x = 16.0
@export var mouse_max_x = -1.0

var _ball_dir
var _up
var _down

@onready var _screen_size_x = get_viewport_rect().size.x
@onready var _screen_size_y = get_viewport_rect().size.y


func _ready():
	var n = String(name).to_lower()
	_up = n + "_move_up"
	_down = n + "_move_down"
	if n == "left":
		_ball_dir = 1
	else:
		_ball_dir = -1


func _process(delta):
	if follow_mouse:
		var mouse_position = get_global_mouse_position()
		var target_position = position
		target_position.y = clamp(mouse_position.y, 16, _screen_size_y - 16)

		if follow_mouse_horizontal:
			var max_x = mouse_max_x
			if max_x < 0:
				max_x = _screen_size_x - 16
			target_position.x = clamp(mouse_position.x, mouse_min_x, max_x)

		position = position.move_toward(target_position, mouse_follow_speed * delta)
		return

	# Move up and down based on input.
	var input = Input.get_action_strength(_down) - Input.get_action_strength(_up)
	position.y = clamp(position.y + input * MOVE_SPEED * delta, 16, _screen_size_y - 16)


func _on_area_entered(area):
	if area.name == "Ball":
		# Assign new direction.
		area.direction = Vector2(_ball_dir, randf() * 2 - 1).normalized()
