extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var gravity_accel
var gravity : float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	gravity += gravity_accel * delta
	
	var collision = move_and_collide(Vector2(0, gravity) * delta, false)
	if collision != null:
		if collision.get_angle(Vector2.UP) == 0 && collision.collider.position.y > position.y:
			gravity = 0
			if collision.collider.is_in_group("IsKillableByDroppingObjects"):
				get_tree().call_group("User added blocks", "queue_free")
				get_tree().reload_current_scene()
