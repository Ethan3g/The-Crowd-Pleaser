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
var Letters = []
var hold = false
var time_scale = 1.0
var is_game_over
var hits_to_win = 4
var letter_map = ["Q", "W", "E", "A", "S", "D", "Z", "X", "C"]
var textureLetter_map = [Q, W, E, A, S, D, Z, X, C] # matches the text letter above

# Textures for the backings (feedback giving)
var idle_texture = preload("res://MiniGames/Wack/WackArt/WackIdle.tres")
var active_texture = preload("res://MiniGames/Wack/WackArt/WackActive.tres")
var hit_texture = preload("res://MiniGames/Wack/WackArt/WackHit.tres")

# Signal to let stage.gd that a game is done
signal gameDone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize labels and other components
	labels = [$target0, $target1, $Label3, $Label4, $Label5, $Label6, $Label7, $Label8, $Label9]
	
	# Labels: the backings, Letters: The text
	labelsB = [$A1, $A2, $A3, $B1, $B2, $B3, $C1, $C2, $C3]
	Letters = [$A1/A1letter, $A2/A2letter, $A3/A3letter, $B1/B1letter, $B2/B2letter, $B3/B3letter, $C1/C1letter, $C2/C2letter, $C3/C3letter]
	
	hits = 0
	expect_input = false
	is_game_over = false
	expected_letter = randi() % 9
	print("hello")
	# Set all to blank
	clear_all_labels()

# Start the Wack-a-Mole game
func startWack() -> void:
	clear_all_labels()
	hits = 0
	expect_input = false
	is_game_over = false
	new_letter(-1)  # Start with no previous letter
	$HoldTimer.start(1.0*time_scale)

# Generate a new letter to expect
func new_letter(old_letter):
	var temp = randi() % 9
	if old_letter <= temp:
		temp += 1
	expected_letter = temp
	if !is_game_over:
		$HoldTimer.start(1.0*time_scale)

# Clear all labels and reset the game state
func clear_all_labels():
	# Set all labels to idle
	for label in labelsB:
		label.texture = idle_texture
	# Set letters to invisible
	for letter in Letters:
		letter.visible = false

	# Reset expected letter and stop any active game state
	expected_letter = randi() % 9  # Pick a new random letter

# End the game
func end_game(did_ya_win):
	expect_input = false
	$HoldTimer.stop()
	$HitTimer.stop()
	clear_all_labels()
	if did_ya_win:
		global.points += 1
		global.winstate = 1
	else:
		global.lives -= 1
		global.winstate = -1
	$EndTimer.start(1.0*time_scale)

# Handle input events (key presses)
func _input(event: InputEvent) -> void:
	if expect_input:
		if event is InputEventKey:
			if event.pressed:
				if event.keycode == key_map[expected_letter]:
					# Correct letter pressed
					labelsB[expected_letter].texture = hit_texture
					$HitSfx.play()
					$HitTimer.stop()
					await get_tree().create_timer(0.5).timeout
					clear_all_labels()
					hits += 1
					if hits >= hits_to_win:
						is_game_over = true
						$WinSfx.play()
						end_game(true)
					else:
						expect_input = false
						new_letter(expected_letter)
				else:
					# Incorrect letter pressed
					$MissSfx.play()
					is_game_over = true
					$LooseSfx.play()
					end_game(false)

# Handle when the hit timer times out (for timing)
func _on_hit_timer_timeout() -> void:
	is_game_over = true
	end_game(false)

# Handle when the hold timer times out (for timing)
func _on_hold_timer_timeout() -> void:
	$HoldTimer.stop()
	if !is_game_over:
		labelsB[expected_letter].texture = active_texture
		Letters[expected_letter].visible = true
		Letters[expected_letter].texture = textureLetter_map[expected_letter]
		$HitTimer.start(1.3*time_scale)
		expect_input = true

# Handle when the end timer times out (end of game logic)
func _on_end_timer_timeout() -> void:
	$EndTimer.stop()
	print("game over fr fr") # GAME ENDS
	await get_tree().create_timer(3.0).timeout
	gameDone.emit()
