extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var criteriaColor = "red"
var criteriaType = "sphere"

# Called when the node enters the scene tree for the first time.
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_physics_process(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		
func _physics_process(delta):
	if $CameraRig.selectedObject !=null and Input.is_action_just_pressed("click"):
		var object = $CameraRig.selectedObject.get_parent()
		if checkIfMatch(object):
			$ShapeSpawner.jerkBackAll()
			
func checkIfMatch(object):
	var A = criteriaColor == object.colorName
	var B = criteriaType == object.type
	if A or B:
		return true
	else:
		return false
