extends Node

@export_flags_3d_render var default_camera_layers 

var player : Player

func _ready() -> void:
	reset_collectibles()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugQuit"):
		quit_to_desktop()
	elif event.is_action_pressed("DebugCursor"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_VISIBLE

func start_game() -> void:
	load_gameplay_scene()
	reset_collectibles()

func quit_to_title() -> void:
	load_menu_scene()

func quit_to_desktop() -> void:
	get_tree().quit()

#region Collectibles

var collected_parts : int = 0
var delivered_parts : int = 0
var total_parts : int = 0

func collect_part() -> void:
	collected_parts += 1

var collected_vials : int = 0
var delivered_vials : int = 0
var total_vials : int = 0

func collect_vial() -> void:
	collected_vials += 1

func reset_collectibles() -> void:
	collected_parts = 0
	delivered_parts = 0
	total_parts = 0
	collected_vials = 0
	delivered_vials = 0
	total_vials = 0
	var collectibles := get_tree().get_nodes_in_group(Utils.group_collectible)
	for item in collectibles:
		if item.is_in_group(Utils.group_parts):
			total_parts += 1
		if item.is_in_group(Utils.group_vials):
			total_vials += 1

func deliver_collectibles() -> void:
	delivered_parts += collected_parts
	collected_parts = 0
	delivered_vials += collected_vials
	collected_vials = 0
	check_win_conditions()

#endregion

#region Win Conditions

func check_win_conditions() -> void:
	if delivered_parts >= total_parts and delivered_vials >= total_vials:
		win()

func win() -> void:
	# TODO: game over screen
	pass

func loose() -> void:
	# TODO: game over screen
	player.game_over()
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
