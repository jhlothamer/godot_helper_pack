extends Node2D


@onready var _rand_dist_area: RandomDistributionArea = $RandomDistributionArea


func _on_repopulateBtn_pressed():
	_rand_dist_area.do_distribution()
