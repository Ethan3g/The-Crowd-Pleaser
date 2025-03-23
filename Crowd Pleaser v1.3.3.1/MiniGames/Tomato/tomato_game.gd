extends Node2D

signal gameDone

func _ready() -> void:
	pass
	#$GameTimer.start(8.0)
	#print("Started")
	
func tomato_start() -> void:
	$GameTimer.start(8.0)
	print("GO")

#remaining things to do:
# offset their timers?
# bounding box for player movement (clamp)
# add visuals
# add game end effects

func _on_player_topdown_been_hit() -> void:
	print("got hit L")
	$LooseSfx.play()
	$GameTimer.stop()
	global.lives -= 1
	
	# Signal here (In Stage, have the delay so that  bullets stop...)
	gameDone.emit()
	#lose the game


func _on_timer_timeout() -> void:
	print("time's up!")
	$WinSfx.play()
	$GameTimer.stop()
	global.points += 1
	gameDone.emit()
	#win the game
