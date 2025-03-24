extends Node2D

@export var bullet_scene: PackedScene
@export var min_rotation = 90
@export var max_rotation = 450
@export var num_bullets = 2
@export var is_random = false
@export var is_parent = false
@export var is_manual = false #false means it uses timer
@export var spawn_rate = 1.6 #if using automatic
@export var bullet_speed = 200
@export var bullet_velocity = Vector2(1, 0)
@export var bullet_lifetime = 10.00
@export var use_velocity = false
@export var movement_min = -300
@export var movement_max = 300
var start_x


var rotations = []
var log_to_console = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = spawn_rate
	$Timer.start()
	start_x = global_position.x

func random_rotations():
	rotations = []
	for i in range(0, num_bullets):
		rotations.append(randf_range(max_rotation, min_rotation))

func distributed_rotations():
	rotations = []
	for i in range(0, num_bullets):
		var fraction = float(i)/float(num_bullets)
		var difference = max_rotation - min_rotation
		rotations.append((fraction * difference) + min_rotation)

func spawn_bullets():
	if (is_random):
		random_rotations()
	else:
		distributed_rotations()
		
	var spawned_bullets = []
	
	for i in range(0, num_bullets):
		var bullet = bullet_scene.instantiate()
		
		spawned_bullets.append(bullet)
		
		if (is_parent):
			add_child(spawned_bullets[i])
		else:
			get_node("/root").add_child(spawned_bullets[i])
		
		spawned_bullets[i].rotation_degrees = rotations[i]
		spawned_bullets[i].speed = bullet_speed
		spawned_bullets[i].velocity = bullet_velocity
		spawned_bullets[i].global_position = global_position
		spawned_bullets[i].use_velocity = use_velocity
		spawned_bullets[i].lifetime = bullet_lifetime
		
		if (log_to_console):
			print("Bullet " + str(i) + " @ " + str(rotations[i]) + " deg")
		
	return spawned_bullets



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_timer_timeout() -> void:
	#move to location
	global_position = Vector2(start_x+randf_range(movement_min, movement_max), global_position.y)
	if !is_manual:
		spawn_bullets()
	if (log_to_console):
		print("Spawned Bullet")
	
