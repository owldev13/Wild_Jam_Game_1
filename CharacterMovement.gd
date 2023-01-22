extends KinematicBody2D

var velocity = Vector2()

export var gravity_acceleration = 1000

var gravity = 0

var jumps = 0

var key_unlocked = false

export var jumps_amount = 0

var coyote_time : float

export var coyote_time_length = 0.0

export var speed = 200

export var jump_power = 0

var direction = false
#false is right, left is true

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
		get_node("AnimatedSprite").play("Run")
		direction = false
	if Input.is_action_pressed("left"):
		get_node("AnimatedSprite").play("Run-Reverse")
		velocity.x -= 1
		direction = true
	if Input.is_action_just_pressed("jump"):
		if jumps:
			jumps -= 1
			gravity = -jump_power
	if !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
		if !direction:
			get_node("AnimatedSprite").play("Idle")
		if direction:
			get_node("AnimatedSprite").play("Idle-reverse")

# Called when the node enters the scene tree for the first time
func _ready():
	pass # Replace with function body. 

func _physics_process(delta):
	
	gravity += gravity_acceleration * delta
	get_input()
	
#   2 occurences of move_and_slide because I get the collisions from side to side movement to check for stuff
	
	move_and_slide(velocity * speed, Vector2.UP, true, 6, 1.55334, true)
	if get_slide_count() != 0:
		for i in range(0, get_slide_count(), 1):
			var collision = get_slide_collision(i)
			if collision:
				var collider = collision.collider
				if collider.is_in_group("MovingPlatform"):
					if collider.position.x > position.x && collider.position.y > position.y:
						get_node("RightFacingRaycast").force_raycast_update()
						var platform_raycast_collider = get_node("RightFacingRaycast").get_collider()
						if platform_raycast_collider:
							if platform_raycast_collider.position == collider.position:
								move_and_slide(Vector2(1 / delta,-20 / delta))
					if collider.position.x < position.x && collider.position.y > position.y:
						get_node("LeftFacingRaycast2").force_raycast_update()
						var platform_raycast_collider = get_node("LeftFacingRaycast2").get_collider()
						if platform_raycast_collider:
							if platform_raycast_collider.position == collider.position:
								print("Colliding on left")
								move_and_slide(Vector2(1 / delta,-20 / delta))
				if collider.is_in_group("MoveableBlock") && abs(collision.get_angle(Vector2.UP) - 1.5708) <= 0.1:
					collider.move_and_collide(collision.remainder, false)
					move_and_collide(collision.remainder)
	
	velocity.y += gravity
	velocity.x = 0
	move_and_slide(velocity, Vector2.UP, false, 1)
	
	if is_on_floor():
		jumps = jumps_amount
		gravity = 0
		coyote_time = 0
		
	if is_on_ceiling():
		gravity = 0
	
	if not is_on_floor() and jumps == jumps_amount:
		coyote_time += delta
		if coyote_time > coyote_time_length && jumps != 0:
			jumps = jumps_amount - 1
