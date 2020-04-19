extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal startGame

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("cycleColors")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	emit_signal("startGame")
