extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setLabel(staticBodyObject):
	if staticBodyObject != null:
		var label = $PanelContainer/Label
		var object = staticBodyObject.get_parent()
		label.text = object.colorName + " "
		label.text += object.type
