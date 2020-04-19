extends Spatial

const RAYCAST_DISTANCE = 1000
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var camera = $Outer/Inner/Camera
var clicked = false
var selectedObject = null
var mousePos = Vector2(0,0)
#var mouseMotion = Vector3(0,0,0)
#var mouseSpeed = 0.1
var velY = 0
var velX = 0
const SPEED = 0.5

var shakeDistance = 0.5

signal cameraHit


var shakeAmount = Vector3(0,0,0)



# Called when the node enters the scene tree for the first time.
func _ready():
	hideObjectDesc()
	set_physics_process(1)
	pass # Replace with function body.

func _physics_process(delta):
	
	if selectedObject:
		showObjectDesc(selectedObject)
	else:
		hideObjectDesc()
	
	mouseRayCastCheck()	
	if Input.is_action_pressed("left"):
		velY += 1*SPEED*delta
	if Input.is_action_pressed("right"):
		velY -= 1*SPEED*delta
	if Input.is_action_pressed("up"):
		velX += 1*SPEED*delta
	if Input.is_action_pressed("down"):
		velX -= 1*SPEED*delta
		
	moveCamera(delta)
	
	#Screen Shake
	if $ScreenShakeTimer.time_left > 0:
		$Outer/Inner/Camera.translation.x = lerp($Outer/Inner/Camera.translation.x, shakeAmount.x, delta)
		$Outer/Inner/Camera.translation.y = lerp($Outer/Inner/Camera.translation.y, shakeAmount.y, delta)
		$Outer/Inner/Camera.translation.z = lerp($Outer/Inner/Camera.translation.z, shakeAmount.z, delta)
		if $ShakeTimer.time_left == 0:
			$ShakeTimer.start()
	else:
		$Outer/Inner/Camera.translation.x = lerp($Outer/Inner/Camera.translation.x, 0, delta)
		$Outer/Inner/Camera.translation.y = lerp($Outer/Inner/Camera.translation.y, 0, delta)
		$Outer/Inner/Camera.translation.z = lerp($Outer/Inner/Camera.translation.z, 0, delta)
	shakeDistance = clamp(shakeDistance- (0.1 * delta), 0.5, 1.5)
	

func raycastFromMousePosToObject():
	mousePos = get_viewport().get_mouse_position()
	$MouseRayCast.global_transform.origin = camera.project_ray_origin(mousePos)
	$MouseRayCast.cast_to = camera.project_ray_normal(mousePos) * RAYCAST_DISTANCE
	
	if $MouseRayCast.is_colliding():
		var object = $MouseRayCast.get_collider()
		return object
	else:
		return null
		
func mouseRayCastCheck():
	selectedObject = raycastFromMousePosToObject()


func moveCamera(delta):
	var slowDown = 10
	velY = lerp(velY, 0, slowDown*delta)
	$Outer.rotate_y(velY)
	velX = lerp(velX, 0, slowDown*delta)
	#print($Outer/Inner.rotation_degrees.x)
	if $Outer/Inner.rotation_degrees.x <= 90:
		if $Outer/Inner.rotation_degrees.x <= -90:
			velX = 0
			$Outer/Inner.rotation_degrees.x = -89
		else:	
			$Outer/Inner.rotate_x(velX)
	else:
		velX = 0
		$Outer/Inner.rotation_degrees.x = 90


func showObjectDesc(object):
	$ObjectDesc.show()
	$ObjectDesc.setLabel(object)
	$ObjectDesc.rect_position = mousePos #$Camera.unproject_position(object.global_transform.origin)		

func hideObjectDesc():
	$ObjectDesc.hide()
	

func mouseClicks():
	if Input.is_action_pressed("click"):	
		selectedObject = raycastFromMousePosToObject()
		if selectedObject != null:
			clicked = true
		else:
			clicked = false
	if Input.is_action_just_released("click"):
		clicked = false
		selectedObject = null


func _on_Area_body_entered(body):
	emit_signal("cameraHit")
	#get_tree().paused = true


func shakeScreen(amount=25):
	$ScreenShakeTimer.wait_time = amount/100.0
	$ScreenShakeTimer.start()
	shake()
	if $ScreenShakeTimer.time_left>0:
		shakeDistance += 0.25

func shake():
	shakeAmount = Vector3(rand_range(-shakeDistance,shakeDistance),rand_range(-shakeDistance,shakeDistance),rand_range(-shakeDistance,shakeDistance))

func _on_ShakeTimer_timeout():
	shake()
