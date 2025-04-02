extends Area2D

# with the help of:
# https://youtu.be/AnQCs_qgp1c?si=YQPHXTk9lGUN4XSh
# made it to 14 minutes

@export var speed := 300
@export var lifetime := 10.0
@export var velocity = Vector2()
@export var use_velocity = false

func _ready():
	$Timer.start(lifetime)

func _process(delta):
	if use_velocity:
		position += velocity.normalized() * speed * delta
	else:
		position += Vector2(cos(rotation), -sin(rotation)) * speed * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player_topdown":
		body.take_damage()
