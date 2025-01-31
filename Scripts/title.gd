extends Control

const baseSave = {
	"name": "New Airline",
	"money": 500000000,
	"aircraft": [
		{
			"name": "Bombardier Q400",
			"code": "q400",
			"amount": 2,
			"maxRouteStyle": 1,
			"baseRate": 200,
			"price": 20000000
		},
		{
			"name": "Bombardier CRJ900",
			"code": "crj9",
			"amount": 0,
			"maxRouteStyle": 1,
			"baseRate": 350,
			"price": 75000000
		},
		{
			"name": "Airbus A321XLR",
			"code": "a21x",
			"amount": 0,
			"maxRouteStyle": 2,
			"baseRate": 500,
			"price": 140000000
		},
		{
			"name": "Boeing 787-9",
			"code": "b787",
			"amount": 0,
			"maxRouteStyle": 3,
			"baseRate": 800,
			"price": 300000000
		},
		{
			"name": "Airbus A350-1000",
			"code": "a350",
			"amount": 0,
			"maxRouteStyle": 4,
			"baseRate": 1000,
			"price": 350000000
		},
		{
			"name": "Boeing 747-8i",
			"code": "b747",
			"amount": 0,
			"maxRouteStyle": 3,
			"baseRate": 2000,
			"price": 400000000
		}
	],
	"airports": [
		{
			"code": "SFO",
			"name": "San Francisco Int'l",
			"slot": true,
			"cost": 0,
			"mult": 1.0,
			"distance": 0
		},
				{
			"code": "YYC",
			"name": "Calgary Int'l",
			"slot": false,
			"cost": 1000000,
			"mult": 1.2,
			"distance": 1
		},
		{
			"code": "YVR",
			"name": "Vancouver Int'l",
			"slot": false,
			"cost": 2000000,
			"mult": 1.4,
			"distance": 1
		},
		{
			"code": "YYZ",
			"name": "Toronto Pearson Int'l",
			"slot": false,
			"cost": 7000000,
			"mult": 1.4,
			"distance": 2
		},
		{
			"code": "LAX",
			"name": "Los Angeles Int'l",
			"slot": false,
			"cost": 10000000,
			"mult": 1.8,
			"distance": 1
		},
		{
			"code": "LHR",
			"name": "London Heahrow Int'l",
			"slot": false,
			"cost": 50000000,
			"mult": 2,
			"distance": 3
		},
		{
			"code": "SIN",
			"name": "Singapore Changi Int'l",
			"slot": false,
			"cost": 100000000,
			"mult": 2.2,
			"distance": 4
		}
	]
}

const save_path = "user://flightbase/save.json"

var saveData

func _ready():
	pass

func _process(delta):
	pass

func _on_start_button_up():
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("flightbase"):
		dir.make_dir("flightbase")
	
	if FileAccess.file_exists(save_path):
		print("File found")
		saveData = FileAccess.open(save_path, FileAccess.READ).get_as_text()
		
		saveData = JSON.parse_string(saveData)
		
	else:
		print("Creating new save")
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		if file:
			var json_string = JSON.stringify(baseSave)
			file.store_string(json_string)
			file.close()
			saveData = baseSave
			print("Save file created successfully")
		else:
			print("Error creating save file")
	Global.setSave(saveData)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_reset_button_up():
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("flightbase"):
		dir.make_dir("flightbase")
	
	if FileAccess.file_exists(save_path):
		print("Creating new save")
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		if file:
			var json_string = JSON.stringify(baseSave)
			file.store_string(json_string)
			file.close()
			saveData = baseSave
			print("Save file created successfully")
		else:
			print("Error creating save file")
