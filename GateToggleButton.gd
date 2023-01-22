extends AnimatedSprite

signal button_active

signal button_inactive

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var toggled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	toggled = false
	for i in get_node("Area2D").get_overlapping_bodies():
		if i.is_in_group("TogglesBlock"):
			toggled = true
	
	if toggled:
		emit_signal("button_active")
		self.frame = 1
	if !toggled:
		emit_signal("button_inactive")
		self.frame = 0
