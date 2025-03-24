extends CharacterBody2D

# Movement speed in pixels per second.
@export var speed = 300
@export var startHP = 3
@onready var hp = startHP
var can_take_damage = true
signal been_hit

#implement movement borders

func get_input():
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)

func take_damage():
	if can_take_damage:
		can_take_damage = false
		hp -= 1
		print("ow")
		been_hit.emit()
		#add some kind of timer to be able to be hit again? or if 1 hp end game
	else:
		return
