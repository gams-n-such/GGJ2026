class_name Player
extends CharacterBody3D


@export var footstep_sound: Array[AudioStream]

@export var run_speed = 5.5
@export var speed = run_speed
@export var walk_speed = 3
@export var crouch_speed = 1.8

@export var jump_velocity = 7
var landing_velocity

var distance = 0
var footstep_distance = 2.1

var is_mouse_visible : bool = false 

@onready var interactor : PlayerInteractorBase = %Interactor
@onready var melee_attack : PlayerInteractorBase = %MeleeAttack
@onready var shooting_attack : PlayerInteractorBase = %ShootingAttack
@onready var healing_ray : PlayerInteractorBase = %HealingRay
var using_melee : bool = false
var active_weapon : PlayerInteractorBase:
	get:
		if active_mask == combat_mask:
			if using_melee:
				return melee_attack
			else:
				return shooting_attack
		elif active_mask == diagnostic_mask:
			return healing_ray
		else:
			return null

@onready var camera : Camera3D = %Camera3D

@onready var equipment_manager: EquipmentManager = %EquipmentManager

@onready var tracking_mask: Mask = %TrackingMask
@onready var diagnostic_mask: Mask = %DiagnosticMask
@onready var combat_mask: Mask = %CombatMask
var active_mask : Mask:
	get:
		if equipment_manager.current_equipment:
			if equipment_manager.current_equipment.can_be_used():
				return equipment_manager.current_equipment as Mask
		return null

func _ready() -> void:
	Game.player = self
	camera.cull_mask = Game.default_camera_layers
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x / 10
		%Camera3D.rotation_degrees.x -= event.relative.y / 10
		%Camera3D.rotation_degrees.x = clamp( %Camera3D.rotation_degrees.x, -90, 90 )
	elif event.is_action_pressed("Interact"):
		interactor.begin_interaction()
	elif event.is_action_pressed("Attack"):
		pass
	elif event.is_action_pressed("SwitchWeapon"):
		pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * 2 * delta
		landing_velocity = -velocity.y
		distance = 0

	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
		play_random_footstep_sound()

	if not $CeilingDetector.is_colliding():
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 1.85, 0.1)
	else:
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 1.38, 0.1)

	if is_on_floor():
		if landing_velocity != 0:
			landing_animation(landing_velocity)
			landing_velocity = 0

		speed = run_speed
		if Input.is_action_pressed("Crouch"):
			speed = crouch_speed
		else:
			if Input.is_action_pressed("Dash"):
				speed = run_speed
			elif Input.is_action_pressed("Walk"):
				speed = walk_speed

	if Input.is_action_pressed("Crouch"):
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 1.38, 0.1)

	$MeshInstance3D.mesh.height = $CollisionShape3D.shape.height
	%HeadPosition.position.y = $CollisionShape3D.shape.height - 0.25

	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	distance += get_real_velocity().length() * delta

	if distance >= footstep_distance:
		distance = 0
		if speed > walk_speed:
			play_random_footstep_sound()

	move_and_slide()


func landing_animation(landing_velocity):
	if landing_velocity >= 2:
		play_random_footstep_sound()

	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	var amplitude = clamp( landing_velocity / 100, 0.0, 0.3)

	tween.tween_property(%LandingAnimation, "position:y", -amplitude, amplitude)
	tween.tween_property(%LandingAnimation, "position:y", 0, amplitude)


func play_random_footstep_sound() -> void:
	if footstep_sound.size() > 0:
		$FootstepSound.stream = footstep_sound.pick_random()
		$FootstepSound.play()

func _on_health_value_changed(attribute: Attribute, new_value: float) -> void:
	print("HP: " + str(new_value))
	if new_value <= 0:
		$GUI/HUD.visible = false
		$GUI/DeathUI.visible = true
