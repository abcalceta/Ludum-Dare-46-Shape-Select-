extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var distance = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(50):
		spawnShape()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawnShape():
	var shape = load("res://ItemScenes/Sphere.tscn")
	var s = shape.instance()
	s = placeShape(s, distance)
	add_child(s)
	pass

func placeShape(shape, distanceFromCenter):
	var randNum = rand_range(PI*-2, PI*2)
	var y = rand_range(-1, 1)
	var r = sqrt(1-y*y)
	var x = r* sin(randNum)
	var z = r* cos(randNum)
	shape.translation = distanceFromCenter*Vector3(x, y, z)
	return shape
	
	
