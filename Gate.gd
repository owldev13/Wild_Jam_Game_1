extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gate_open : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	var gate_button = get_node("../GateToggleButton")
	gate_button.connect("button_active", self, "on_button_active")
	gate_button.connect("button_inactive", self, "on_button_inactive")
# Replace with function body.
func on_button_active():
	gate_open = true
	pass

func on_button_inactive():
	gate_open = false
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gate_open:
		get_node("StaticBody2D/CollisionShape2D").disabled = true
		self.play("open")
	else:
		get_node("StaticBody2D/CollisionShape2D").disabled = false
		self.play("Close")
