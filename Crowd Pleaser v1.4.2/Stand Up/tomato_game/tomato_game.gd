extends Node2D

func _ready() -> void:
	$GameTimer.start(8.0)

#remaining things to do:
# offset their timers?
# bounding box for player movement (clamp)
# add visuals
# add game end effects

func _on_player_topdown_been_hit() -> void:
	print("got hit L")
	$GameTimer.stop()
	#lose the game


func _on_timer_timeout() -> void:
	print("time's up!")
	$GameTimer.stop()
	#win the game
