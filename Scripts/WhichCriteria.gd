extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal startGame

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func setText(type, color, keepAlive):
	$PanelContainer/VBoxContainer/HBoxContainer/Type.text = type + " shapes"
	$PanelContainer/VBoxContainer/HBoxContainer/Color.text = color + " shapes"
	$PanelContainer/VBoxContainer/KeepAlivePanel/KeepAlive.text = "KEEP ("+type+" + "+color+") ALIVE"
	


func _on_WhichCriteria_visibility_changed():
	$AnimationPlayer.play("goToCorner")
