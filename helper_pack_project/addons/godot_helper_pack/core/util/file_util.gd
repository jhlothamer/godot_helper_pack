class_name FileUtil
extends Object
"""
Collection of file utility functions.
"""

static func load_text(file_path: String) -> String:
	var data_file: File = File.new()
	var error = data_file.open(file_path, File.READ)
	if error != OK:
		print("error opening data file")
		data_file.close()
		return ""
	var contents = data_file.get_as_text()
	data_file.close()
	return contents

static func load_json_data(file_path: String) -> Dictionary:
	pass
	var json_text = load_text(file_path)
	if json_text == "":
		return {}
	var parse_results:JSONParseResult =  JSON.parse(json_text)
	if parse_results.error != OK:
		print("error parsing data.")
		print(parse_results.error_string)
		print(parse_results.error_line)
		return {}
	return parse_results.result

