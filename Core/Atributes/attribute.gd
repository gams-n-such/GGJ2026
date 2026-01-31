class_name Attribute
extends Node

# TODO: add old_value
signal value_changed(attribute : Attribute, new_value : float)

@export var _starting_value : float = 1.0

var _base_value : float = 1.0
var base_value : float:
	get:
		return _base_value
	set(value):
		_base_value = value
		if has_min_value:
			_base_value = max(min_value, _base_value)
		if has_max_value:
			_base_value = min(max_value, _base_value)
		recalculate_value()

@export var has_min_value : bool = true
@export var min_value : float = 0.0
@export var has_max_value : bool = false
@export var max_value : float = 1.0

var _current_value : float = base_value
var value : float:
	get:
		return _current_value

var percent : float:
	get:
		if has_max_value:
			# TODO: subtract min value
			return value / max_value
		else:
			# FIXME: undefined
			return 1.0

func _init() -> void:
	base_value = _starting_value

func _ready() -> void:
	pass

func get_active_modifiers() -> Array[AttributeMod]:
	var result : Array[AttributeMod]
	result.assign(get_children())
	return result

func recalculate_value():
	var total_flat_bonus : float = 0
	var total_percent_bonus : float = 0
	for mod in get_active_modifiers():
		match mod.type:
			AttributeModInfo.ModType.ADD_FLAT:
				total_flat_bonus += mod.value
			AttributeModInfo.ModType.ADD_PERCENT:
				total_percent_bonus += mod.value
	var new_value = base_value * max(0.0, 1.0 + total_percent_bonus) + total_flat_bonus
	if has_min_value:
		new_value = max(min_value, new_value)
	if has_max_value:
		new_value = min(max_value, new_value)
	_current_value = new_value
	# FIXME: only emit if actually changed
	value_changed.emit(self, value)

func add_modifier(mod_info : AttributeModInfo) -> AttributeMod:
	var new_mod = AttributeMod.new()
	new_mod.info = mod_info
	add_child(new_mod)
	recalculate_value()
	return new_mod

func remove_modifier(mod : AttributeMod):
	if is_ancestor_of(mod):
		mod.queue_free()
		recalculate_value()

func add_instant(delta : float):
	base_value += delta
