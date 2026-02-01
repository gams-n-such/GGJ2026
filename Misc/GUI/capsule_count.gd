extends AutoSizeLabel

func _process(delta: float) -> void:
	text = "collected capsules: " + str(Game.collected_vials + Game.delivered_vials) + "/" + str(Game.total_vials)
	pass
