extends CharacterBody2D

# Movement speed in pixels per second.
@export var speed = 300
@export var startHP = 3
@onready var hp = startHP
var can_take_damage = true
signal been_hit

@onready var HitTextur = load("res://Assets/cry.tres")
@onready var AliveTextur = load("res://Assets/guy.tres")

# Implement movement borders
func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)

# Called when the player takes damage
func take_damage():
	if can_take_damage:
		can_take_damage = false
		hp -= 1
		$TomHitSfx.play()
		print("ow")
		
		#Sprite change
		$AnimatedSprite2D.texture = HitTextur
		
		been_hit.emit()
		
		# Start the cooldown timer after taking damage
		$DamageCooldown.start()

		# Check if HP reaches zero
		game_over()
		#if hp <= 0:
			#game_over()
	else:
		return

# This function gets triggered when the DamageCooldown timer finishes
func _on_damage_cooldown_timeout() -> void:
	can_take_damage = true
	

# Reset HP and invincibility flag when the player is initialized or the scene is restarted
func _ready():
	hp = startHP
	can_take_damage = true  # Reset immunity
	$AnimatedSprite2D.texture = AliveTextur

# Game over logic
func game_over():
	print("Game Over!")
	print(can_take_damage)
	# You can implement additional game over logic here, such as:
	# - Show a game over screen
	# - Stop the game
	# - Restart the scene, etc.
