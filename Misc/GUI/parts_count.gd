extends AutoSizeLabel

func _process(delta: float) -> void:
	text = "parts finded : "  + str(Game.collected_vials + Game.delivered_vields) + "/" + str(Game.total_vials)
	pass
