class_name FileUtil
extends Object
"""
Collection of file utility functions.
"""

static func load_text(file_path: String) -> String:
	var data_file: File = File.new()
	var error = data_file.open(file_path, File.READ)
	if error != OK:
		printerr("error opening data file.\r\nError code: %d" % error)
		data_file.close()
		return ""
	var contents = data_file.get_as_text()
	data_file.close()
	return contents

static func load_json_data(file_path: String) -> Dictionary:
	var json_text = load_text(file_path)
	if json_text == "":
		return {}
	var parse_results:JSONParseResult =  JSON.parse(json_text)
	if parse_results.error != OK:
		printerr("error parsing data")
		printerr("error: %s" % parse_results.error_string)
		printerr("on line: %d" % parse_results.error_line)
		return {}
	return parse_results.result

