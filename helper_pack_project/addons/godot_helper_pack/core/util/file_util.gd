class_name FileUtil
extends Object


static func load_text(file_path: String, default_value: String = "") -> String:
	var data_file: File = File.new()
	var error = data_file.open(file_path, File.READ)
	if error != OK:
		data_file.close()
		return default_value
	var contents = data_file.get_as_text()
	data_file.close()
	return contents


static func save_text(file_path: String, contents: String, create_file: bool = true) -> int:
	var data_file: File = File.new()
	var error = data_file.open(file_path, File.WRITE)
	if error != OK:
		data_file.close()
		return error
	data_file.store_string(contents)
	data_file.close()
	return OK


static func load_json_data(file_path: String, default_value = {}) -> Dictionary:
	var json_text = load_text(file_path)
	if json_text == "":
		return default_value
	var parse_results:JSONParseResult =  JSON.parse(json_text)
	if parse_results.error != OK:
		print("error parsing data: %s" % parse_results.error_string)
		print(parse_results.error_string)
		print(parse_results.error_line)
		return default_value
	return parse_results.result


static func save_json_data(file_path: String, data: Dictionary, delim: String = "") -> void:
	var json_string = JSON.print(data, delim)
	save_text(file_path, json_string)


static func load_var_data(file_path: String):
	var text_data = load_text(file_path)
	if !text_data:
		return text_data
	return str2var(text_data)


static func save_var_data(file_path, data) -> void:
	var data_string = var2str(data)
	save_text(file_path, data_string)

