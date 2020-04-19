extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal startGame
var curCol = "white"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func setText(type, color, keepAlive):
	$VBoxContainer/Shoot/VBoxContainer/HBoxContainer/Type/Type.text = type + " shapes"
	$VBoxContainer/Shoot/VBoxContainer/HBoxContainer/Color/Color.text = color + " color"
	#$PanelContainer/VBoxContainer/KeepAlivePanel/KeepAlive.text = "KEEP ("+type+" + "+color+") ALIVE"
	$VBoxContainer/KeepAlivePanel/Color2/HBoxContainer/KeepAlive.text = type + " + " + color
	
	setShape(type)
	if color != curCol:
		setColor(color)

func setShape(type):
	var textures = ["res://Assets/GUI/circle.png", "res://Assets/GUI/triangle.png", "res://Assets/GUI/square.png"]
	var texNum = -1
	print(type)
	if type == "sphere":
		texNum = 0
	elif type == "triangle":
		texNum = 1
	elif type == "cube":
		texNum = 2
	var tex = load(textures[texNum])
	$VBoxContainer/Shoot/VBoxContainer/HBoxContainer/Type/TextureRect.texture = tex

	$VBoxContainer/KeepAlivePanel/Color2/HBoxContainer/TextureRect.texture = tex


func setColor(color):
	curCol = color
	var colorObject = globals.getColorFromName(color)
	$VBoxContainer/Shoot/VBoxContainer/HBoxContainer/Color/TextureRect.set("modulate", colorObject)
	
	$VBoxContainer/KeepAlivePanel/Color2/HBoxContainer/TextureRect.set("modulate", colorObject)
	pass

func _on_WhichCriteria_visibility_changed():
	pass
	#$AnimationPlayer.play("goToCorner")
