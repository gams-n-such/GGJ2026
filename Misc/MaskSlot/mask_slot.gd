class_name MaskSlot
extends Control

enum mask_type {blue, red,white}

@onready var icon: TextureRect = $icon

@export var mask : mask_type = mask_type.white

var mask_icons := [preload("uid://347lrplpcwiw"), 
preload("uid://dxeu5ljjtxg41"), 
preload("uid://fffulgw8jjbh")
]

func _ready() -> void:
	icon.texture = mask_icons[mask]


func Activate(change_to_mask : mask_type):
	print("activating mask with index: " + str(change_to_mask))
	for i in $Hot.get_child_count():
		$Hot.get_child(i).visible = false
	$Hot.get_child(change_to_mask).visible = true
