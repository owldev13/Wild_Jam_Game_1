extends KinematicBody2D

var velocity = Vector2()

export var gravity_acceleration = 1000

var gravity = 0

var jumps = 0

export var jumps_amount = 0

var coyote_time

export var coyote_time_length = 0.0

export var speed = 200

export var jump_power = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("jump"):
		if jumps:
			jumps -= 1
			gravity = -jump_power
	

# Called when the node enters the scene tree for the first time
func _ready():
	pass # Replace with function body. 

func _physics_process(delta):
	
	gravity += gravity_acceleration * delta
	get_input()
	
# 2 occurences of move_and_slide because one uses velocity multiplied by speed and the other doesn't
	
	move_and_slide(velocity * speed, Vector2.UP)
	velocity.y += gravity
	velocity.x = 0
	move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		jumps = jumps_amount
		gravity = 0
		coyote_time = 0
		
	if is_on_ceiling():
		gravity = 0
	
	if not is_on_floor() and jumps == jumps_amount:
		coyote_time += delta
		if coyote_time > coyote_time_length:
			jumps = jumps_amount - 1
