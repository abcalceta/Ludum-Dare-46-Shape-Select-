extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var colorName = "white"
var colorColor = Color("#0000FF")
var type = "sphere"
var material = null

var camGlobalPos = Vector3(0,0,0)
var forwardVel = 0.5

var MAX_SPEED = 3.5
var MIN_SPEED = -10

var jerkBackSpeed = -15
var distance = 0

var ROTSPEED = 5

var toRemove = false

var lunge = false
var lungeAccel = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	ROTSPEED = rand_range(-2,2)
	
	jerkBackSpeed = rand_range(-25, -12)
	colorName = globals.getRandomColorName()
	colorColor = globals.getColorFromName(colorName)
	
	#$StaticBody/CollisionShape/mesh.material.duplicate()
	var mesh = get_child(0).get_child(0)
	#print(mesh.name)
	material = mesh.get("material/0").duplicate()
	material.set("albedo_color", Color(colorColor))
	mesh.set("material/0", material)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	get_child(0).rotate_y(delta*ROTSPEED)
	get_child(1).rotate_y(delta*ROTSPEED)
	if toRemove and $AnimationPlayer.is_playing()==false:
		$AnimationPlayer.play("disappear")
		get_child(1).get_child(0).disabled = true
	pass
	
	
	
func moveForward(delta):
	var direction = -(global_transform.origin - camGlobalPos).normalized()
	distance = (global_transform.origin).distance_to(camGlobalPos)
	#print(distance)
	
	var speed = distance
	#get_parent().get_parent().get_node("CanvasLayer/Debug/Label").text = str("Speed: ", speed)
	#get_parent().get_parent().get_node("CanvasLayer/Debug/Label2").text = str("Distance: ", distance)
	
	translate(direction*delta*forwardVel)
	forwardVel += speed*delta
	
	
	var lungeSpeed = MAX_SPEED*distance*0.05
	if lunge:
		lungeAccel += speed
		forwardVel += delta*lungeAccel
		lungeSpeed = MAX_SPEED*distance*0.5
	else:
		lungeAccel = 0
		forwardVel += speed*delta
		lungeSpeed = lerp(lungeSpeed, MAX_SPEED*distance*0.05, delta)
	forwardVel = clamp(forwardVel, MIN_SPEED, lungeSpeed)
	
func jerkBack():
	forwardVel += jerkBackSpeed
	lunge = false
	return distance-(jerkBackSpeed/2)

func lungeForward(trueFalse):
	lunge = trueFalse

func _on_Object_ready():
	$AnimationPlayer.play("appear")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "disappear":
		queue_free()
