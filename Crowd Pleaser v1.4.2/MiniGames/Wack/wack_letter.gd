extends CanvasLayer

# Assets for the text letters >:3
var Q = preload("res://MiniGames/Wack/WackArt/Q.tres")
var W = preload("res://MiniGames/Wack/WackArt/W.tres")
var E = preload("res://MiniGames/Wack/WackArt/E.tres")
var A = preload("res://MiniGames/Wack/WackArt/A.tres")
var S = preload("res://MiniGames/Wack/WackArt/S.tres")
var D = preload("res://MiniGames/Wack/WackArt/D.tres")
var Z = preload("res://MiniGames/Wack/WackArt/Z.tres")
var X = preload("res://MiniGames/Wack/WackArt/X.tres")
var C = preload("res://MiniGames/Wack/WackArt/C.tres")

var expected_letter : int
var expect_input : bool = true
var hits
var key_map = [KEY_Q, KEY_W, KEY_E, KEY_A, KEY_S, KEY_D, KEY_Z, KEY_X, KEY_C]
var labels = []
var labelsB = []
var Letters =[]
var hold = false
var time_scale = 1.0
var is_game_over
var hits_to_win = 4
var letter_map = ["Q", "W", "E", "A", "S", "D", "Z", "X", "C"]
var textureLetter_map = [Q, W, E, A, S, D, Z, X, C] #matches the text letter above

# Textures for the backings (feedback giving)
var idle_texture = preload("res://MiniGames/Wack/WackArt/WackIdle.tres")
var active_texture = preload("res://MiniGames/Wack/WackArt/WackActive.tres")
var hit_texture = preload("res://MiniGames/Wack/WackArt/WackHit.tres")

# Signal to let stage.gd that a game is done
signal gameDone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	labels = [$target0, $target1, $Label3, $Label4, $Label5, $Label6, $Label7, $Label8, $Label9]
	
	# Labels: the backings, Letters: The text
	labelsB = [$A1, $A2, $A3, $B1, $B2, $B3, $C1, $C2, $C3]
	Letters = [$A1/A1letter, $A2/A2letter, $A3/A3letter, $B1/B1letter, $B2/B2letter, $B3/B3letter, $C1/C1letter, $C2/C2letter, $C3/C3letter]
	
	hits = 0
	expect_input = false
	is_game_over = false
	expected_letter = randi() % 9
	print("hello")
	# $HoldTimer.wait_time = 1.0
	# set all to blank
	#clear_all_labels()
	#print("starting hold timer")
	#$HoldTimer.start(1.0*time_scale)

# Moved start here to be callable and not automatically
func startWack() -> void:
	clear_all_labels()
	$HoldTimer.start(1.0*time_scale)

func new_letter(old_letter) -> void:
	# pick random 1-8
	var temp = randi() % 8
	if old_letter <= temp:
		temp += 1
	expected_letter = temp
	if !is_game_over:
		#print("starting hold timer from newletter")
		$HoldTimer.start(1.0*time_scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if expect_input:
		if event is InputEventKey:
			# problem is even if correct letter pressed, else also activates - fixed
			if event.pressed:
				if event.keycode == key_map[expected_letter]:
					# When hit correctly, flashes yellow (timing can be tweaked)
					labelsB[expected_letter].texture = hit_texture
					$HitSfx.play()
					$HitTimer.stop()
					await get_tree().create_timer(0.5).timeout
					#print(expected_letter)
					clear_all_labels()
					hits += 1
					if hits > hits_to_win:
						is_game_over = true
						$WinSfx.play()
						end_game(true)
					else:
						#print(hits)
						expect_input = false
						new_letter(expected_letter)
				else: 
					$MissSfx.play()
					print("why are you here")
					is_game_over = true
					$LooseSfx.play()
					end_game(false)

func clear_all_labels():
	#set all 'labels' to WackIdle
	#labels[0].text = "[ ]"
	#labels[1].text = "[ ]"
	#labels[2].text = "[ ]"
	#labels[3].text = "[ ]"
	#labels[4].text = "[ ]"
	#labels[5].text = "[ ]"
	#labels[6].text = "[ ]"
	#labels[7].text = "[ ]"
	#labels[8].text = "[ ]"
	
	#Set backing to idle texture
	labelsB[0].texture = idle_texture
	labelsB[1].texture = idle_texture
	labelsB[2].texture = idle_texture
	labelsB[3].texture = idle_texture
	labelsB[4].texture = idle_texture
	labelsB[5].texture = idle_texture
	labelsB[6].texture = idle_texture
	labelsB[7].texture = idle_texture
	labelsB[8].texture = idle_texture
	
	# Set letters to invisible
	Letters[0].visible = false
	Letters[1].visible = false
	Letters[2].visible = false
	Letters[3].visible = false
	Letters[4].visible = false
	Letters[5].visible = false
	Letters[6].visible = false
	Letters[7].visible = false
	Letters[8].visible = false

func end_game(did_ya_win):
	expect_input = false
	$HoldTimer.stop()
	$HitTimer.stop()
	print("game done")
	clear_all_labels()
	if did_ya_win:
		global.points += 1;
	else: 
		global.lives -= 1;
	$EndTimer.start(1.0*time_scale)


func _on_hit_timer_timeout() -> void:
	#expect_input = false
	#print("l")
	is_game_over = true
	end_game(false)


func _on_hold_timer_timeout() -> void:
	$HoldTimer.stop()
	#print("ok hold timer ended")
	if !is_game_over:
		#labels[expected_letter].text = "[" + letter_map[expected_letter] + "]"
		labelsB[expected_letter].texture = active_texture
		
		# While loop that hides the other letters
		#for i in range(9):
		#	Letters[i].visible = false;
		
		Letters[expected_letter].visible = true;
		Letters[expected_letter].texture = textureLetter_map[expected_letter]
		
		#$HitTimer.start()
		$HitTimer.start(1.3*time_scale)
		#print("ok started hit timer")
		expect_input = true


func _on_end_timer_timeout() -> void:
	$EndTimer.stop()
	print("game over fr fr") # GAME ENDS
	await get_tree().create_timer(3.0).timeout
	gameDone.emit()
