extends Node2D

@export var bullet_scene: PackedScene
@export var num_bullets = 2
@export var spawn_rate = 2.0
@export var bullet_lifetime = 10.0
@export var log_to_console = false

# Box boundaries
var min_x = 480
var max_x = 480
var min_y = 400
var max_y = 650

# Spawn positions (now randomized within the box boundaries)
var left_spawn_y = 500
var right_spawn_y = 500
var top_spawn_x = 500
var bottom_spawn_x = 500

func _ready() -> void:
	pass

func spawn_start() -> void:
	$Timer.wait_time = spawn_rate
	$Timer.start()

func spawn_end() -> void:
	$Timer.stop()

func spawn_bullets():
	for i in range(num_bullets):
		var bullet = bullet_scene.instantiate()

		# Step 1: Determine side and spawn correctly
		var spawn_pos = get_specific_outside_position()
		bullet.global_position = spawn_pos

		# Step 2: Target a random point inside the box
		var target_pos = Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))

		# Step 3: Calculate trajectory
		var direction = (target_pos - spawn_pos).normalized()
		
		var random_speed = randf_range(1000, 3000)
		bullet.velocity = direction * random_speed
		bullet.lifetime = bullet_lifetime

		# Step 4: Apply random scale to the bullet
		# Randomly scale between 0.5x and 1.5x of original size
		var random_scale = randf_range(0.5, 1.5)
		bullet.scale = Vector2(random_scale, random_scale)

		# Step 5: Add bullet to scene
		get_node("/root").add_child(bullet)

		if log_to_console:
			print("Bullet spawned at:", spawn_pos, "Targeting:", target_pos)

# Get a fixed spawn position based on side
func get_specific_outside_position() -> Vector2:
	var side = randi_range(0, 3)
	match side:
		0: # Left (Y randomized within box)
			return Vector2(min_x - 50, randf_range(min_y, max_y))
		1: # Right (Y randomized within box)
			return Vector2(max_x + 50, randf_range(min_y, max_y))
		2: # Top (X randomized within box)
			return Vector2(randf_range(min_x, max_x), min_y - 50)
		3: # Bottom (X randomized within box)
			return Vector2(randf_range(min_x, max_x), max_y + 50)
	return Vector2.ZERO

func _on_timer_timeout() -> void:
	spawn_bullets()
