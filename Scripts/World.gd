extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score = 0

var criteriaColor = "red"
var criteriaType = "sphere"
var gameStart = false


var gameOver = false
var losePlayed = false
var ROTSPEED = 0.25


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fadeInMusic")
	randomize()
	muffleSound(true)
	$WorldEnvironment.environment.set("adjustment_saturation", 0.01)
	$CanvasLayer/Tutorial.show()
	$CanvasLayer/WhichCriteria.hide()
	$CanvasLayer/ScoreDisplay.hide()
	$CanvasLayer/GameOverScreen.hide()	
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_physics_process(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !gameStart:
		muffleSound(true)		
		get_tree().paused = true
	elif gameStart and !gameOver:
		muffleSound(false)		
		get_tree().paused = false
		$CanvasLayer/WhichCriteria.setText(criteriaType, criteriaColor, null)
		$CanvasLayer/WhichCriteria.show()
		$CanvasLayer/ScoreDisplay.show()
		$CanvasLayer/ScoreDisplay/PanelContainer/Label.text = "SCORE: "+str(score)
		
		
		
	#DEBUG 
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		get_tree().paused = false
	if gameOver:
		set_physics_process(0)
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
			score += 150
			$CameraRig.shakeScreen()
			
		elif matchObject == "both":
			object.get_node("death").play()			
			$ShapeSpawner.lungeForward()
			#$ShapeSpawner.remove_child(object)
			score -= 200
			
		else:
			object.get_node("wrong").play()
			score -= 100
			
		if score<0:
			score=0
			
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
	$CanvasLayer/WhichCriteria.hide()
	$CanvasLayer/ScoreDisplay.hide()
	
	$CanvasLayer/GameOverScreen.setScore(score)
	$CanvasLayer/GameOverScreen.show()
	if !$loseSound.playing and losePlayed == false:
		$loseSound.play()
		losePlayed = true
		muffleSound(true)
	$ShapeSpawner.rotate_y(ROTSPEED*delta)
	var lerpedSat = lerp($WorldEnvironment.environment.get("adjustment_saturation"), 0.01, 2*delta)
	$WorldEnvironment.environment.set("adjustment_saturation", lerpedSat)
	

func muffleSound(which):
	if which:
		var bus = AudioServer.get_bus_effect(2, 0)
		bus.wet = 0.9
		bus.dry = 0.05
		var bus2 = AudioServer.get_bus_effect(2, 1)
		bus2.volume_db = -15
	else:
		var bus = AudioServer.get_bus_effect(2, 0)
		bus.wet = 0.05
		bus.dry = 1.0
		var bus2 = AudioServer.get_bus_effect(2, 1)
		bus2.volume_db = 0

func _on_CameraRig_cameraHit():
	get_tree().paused = true
	$CameraRig/ObjectDesc.hide()
	gameOver = true
	pass # Replace with function body.


func _on_CriteriaTimer_timeout():
	randomizeCriteria()
	$newCriteria.play()
	$CanvasLayer/WhichCriteria.newCriteria()#hide()
	$CriteriaTimer.wait_time -= 0.5
	$CriteriaTimer.wait_time = clamp($CriteriaTimer.wait_time, 4.5, 10)
	pass
	
func randomizeCriteria():
	randomize()
	var shapeTypes = ["sphere", "triangle", "cube"]
	criteriaType = shapeTypes[randi()%3]
	criteriaColor = globals.getRandomColorName()


func _on_Tutorial_startGame():
	gameStart = true
	$WorldEnvironment.environment.set("adjustment_saturation", 1)
	$CanvasLayer/Tutorial.hide()
	randomizeCriteria()
	$newCriteria.play()
	$CanvasLayer/WhichCriteria.hide()
	$CriteriaTimer.start()
	$ScoreTimer.start()
	$CanvasLayer/WhichCriteria.newCriteria()#


func _on_ScoreTimer_timeout():
	score += 1


func _on_GameOverScreen_restartGame():
	get_tree().reload_current_scene()
	get_tree().paused = false
