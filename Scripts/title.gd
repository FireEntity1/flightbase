extends Control

const baseSave = {
	"name": "",
	"money": 20000000,
	"aircraft": [
		{
			"name": "Bombardier Q400",
			"code": "q400",
			"amount": 2,
			"range": 1,
			"baseRate": 200,
			"price": 20000000
		},
		{
			"name": "Bombardier CRJ900",
			"code": "crj9",
			"amount": 0,
			"range": 1,
			"baseRate": 400,
			"price": 75000000
		},
		{
			"name": "Airbus A321XLR",
			"code": "a21x",
			"amount": 0,
			"range": 2,
			"baseRate": 800,
			"price": 140000000
		},
		{
			"name": "Boeing 787-9",
			"code": "b787",
			"amount": 0,
			"range": 3,
			"baseRate": 1500,
			"price": 300000000
		},
		{
			"name": "Airbus A350-1000",
			"code": "a350",
			"amount": 0,
			"range": 4,
			"baseRate": 2500,
			"price": 350000000
		},
		{
			"name": "Boeing 747-400",
			"code": "b747",
			"amount": 0,
			"range": 3,
			"baseRate": 4000,
			"price": 400000000
		}
	],
	"airports": [
		{
			"code": "SFO",
			"name": "San Francisco Int'l",
			"slot": true,
			"cost": 0,
			"mult": 0,
			"distance": 0
		},
		{
			"code": "YYC",
			"name": "Calgary Int'l",
			"slot": true,
			"cost": 1000000,
			"mult": 0.8,
			"distance": 1
		},
		{
			"code": "YVR",
			"name": "Vancouver Int'l",
			"slot": false,
			"cost": 2000000,
			"mult": 1.2,
			"distance": 1
		},
		{
			"code": "YYZ",
			"name": "Toronto Pearson Int'l",
			"slot": false,
			"cost": 7000000,
			"mult": 1.5,
			"distance": 2
		},
		{
			"code": "LAX",
			"name": "Los Angeles Int'l",
			"slot": false,
			"cost": 10000000,
			"mult": 2,
			"distance": 1
		},
		{
			"code": "JFK",
			"name": "John F. Kennedy Int'l",
			"slot": false,
			"cost": 10000000,
			"mult": 2.4,
			"distance": 3
		},
		{
			"code": "LHR",
			"name": "London Heahrow Int'l",
			"slot": false,
			"cost": 50000000,
			"mult": 3,
			"distance": 3
		},
		{
			"code": "FRA",
			"name": "Frankfurt Int'l",
			"slot": false,
			"cost": 70000000,
			"mult": 3.4,
			"distance": 3
		},
		{
			"code": "SIN",
			"name": "Singapore Changi Int'l",
			"slot": false,
			"cost": 150000000,
			"mult": 5,
			"distance": 4
		}
	]
}

const save_path = "user://flightbase/save.json"

var fade = false
var saveData

func _ready():
	pass

func _process(delta):
	if fade:
		$fade.color.a += delta*1.5
	elif not fade and $fade.color.a > 0:
		$fade.color.a -= delta*1.5

func _on_start_button_up():
	$select.play()
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
	fade = true
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_reset_button_up():
	$select.play()
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
