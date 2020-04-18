extends Spatial

const RAYCAST_DISTANCE = 1000
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var clicked = false
var selectedObject = null
var mousePos = Vector2(0,0)
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

func _input(event):
	mouseRayCastCheck(event)
	

func raycastFromMousePosToObject():
	mousePos = get_viewport().get_mouse_position()
	$MouseRayCast.global_transform.origin = $Camera.project_ray_origin(mousePos)
	$MouseRayCast.cast_to = $Camera.project_ray_normal(mousePos) * RAYCAST_DISTANCE
	if $MouseRayCast.is_colliding():
		var object = $MouseRayCast.get_collider()
		return object
	else:
		return null
		
func mouseRayCastCheck(event):
	if event is InputEventMouseMotion:
		selectedObject = raycastFromMousePosToObject()

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
