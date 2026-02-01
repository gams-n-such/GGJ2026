extends AutoSizeLabel

func _process(delta: float) -> void:
	text = "collected capsules: " + str(Game.collected_parts + Game.delivered_vields) + "/" + str(Game.total_parts)
	pass
