extends Node

# Call this function with the path to your JSON file
func load_dialogue(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: %s" % path)
		return []

	var text = file.get_as_text()
	file.close()

	var json = JSON.new()
	json.parse(text)

	if typeof(json.data) != TYPE_ARRAY:
		push_error("JSON is not an array!")
		return []

	return json.data
