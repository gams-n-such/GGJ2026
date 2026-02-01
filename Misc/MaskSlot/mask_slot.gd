class_name MaskSlot
extends Control

enum mask_type {blue, red,white}

@onready var icon: TextureRect = $icon

@export var mask : mask_type = mask_type.white

@onready var mask_hots := [$HBoxContainer/Hot/BluemaskIcon,
$HBoxContainer/Hot2/RedmaskIcon,
$HBoxContainer/Hot3/GreenmaskIcon
]
const MASK_BLUE = preload("uid://347lrplpcwiw")
const MASK_RED = preload("uid://dxeu5ljjtxg41")
const MASK_WHITE = preload("uid://fffulgw8jjbh")

var mask_icons = [MASK_BLUE,MASK_RED,MASK_WHITE]
func _ready() -> void:
	icon.texture = mask_icons[mask]
	mask_hots[mask].visible = true

func Activate(change_to_mask : mask_type):
	print("activating mask with index: " + str(change_to_mask))
	for i in mask_hots.size():
		mask_hots[i].visible= false
	
	mask_hots[change_to_mask].visible = true
	icon.texture = mask_icons[change_to_mask]
