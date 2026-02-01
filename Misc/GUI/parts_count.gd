extends AutoSizeLabel

func _process(delta: float) -> void:
	text = "parts finded : "  + str(Game.collected_vials + Game.delivered_vials) + "/" + str(Game.total_vials)
	pass
