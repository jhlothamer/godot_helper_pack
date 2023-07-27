class_name FileUtil
extends Object


static func load_text(file_path: String, default_value: String = "") -> String:
	var data_file := FileAccess.open(file_path, FileAccess.READ)
	if !data_file:
		return default_value
	var contents = data_file.get_as_text()
	data_file.close()
	return contents


static func save_text(file_path: String, contents: String) -> bool:
	var data_file := FileAccess.open(file_path, FileAccess.WRITE)
	if !data_file:
		data_file.close()
		return false
	data_file.store_string(contents)
	data_file.close()
	return true


static func load_json_data(file_path: String, default_value = {}) -> Dictionary:
	var json_text = load_text(file_path)
	if json_text == "":
		return default_value
	var test_json_conv = JSON.new()
	if OK != test_json_conv.parse(json_text):
		print("error parsing data: %s" % test_json_conv.get_error_message())
		print(test_json_conv.get_error_line())
		return default_value
	return test_json_conv.data


static func save_json_data(file_path: String, data: Dictionary, delim: String = "") -> void:
	var json_string = JSON.stringify(data, delim)
	save_text(file_path, json_string)


static func load_var_data(file_path: String):
	var text_data = load_text(file_path)
	if text_data == null:
		return text_data
	return str_to_var(text_data)


static func save_var_data(file_path, data) -> void:
	var data_string = var_to_str(data)
	save_text(file_path, data_string)

