extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getRandomColorName():
	var colorNameList = ["red", "orange", "yellow", "green", "blue", "violet", "pink", "white", "black", "gray"]
	var colorName = colorNameList[randi()%len(colorNameList)]
	return colorName


func getColorFromName(colorName):
	var degrees = 0
	
	if colorName == "red":
		degrees = 0
	elif colorName == "orange":
		degrees = 15
	elif colorName == "yellow":
		degrees = 50
	elif colorName == "green":
		degrees = 100
	elif colorName == "blue":
		degrees = 200
	elif colorName == "violet":
		degrees = 270
	elif colorName == "pink":
		degrees = 310
	
	var colorMin = ( (degrees) - (0) ) / (360.0 - (0))
	var colorMax = ( (degrees+5) - (0) ) / (360.0 - (0))
	
	var colorRange = rand_range(colorMin, colorMax)
	print(degrees, " ", colorMin, colorMax, colorRange)
	var hue = colorRange
	
	
	var saturation = rand_range(0.8,1.0)
	if colorName == "black" or colorName == "gray" or colorName == "white":
		saturation = 0
	
	
	var brightness = rand_range(0.5,1.0)
	
	if colorName == "black":
		brightness = 0.1
	if colorName == "gray":
		brightness = 0.5
	if colorName == "white":
		brightness = 0.9
	
	
	
	if colorName == "red":
		brightness = rand_range(0.5,1.0)
	elif colorName == "orange":
		brightness = rand_range(0.5,1.0)
	elif colorName == "yellow":
		brightness = rand_range(0.8,1.0)
	elif colorName == "green":
		brightness = rand_range(0.5,1.0)
	elif colorName == "blue":
		brightness = rand_range(0.5,1.0)
	elif colorName == "violet":
		brightness = rand_range(0.3,0.7)
	elif colorName == "pink":
		brightness = rand_range(0.7,1.0)
	
	
	
	var color = Color.from_hsv(hue, saturation, brightness)
	return color
	
	
