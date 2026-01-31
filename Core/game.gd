extends Node

var player : Player


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugQuit"):
		get_tree().quit()

func start_game() -> void:
	load_gameplay_scene()
	reset_parts()

#region Collectibles

var collected_parts : int = 0
var delivered_parts : int = 0
var total_parts : int = 0

func reset_parts() -> void:
	collected_parts = 0
	delivered_parts = 0
	var collectibles := get_tree().get_nodes_in_group(Utils.group_collectible)
	for item in collectibles:
		pass

func collect_part() -> void:
	collected_parts += 1

func deliver_parts() -> void:
	delivered_parts += collected_parts
	collected_parts = 0
	check_win_conditions()

#endregion

#region Win Conditions

func check_win_conditions() -> void:
	# TODO: win conditions
	pass

func win() -> void:
	# TODO: game over screen
	pass

func loose() -> void:
	# TODO: game over screen
	pass

#endregion

#region Scenes

@export_category("Scenes")
@export var menu_scene : PackedScene
@export var gameplay_scene : PackedScene

func load_menu_scene() -> void:
	get_tree().change_scene_to_packed(menu_scene)

func load_gameplay_scene() -> void:
	get_tree().change_scene_to_packed(gameplay_scene)

#endregion
