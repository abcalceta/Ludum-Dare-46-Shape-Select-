extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var colorName = "white"
var colorColor = Color("#0000FF")
var type = "sphere"
var material = null

# Called when the node enters the scene tree for the first time.
func _ready():
	colorName = globals.getRandomColorName()
	colorColor = globals.getColorFromName(colorName)
	
	#$StaticBody/CollisionShape/mesh.material.duplicate()
	var mesh = get_child(0).get_child(0)
	material = mesh.mesh.surface_get_material(0).duplicate()
	material.set("albedo_color", Color(colorColor))
	mesh.set("material/0", material)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
