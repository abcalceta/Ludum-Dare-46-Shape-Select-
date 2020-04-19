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

func lungeForward():
	$lungeTimer.start()
	for shape in shapes:
		var temp = shape.lungeForward(true)

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
	
	
func spawnSpecificShape(typeNum, color, dist):
	var shapeNames = ["res://ItemScenes/Sphere.tscn",
					"res://ItemScenes/Triangle.tscn",
					"res://ItemScenes/Cube.tscn"]
	var shape = load(shapeNames[typeNum])
	shape.colorName = color
	shape.colorColor = globals.getColorFromName(shape.colorName)
	var s = shape.instance()
	s = placeShape(s, dist)
	add_child(s)
	shapes.append(s)
	
func placeShape(shape, distanceFromCenter):
	var randNum = rand_range(PI*-2, PI*2)
	var y = rand_range(-1, 1)
	var r = sqrt(1-y*y)
	var x = r * sin(randNum)
	var z = r * cos(randNum)
	
	var step = 7
	
	var temp = distanceFromCenter*Vector3(x, y, z)
	
	temp = Vector3(stepify(temp.x, step), stepify(temp.y, step), stepify(temp.z, step))
	var count = 0
	while true:
		if count>=5 or listOfPos.find(temp)==-1:
			listOfPos.append(temp)
			shape.translation = distanceFromCenter*Vector3(x, y, z)	
			break
		else:
			count += 1
			print("repeater")
			randNum = rand_range(PI*-2, PI*2)
			y = rand_range(-1, 1)
			r = sqrt(1-y*y)
			x = r * sin(randNum)
			z = r * cos(randNum)
			temp = distanceFromCenter*Vector3(x, y, z)
			temp = Vector3(stepify(temp.x, step), stepify(temp.y, step), stepify(temp.z, step))
			
	
	return shape
	
	
	
	
	
	
func _on_spawnTimer_timeout():
	listOfPos = []
	for x in range(1):
		spawnShape(maxDistance)

func _on_rampUpSpeed_timeout():
	for shape in shapes:
		shape.MAX_SPEED += 0.01

func _on_lungeTimer_timeout():
	for shape in shapes:
		var temp = shape.lungeForward(false)
