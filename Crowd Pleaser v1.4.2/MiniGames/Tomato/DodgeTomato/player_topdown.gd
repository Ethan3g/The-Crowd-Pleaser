extends CharacterBody2D

@export var speed = 300
@export var startHP = 3
@onready var hp = startHP
var can_take_damage = true
signal been_hit

@onready var HitTextur = load("res://Assets/cry.tres")
@onready var AliveTextur = load("res://Assets/guy.tres")

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)

func take_damage():
	if can_take_damage:
		print("Player took damage!")  # Debugging message
		can_take_damage = false
		hp -= 1
		$TomHitSfx.play()
		
		# Sprite change
		$AnimatedSprite2D.texture = HitTextur
		been_hit.emit()
		
		# Start cooldown timer
		$DamageCooldown.start()
		
		# Check if HP reaches zero
		game_over()
	else:
		print("Player is immune and can't take damage.")  # Debugging message

func _on_damage_cooldown_timeout() -> void:
	print("Damage cooldown ended, can take damage again!")  # Debugging message
	can_take_damage = true

func _ready():
	print("Player initialized, resetting damage immunity.")  # Debugging message
	hp = startHP
	can_take_damage = true  # Ensure damage can be taken
	$AnimatedSprite2D.texture = AliveTextur
	
	# Reset the cooldown timer
	$DamageCooldown.stop()
	
	# Ensure the timer is properly connected
	if not $DamageCooldown.timeout.is_connected(_on_damage_cooldown_timeout):
		$DamageCooldown.timeout.connect(_on_damage_cooldown_timeout, CONNECT_DEFERRED)

func game_over():
	print("Game Over!")
	print("Can Take Damage Before Reset:", can_take_damage)  # Debugging message
	
	# Manually reset before reloading
	can_take_damage = true  
	
	# Reload the scene to fully reset
	get_tree().reload_current_scene()
