extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var criteriaColor = "red"
var criteriaType = "sphere"
var gameStart = false

var gameOver = false
var ROTSPEED = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	$WorldEnvironment.environment.set("adjustment_saturation", 0.01)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_physics_process(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !gameStart:
		get_tree().paused = true
	elif gameStart and !gameOver:
		get_tree().paused = false
		
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		get_tree().paused = false
	if gameOver:
		
		gameOverEffects(delta)
		
func _physics_process(delta):
	if $CameraRig.selectedObject !=null and Input.is_action_just_pressed("click"):
		var object = $CameraRig.selectedObject.get_parent()
		var matchObject = checkIfMatch(object)
		if matchObject=="good":
			object.get_node("correct").play()
			$ShapeSpawner.jerkBackAll()
			var index = $ShapeSpawner.shapes.find(object)
			$ShapeSpawner.shapes.remove(index)
			object.toRemove = true
		elif matchObject == "both":
			object.get_node("death").play()			
			$ShapeSpawner.lungeForward()
			#$ShapeSpawner.remove_child(object)
		else:
			object.get_node("wrong").play()
			
			
func checkIfMatch(object):
	var A = criteriaColor == object.colorName
	var B = criteriaType == object.type
	if A and B:
		return "both"
	elif A or B:
		return "good"
	else:
		return "noMatch"

func gameOverEffects(delta):
	$ShapeSpawner.rotate_y(ROTSPEED*delta)
	var lerpedSat = lerp($WorldEnvironment.environment.get("adjustment_saturation"), 0.01, 2*delta)
	$WorldEnvironment.environment.set("adjustment_saturation", lerpedSat)
	

func _on_CameraRig_cameraHit():
	get_tree().paused = true
	$CameraRig/ObjectDesc.hide()
	gameOver = true
	pass # Replace with function body.


func _on_WhichCriteria_startGame():
	gameStart = true
	$WorldEnvironment.environment.set("adjustment_saturation", 1)
	$CanvasLayer/WhichCriteria.hide()
