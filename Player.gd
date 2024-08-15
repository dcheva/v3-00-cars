extends KinematicBody2D

var velocity = Vector2()
var steer = 0
var speed = 0
var rot_speed = 0.15
var max_steer = 15
var max_speed = 300
var opt_speed = 80
var min_speed = 20
var acceleration = 1.2
var breaking = -0.5
var track_n = 0

signal set_hud


func _ready():
	$DrawTrack.start()


func _physics_process(delta):
	get_input()
	rotation += steer * rot_speed * delta
	velocity = Vector2(0, -speed).rotated(rotation)
	velocity = move_and_slide(velocity)
	emit_signal("set_hud")


func get_input():
	var speed_to = 0
	var steer_to = steer
	
	if Input.is_action_pressed("right_arrow"):
		steer_to = max_steer
	if Input.is_action_pressed("left_arrow"):
		steer_to = -max_steer
	if Input.is_action_pressed("up_arrow"):
		speed_to = max_speed * acceleration
	if Input.is_action_pressed("down_arrow"):
		speed_to = max_speed * breaking
	if Input.is_action_pressed("space"):
		get_drift()
		
	get_physics(speed_to, steer_to)


func get_drift():
	speed = lerp(speed, 0, 0.1)
	steer = steer * 2


func get_physics(speed_to, steer_to):
	
	# Reverse steering
	if speed < 0: 
		steer_to = -steer_to


	# Physics with LERP
	speed = lerp(speed, speed_to, 0.01)
	steer = lerp(steer, steer_to, 0.1)


	# Speed ​​steering
	if speed > 0:
		if abs(speed) < opt_speed:
			steer = steer * ((abs(speed) + opt_speed) / (2 * opt_speed))
		if abs(speed) > opt_speed:
			steer = steer * (max_speed - sqrt(abs(speed))) / max_speed


	# Speed limits
	steer  = clamp(steer, -max_steer, max_steer)
	speed = clamp(speed, -max_speed/2, max_speed)


	# Autobrake
	if abs(speed) < min_speed:
		steer = 0
		if speed_to == 0:
			speed = lerp(speed, 0, 0.1)


func _on_DrawTrack_timeout():
	# Instantiate and draw tracks in main scene
	track_n += 1
	var t = "Draw track #%s" % track_n
	print(t)
