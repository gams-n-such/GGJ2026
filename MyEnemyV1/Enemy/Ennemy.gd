extends CharacterBody3D

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var navigation: NavigationAgent3D = $NavigationAgent3D
@onready var raycast: RayCast3D = $RayCast3D

# Настройки обнаружения и движения
@export_range(10, 100, 1) var detect_distance: int = 30
@export_range(1, 10, 0.5) var move_speed: float = 3
@export_range(0.5, 20, 0.5) var stop_distance: float = 3.0  # Дистанция остановки перед игроком

# Настройки убегания
@export var can_flee: bool = false  # Может ли враг убегать
@export_range(5, 50, 1) var flee_distance: float = 15.0  # На какой дистанции начинает убегать
@export_range(20, 100, 1) var safe_distance: float = 40.0  # До какой дистанции убегает

# Настройки патрулирования
@export var can_wander: bool = true  # Может ли враг патрулировать
@export_range(5, 50, 1) var wander_radius: float = 20.0  # Радиус патрулирования
@export_range(2, 10, 0.5) var wander_speed: float = 1.5  # Скорость патрулирования
@export_range(1, 10, 0.5) var wander_wait_time: float = 3.0  # Время ожидания на точке

# Настройки атаки
@export_range(0.5, 5.0, 0.1) var attack_cooldown: float = 1.5  # Время между атаками в секундах
@export_range(0.0, 3.0, 0.1) var initial_attack_delay: float = 0.8  # Задержка перед первой атакой

var player
var current_state = "idle"  # idle, chase, flee, wander
var wander_target: Vector3
var wander_timer: float = 0.0
var wait_timer: float = 0.0

# Переменные для системы атаки
var attack_timer: float = 0.0  # Таймер кулдауна атаки
var can_attack: bool = false  # Может ли враг атаковать
var first_sight_timer: float = 0.0  # Таймер задержки первой атаки
var has_seen_player: bool = false  # Видел ли враг игрока хотя бы раз

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if can_wander:
		_set_new_wander_target()
	
	# Инициализируем систему атаки
	can_attack = false
	attack_timer = 0.0
	first_sight_timer = 0.0
	has_seen_player = false

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	var distance_to_player = position.distance_to(player.global_position)
	var can_see_player = _can_see_player()
	
	# Обрабатываем задержку первой атаки
	_update_attack_readiness(delta, can_see_player)
	
	# Определяем состояние врага
	_update_state(distance_to_player, can_see_player)
	
	# Выполняем действия в зависимости от состояния
	match current_state:
		"chase":
			_chase_player(delta)
		"flee":
			_flee_from_player(delta)
		"wander":
			_wander(delta)
		"idle":
			_idle(delta)
	
	# Поворачиваем врага в нужную сторону
	if current_state != "idle":
		if current_state == "flee":
			# При убегании смотрим от игрока
			var flee_look = global_position + (global_position - player.global_position)
			look_at(flee_look)
		else:
			look_at(player.global_position)
	
	# Проверяем атаку с кулдауном
	if raycast.is_colliding() and current_state == "chase" and can_attack:
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("Player"):
			_perform_attack()
	
	# Анимации
	if velocity.length() > 0.1:
		# play walk anim
		pass
	else:
		# play idle
		pass

func _update_attack_readiness(delta: float, sees_player: bool) -> void:
	# Если враг видит игрока впервые
	if sees_player and not has_seen_player:
		has_seen_player = true
		first_sight_timer = 0.0
		can_attack = false
	
	# Если враг потерял игрока из виду, сбрасываем готовность к атаке
	if not sees_player and has_seen_player:
		has_seen_player = false
		can_attack = false
		first_sight_timer = 0.0
		attack_timer = 0.0
	
	# Отсчитываем задержку до первой атаки
	if has_seen_player and not can_attack:
		first_sight_timer += delta
		if first_sight_timer >= initial_attack_delay:
			can_attack = true
			attack_timer = 0.0  # Сбрасываем таймер для первой атаки
	
	# Отсчитываем кулдаун атаки
	if attack_timer > 0.0:
		attack_timer -= delta

func _perform_attack() -> void:
	# Проверяем, прошел ли кулдаун
	if attack_timer <= 0.0:
		print("Enemy attacking!")
		Utils.deal_damage(player, 1)
		
		# Устанавливаем кулдаун
		attack_timer = attack_cooldown

func _update_state(distance: float, can_see: bool) -> void:
	if can_flee and can_see and distance <= flee_distance:
		# Если враг может убегать и игрок слишком близко - убегаем
		current_state = "flee"
	elif can_see and distance <= detect_distance and distance > stop_distance:
		# Если видим игрока в пределах обнаружения, но дальше дистанции остановки - преследуем
		current_state = "chase"
	elif can_see and distance <= stop_distance:
		# Если игрок очень близко - останавливаемся
		current_state = "idle"
	elif not can_see and can_wander:
		# Если не видим игрока и можем патрулировать - патрулируем
		current_state = "wander"
	else:
		current_state = "idle"

func _chase_player(delta: float) -> void:
	navigation.set_target_position(player.global_position)
	var destination = navigation.get_next_path_position()
	var direction = (destination - global_position).normalized()
	
	velocity = direction * move_speed
	move_and_slide()

func _flee_from_player(delta: float) -> void:
	# Убегаем в противоположную от игрока сторону
	var flee_direction = (global_position - player.global_position).normalized()
	var flee_target = global_position + flee_direction * safe_distance
	
	navigation.set_target_position(flee_target)
	var destination = navigation.get_next_path_position()
	var direction = (destination - global_position).normalized()
	
	velocity = direction * move_speed
	move_and_slide()

func _wander(delta: float) -> void:
	var distance_to_wander = global_position.distance_to(wander_target)
	
	# Если достигли точки патрулирования
	if distance_to_wander < 1.5:
		wait_timer += delta
		velocity = Vector3.ZERO
		
		# Ждем, затем выбираем новую точку
		if wait_timer >= wander_wait_time:
			_set_new_wander_target()
			wait_timer = 0.0
	else:
		# Двигаемся к точке патрулирования
		navigation.set_target_position(wander_target)
		var destination = navigation.get_next_path_position()
		var direction = (destination - global_position).normalized()
		
		velocity = direction * wander_speed
		move_and_slide()

func _idle(delta: float) -> void:
	velocity = Vector3.ZERO

func _set_new_wander_target() -> void:
	# Генерируем случайную точку в радиусе патрулирования
	var random_angle = randf() * TAU
	var random_distance = randf() * wander_radius
	
	wander_target = global_position + Vector3(
		cos(random_angle) * random_distance,
		0,
		sin(random_angle) * random_distance
	)

func _can_see_player() -> bool:
	# Проверяем, видит ли враг игрока с помощью raycast
	raycast.target_position = to_local(player.global_position)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		# Возвращаем true только если луч попал в игрока
		return collider.is_in_group("Player")
	
	return false
