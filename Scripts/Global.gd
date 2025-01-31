extends Node

const save_path = "user://flightbase/save.json"

var saveData

func _ready():
	pass

func _process(delta):
	pass

func setSave(save):
	saveData = save
	write()

func getSave():
	return saveData

func modMoney(amt):
	saveData.money += amt

func getMoney():
	return saveData.money

func write():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path,FileAccess.WRITE)
		var json_string = JSON.stringify(saveData)
		file.store_string(json_string)
		file.close()
