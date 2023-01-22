extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var starting_position : Vector2
var going_down = true
var tween : Tween

export(float) var time
# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = position
	tween = get_node("Tween")
	tween.interpolate_property(get_node("."), "position", starting_position, starting_position + Vector2(0, 112), 3.0,Tween.TRANS_LINEAR,Tween.EASE_IN, time)
	tween.start()
	
func _process(delta):
	if !tween.is_active():
		if going_down:
			going_down = false
			tween.interpolate_property(get_node("."), "position", starting_position + Vector2(0,112), starting_position, 3.0,Tween.TRANS_LINEAR, Tween.EASE_IN, time)
			tween.start()
			return
		if !going_down:
			going_down = true
			tween.interpolate_property(get_node("."), "position", starting_position, starting_position + Vector2(0, 112), 3.0,Tween.TRANS_LINEAR,Tween.EASE_IN, time)
			tween.start()
