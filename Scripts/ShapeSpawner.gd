extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var distance = 20
var listOfPos = []
var shapes = []
const SPEED = 0.8
const backSpeed = -8

var forwardVel = 0


var maxDistance = distance

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(50):
		spawnShape(distance)
	
	set_physics_process(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	for shape in shapes:
		shape.moveForward(delta)
	
func jerkBackAll():
	maxDistance = 0
	for shape in shapes:
		var temp = shape.jerkBack()
		if maxDistance < temp:
			maxDistance = temp

func spawnShape(dist):
	var shapeNames = ["res://ItemScenes/Sphere.tscn",
					"res://ItemScenes/Triangle.tscn",
					"res://ItemScenes/Cube.tscn"]
					
	var shape = load(shapeNames[randi()%len(shapeNames)])
	var s = shape.instance()
	s = placeShape(s, dist)
	add_child(s)
	shapes.append(s)
	pass

func placeShape(shape, distanceFromCenter):
	var randNum = rand_range(PI*-2, PI*2)
	var y = rand_range(-1, 1)
	var r = sqrt(1-y*y)
	var x = r * sin(randNum)
	var z = r * cos(randNum)
	
	var step = 5
	
	var temp = distanceFromCenter*Vector3(x, y, z)
	
	temp = Vector3(stepify(temp.x, step), stepify(temp.y, step), stepify(temp.z, step))
	
	while true:
		if listOfPos.find(temp)==-1:
			shape.translation = distanceFromCenter*Vector3(x, y, z)	
			break
		else:
			print("repeater")
			randNum = rand_range(PI*-2, PI*2)
			y = rand_range(-1, 1)
			r = sqrt(1-y*y)
			x = r * sin(randNum)
			z = r * cos(randNum)
			temp = distanceFromCenter*Vector3(x, y, z)
			temp = Vector3(stepify(temp.x, 2), stepify(temp.y, 2), stepify(temp.z, 2))
			
	
	return shape
	
	
	
	
	
	
func _on_spawnTimer_timeout():
	for x in range(5):
		spawnShape(maxDistance)

func _on_rampUpSpeed_timeout():
	for shape in shapes:
		shape.MAX_SPEED += 0.01
