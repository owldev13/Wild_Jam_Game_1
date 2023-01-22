extends ColorRect

export(String) var dialog_path

export(float) var text_speed

var dialog

var phrase_num

var finished = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Harold : Texture

var Jerry : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	phrase_num = 0
	Harold = load("res://Harold.png")
	Jerry = load("res://Harold.png")
	$Timer.wait_time = text_speed
	dialog = get_dialog()
	next_phrase()
	pass # Replace with function body.
	
func _process(delta):
	$Text_Indicator.visible = finished
	if Input.is_action_just_pressed("finish_talking") or Input.is_action_just_pressed("ui_accept"):
		if finished:
			next_phrase()
		else:
			$Text.visible_characters = len($Text.text)
	if Input.is_action_just_pressed("start"):
		queue_free()

func get_dialog() -> Array:
	var file = File.new()
	
	file.open(dialog_path, File.READ)
	
	var json_info = file.get_as_text()
	
	var output = parse_json(json_info)
	
	file.close()
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return[]
		
func next_phrase():
	if phrase_num >= len(dialog):
		queue_free()
		return
	
	finished = false
	
	$Name.bbcode_text = dialog[phrase_num]["Name"] + ":"
	$Text.bbcode_text = dialog[phrase_num]["Text"]
	
	$Text.visible_characters = 0
	if dialog[phrase_num]["Name"] == "Harold":
		$Sprite.texture = Harold
	if dialog[phrase_num]["Name"] == "Jerry":
		$Sprite.texture = Jerry
		
	while $Text.visible_characters < len($Text.text):
		$Text.visible_characters += 1
		
		$Timer.start()
		yield($Timer, "timeout")
	
	finished = true
	phrase_num += 1
	return
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
