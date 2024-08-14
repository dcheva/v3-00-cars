extends KinematicBody2D

var screen_size
var steer = 0
var speed = 0
var rot_speed = 0.15
var opt_speed = 30
var max_speed = 300
var max_steer = 60
var velocity = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	
func get_input():
	var speed_to = speed 
	var steer_to = steer
	if Input.is_action_pressed("space"):
		speed_to = lerp(speed_to, speed_to/2, 0.2)
		steer_to = steer_to * 1.2
	if Input.is_action_pressed("right_arrow"):
		if speed > 0:
			steer_to += 1
		else:
			steer_to -= 1
	if Input.is_action_pressed("left_arrow"):
		if speed > 0:
			steer_to -= 1
		else:
			steer_to += 1
	if Input.is_action_pressed("up_arrow"):
		speed_to += max_speed / 20
	if Input.is_action_pressed("down_arrow"):
		speed_to -= max_speed / 50
	
	# Physics Processing: steering with speed
	if speed_to != 0 and abs(speed_to) < opt_speed:
		steer_to = steer_to * ((abs(speed_to) + opt_speed) / (2 * opt_speed))
	elif speed_to != 0:
		steer_to = steer_to * (max_speed - sqrt(abs(speed_to))) / max_speed
	
	# Physics Processing: LERP
	speed = lerp(speed_to, speed/2, 0.02)
	steer = lerp(steer_to, steer/2, 0.1)
	
	# Physics Processing: CLAMP
	speed = clamp(speed, -max_speed/2, max_speed)
	steer  = clamp(steer, -max_steer, max_steer)
	
	
func _physics_process(delta):
	get_input()
	rotation += steer * rot_speed * delta
	velocity = Vector2(0, -speed).rotated(rotation)
	velocity = move_and_slide(velocity)
