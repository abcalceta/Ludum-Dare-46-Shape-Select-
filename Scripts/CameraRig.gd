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
