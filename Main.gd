extends Node

var cam = Vector2()

var Track_S = preload("res://Track_S.tscn").instance()


func _ready():
	$DrawTrack.start()


func _process(_delta):
	if Input.is_action_just_pressed("alt_enter"):
		OS.window_fullscreen = !OS.window_fullscreen  


func _on_Player_set_hud():
	var pos = $Player.position
	var rot = $Player.rotation_degrees
	var vel = $Player.velocity
	var speed = $Player.speed
	var steer = $Player.steer
	cam = pos + Vector2(int(vel.x),int(vel.y/2))
	set_label([pos,rot,vel,speed,steer,cam])
	$Camera.position = cam


func set_label(args):
	var l = $Canvas/Control/Label
	l.text =  "X, Y     : %s, %s\n" % [int(args[0][0]), int(args[0][1])]
	l.text += "Speed    : %s\n" % int(args[3])
	l.text += "Steering : %s\n" % int(args[4])
	l.text += "Rotation : %s\n" % int(args[1])
	l.text += "Velocity : %s, %s\n" % [int(args[2][0]), int(args[2][1])]
	l.text += "Camera   : %s, %s\n" % [int(args[5][0]), int(args[5][1])]


func _on_DrawTrack_timeout():
	# Instantiate and draw tracks on the main scene
	add_child(Track_S)
