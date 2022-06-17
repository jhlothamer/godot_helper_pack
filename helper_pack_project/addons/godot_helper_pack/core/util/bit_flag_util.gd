class_name BitFlagUtil
extends Object


static func get_bit(value: int, bit_number: int) -> bool:
	return (value & (1 << (bit_number - 1))) > 0


static func set_bit(value: int, bit_number: int, bit_value: bool) -> int:
	var temp = 1 << (bit_number - 1)
	if bit_value:
		return value | temp
	temp = ~temp
	return value & temp
