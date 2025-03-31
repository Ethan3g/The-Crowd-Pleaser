extends Node2D

signal gameDone

var min_x = 600
var max_x = 990
var min_y = 375
var max_y = 750

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var player = $player_topdown
	player.position.x = clamp(player.position.x, min_x, max_x)
	player.position.y = clamp(player.position.y, min_y, max_y)

func tomato_start() -> void:
	$GameTimer.start(8.0)
	print("GO")

func _on_player_topdown_been_hit() -> void:
	print("got hit L")
	$LooseSfx.play()
	$GameTimer.stop()
	global.lives -= 1
	global.winstate = -1
	gameDone.emit()

func _on_timer_timeout() -> void:
	print("time's up!")
	$WinSfx.play()
	$GameTimer.stop()
	
	$player_topdown.can_take_damage = false
	global.points += 1
	global.winstate = 1
	gameDone.emit()
