extends Node

const SAVE_PATH = "user://savegame.json"

func save_game():
	var save_dict = GameState.get_save_data()
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_dict)
		file.store_string(json_string)
		print("Game Saved")
	else:
		print("Error saving game")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			var data = json.get_data()
			GameState.load_save_data(data)
			print("Game Loaded")
		else:
			print("JSON Parse Error: ", json.get_error_message())
	else:
		print("Error loading game file")
